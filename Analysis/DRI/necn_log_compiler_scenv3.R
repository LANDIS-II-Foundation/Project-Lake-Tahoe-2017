library(raster)
library(rgdal)
library(ggplot2)
library(spatialEco)

p <- "E:/SNPLMA3/core7_LTB_scen//"

setwd(p)
scen_dir <- c("Scenario1", "Scenario2", "Scenario3", "Scenario4", "Scenario5")

scen_rep <- 1:3

scen_clim <- c("HADGEM2_4.5","HADGEM2_8.5","CanESM_4.5","CanESM_8.5","CNRM5_8.5","CNRM5_4.5", "MIROC5_4.5","MIROC5_8.5")

timesteps <- 1:100

FMZ_LTW <- readOGR("E:/SNPLMA3/FMZ_LTW_mask4.shp")
grid_code <- FMZ_LTW@data$gridcode
plot(FMZ_LTW)

nsl_data <- NULL
sl_data <- NULL
bdl_data <- NULL
snsl_data <- NULL
spl_data <- NULL 
h_data <- NULL

for(i in scen_dir){
  for(j in scen_rep){
    for(k in scen_clim){
      pattern <- paste0(p,i,"_",j,"_",k,"/")
      climate <- k
      rep <- j
      scenario <- i
      
      h <- read.csv(paste0(pattern,"/harvest/summary-log.csv"))
      h <- cbind(h, climate, scenario, rep)
      h_data<- rbind(h, h_data)
      
      nsl <- read.csv(paste0(pattern,"/NECN-succession-log.csv"))
      nsl <- cbind(nsl, climate, scenario, rep)
      nsl_data<- rbind(nsl, nsl_data)
      
      sl <- read.csv(paste0(pattern,"/scrapple-events-log.csv"))
      sl <- cbind(sl, climate, scenario, rep)
      sl_data<- rbind(sl, sl_data)        
      
      bdl <- read.csv(paste0(pattern,"/bda_log.csv"))
      bdl <- cbind(bdl, climate, scenario, rep)
      bdl_data<- rbind(bdl, bdl_data)        
      
      snsl <- read.csv(paste0(pattern,"/NECN-succession-log-short.csv"))
      snsl <- cbind(snsl, climate, scenario, rep)
      snsl_data<- rbind(snsl, snsl_data)
      
      spl <- read.csv(paste0(pattern,"/spp-biomass-log.csv"))
      spl <- cbind(spl, climate, scenario, rep)
      spl_data<- rbind(spl, spl_data)
    }
  }
}


write.csv(nsl_data, "F:/SNPLMA3/nsl_data.csv")
write.csv(sl_data, "F:/SNPLMA3/sl_data.csv")
write.csv(bdl_data, "F:/SNPLMA3/bdl_data.csv")
write.csv(snsl_data, "F:/SNPLMA3/snsl_data.csv")
write.csv(spl_data, "F:/SNPLMA3/spl_data.csv")
write.csv(h_data, "F:/SNPLMA3/h_data.csv")

