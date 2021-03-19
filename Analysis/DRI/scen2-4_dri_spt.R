library(raster)
library(rgdal)
library(ggplot2)
library(spatialEco)

##################CORE7_scenv2#################

p <- "E:/SNPLMA3/core7_LTB_scen/"

setwd(p)

scen_dir <-  c("Scenario2", "Scenario3", "Scenario4")

scen_rep <- 1:3

#scen_clim <- "CanESM_4.5"
scen_clim <- c("HADGEM2_4.5","HADGEM2_8.5","CanESM_4.5","CanESM_8.5","CNRM5_8.5","CNRM5_4.5", "MIROC5_4.5","MIROC5_8.5")

timesteps <- 1:100
########################################

FMZ_LTW <- readOGR("E:/SNPLMA3/FMZ_LT_mask4.shp")
grid_code <- FMZ_LTW@data$gridcode
plot(FMZ_LTW)

TOT_LTW <- readOGR("E:/SNPLMA3/FMZ_LTW_total.shp")
grid_code <- TOT_LTW@data$gridcode
plot(TOT_LTW)


######################PROJECT RASTER SPATIALLY#########################################
rasterNoProj <- raster(nrow = 712, ncol = 378)
newproj <-  "+proj=utm +zone=11 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
xMin = 215953.866743
yMin = 4287482.2105
res <- 100.0
xMax <- xMin + (rasterNoProj@ncols * res)
yMax <- yMin + (rasterNoProj@nrows * res)
rasExt <- extent(xMin,xMax,yMin,yMax)
rasterNoProj@extent <- rasExt
crs(rasterNoProj) <- "+proj=utm +zone=11 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
rasterNoProj@crs
rasterNoProj@extent
rasterNoProj
#####################################################################################

LTW <- rasterize(FMZ_LTW, rasterNoProj)
fltw <- freq(LTW)
fltwa <- fltw[,2]
fltwa <- fltwa[1:5]

i <- scen_dir[1]
j <- scen_rep[1]
k <- scen_clim[1]
l <- timesteps[1]

scen_data <- NULL
all_data <- NULL

for(i in scen_dir){
  for(j in scen_rep){
    for(k in scen_clim){
      for(l in timesteps){
        path <- paste0(p,i,"_",j,"_", k,"/scrapple-fire/fire-intensity-",l,".img")
        print(path)
        r1 <- raster(path)
        r1@crs <- rasterNoProj@crs
        r1@extent <- rasterNoProj@extent
        r1[r1[] == 3] <- 0
        r1[r1[] >1] <- 1
        
        r2 <- raster(paste0(p,i,"_",j,"_", k,"/harvest/biomass-removed-",l,".img"))
        r2@crs <- rasterNoProj@crs
        r2@extent <- rasterNoProj@extent
        #plot(r2)
        r2[r2[] >1] <- 1
        
        lf2 <- list.files(path = paste0(p,i,"_",j,"_", k,"/bda/"), pattern = ".*.img", full.names = T)
        
        patt1 <- grep(pattern = paste0(".*-",l,".img"), lf2, value = T)  
        #print(patt1)
        
        pattnrd <- grep(pattern = paste0(".*-NRD-",l,".img"), lf2, value = T)  
        
        pattsrd <- grep(pattern = paste0(".*-SRD-",l,".img"), lf2, value = T)  
        
        patt <- patt1[!patt1 %in% pattnrd]
        patt <- patt[!patt %in% pattsrd]
        print(patt)
        
        if(length(patt) > 0){
          
          ins <- stack(patt)
        #  plot(ins)
          ins@crs <- rasterNoProj@crs
          ins@extent <- rasterNoProj@extent  
          
          ins2 <- sum(ins)
          ins3 <- ins2
          
          ins3[ins3[] == 0] <- NA
          
          mins2 <- cellStats(ins3, min)
          
          ins2[ins2[] <= mins2] <- 0
          ins2[ins2[] > mins2] <- 1
        }
        #  plot(ins2)
          
        firez <- zonal(r1, LTW, 'sum')
        harz <- zonal(r2, LTW, 'sum')
        inz <- zonal(ins2, LTW, 'sum')
        scen_data <- cbind(firez,harz, inz, fltwa, i, j, k, l)
        all_data <- rbind(scen_data, all_data)
        }
      }
    }
  }
}

write.csv(all_data, "E:/SNPLMA3/core7_LTB_scen/scen2-4_dri_spt_v2.csv")
