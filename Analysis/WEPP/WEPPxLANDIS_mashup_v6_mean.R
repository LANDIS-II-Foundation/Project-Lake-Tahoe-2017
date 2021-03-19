####Call necessary packages###
library(raster)
library(rgdal)
library(ggplot2)
library(spatialEco)
library(sp)
library(dplyr)

######################PROJECT RASTER SPATIALLY#########################################
rasterNoProj <- raster(nrow = 712, ncol = 378)
xMin = 738000.0
yMin = 4288434.0
res <- 100.0
xMax <- xMin + (rasterNoProj@ncols * res)
yMax <- yMin + (rasterNoProj@nrows * res)
rasExt <- extent(xMin,xMax,yMin,yMax)
rasterNoProj@extent <- rasExt
crs(rasterNoProj) <- "+proj=utm +zone=10 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
rasterNoProj@crs
rasterNoProj@extent
rasterNoProj

watershed_raster <- raster("E:/SNPLMA3/sed_yield/watershed_raster.tif")
watershed_raster <- projectRaster(watershed_raster, rasterNoProj, method = "ngb")
watershed_raster
plot(watershed_raster)
########poly_to_raster#############
wd <- "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/lt2021_1_LTW/"
setwd(wd)

ltw_tab <- read.csv("C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/lt2021_1_hill_summary_LTW.csv")

lf <- list.files(pattern = "^.*.shp$")

curcond_sc <- readOGR("C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/lt2021_1_LTW/lt_202012CurCond_subcatchments.shp") 
rcurcornd_sc_watershed <- rasterize(curcond_sc, rasterNoProj, field = "TopazID")
plot(rcurcornd_sc_watershed)
curcond_sc@data$TOT_SDYLD <- curcond_sc@data$SdYd_tn_ha
rcurcornd_sc_sdyld <- rasterize(curcond_sc, rasterNoProj, field = "TOT_SDYLD")
rcurcornd_sc_sdyld[is.na(rcurcornd_sc_sdyld)] <- 0
rcurcond_sdyld <-  rcurcornd_sc_sdyld #rcurcornd_c_sdyld +
writeRaster(rcurcond_sdyld, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rcurcond_sdyld.tif", overwrite = T)

curcond_sc@data$TOT_TP <- curcond_sc@data$TP.kg.ha.
rcurcornd_sc_tp <- rasterize(curcond_sc, rasterNoProj, field = "TOT_TP")
rcurcornd_sc_tp[is.na(rcurcornd_sc_tp)] <- 0
rcurcond_tp <- rcurcornd_sc_tp # rcurcornd_c_tp +
plot(rcurcond_tp)
freq(rcurcond_tp)
hist(rcurcond_tp)

writeRaster(rcurcond_tp, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rcurcond_tp.tif", overwrite = T)

curcond_tab <- subset(ltw_tab, Scenario == "CurCond")
curcond_tab <- curcond_tab[,c(4,29)]
curcond_sc2 <- sp::merge(curcond_sc, curcond_tab, by = "WeppID", duplicateGeoms = TRUE)
rcurcornd_sc_sdyld16 <- rasterize(curcond_sc2, rasterNoProj, field = "Sediment.Yield.of.Particles.Under.0.016.mm..kg.ha.")
rcurcornd_sc_sdyld16[is.na(rcurcornd_sc_sdyld16)] <- 0
rcurcond_sdyld16 <- rcurcornd_sc_sdyld16
plot(rcurcond_sdyld16)

writeRaster(rcurcond_sdyld16, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rcurcond_sdyld16.tif", overwrite = T)

###highsev
HighSev_sc <- readOGR("C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/lt2021_1_LTW/lt_202012HighSev_subcatchments.shp") 
HighSev_sc@data$TOT_SDYLD <- HighSev_sc@data$SdYd_tn_ha
rHighSev_sc_sdyld <- rasterize(HighSev_sc, rasterNoProj, field = "TOT_SDYLD")
rHighSev_sc_sdyld[is.na(rHighSev_sc_sdyld)] <- 0
rHighSev_sdyld <-  rHighSev_sc_sdyld #rHighSev_c_sdyld +
plot(rHighSev_sdyld)
freq(rHighSev_sdyld)

writeRaster(rHighSev_sdyld, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rHighSev_sdyld.tif", overwrite = T)

HighSev_sc@data$TOT_TP <- HighSev_sc@data$TP.kg.ha.
rHighSev_sc_tp <- rasterize(HighSev_sc, rasterNoProj, field = "TOT_TP")
rHighSev_sc_tp[is.na(rHighSev_sc_tp)] <- 0
rHighSev_tp <- rHighSev_sc_tp #rHighSev_c_tp + 
plot(rHighSev_tp)
freq(rHighSev_tp)
hist(rHighSev_tp)

writeRaster(rHighSev_tp, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rHighSev_tp.tif", overwrite = T)

HighSev_tab <- subset(ltw_tab, Scenario == "HighSev")
HighSev_tab <- HighSev_tab[,c(4,29)]
HighSev_tab_sc2 <- sp::merge(HighSev_sc, HighSev_tab, by = "WeppID", duplicateGeoms = TRUE)
rHighSev_sc_sdyld16 <- rasterize(HighSev_tab_sc2, rasterNoProj, field = "Sediment.Yield.of.Particles.Under.0.016.mm..kg.ha.")
rHighSev_sc_sdyld16[is.na(rHighSev_sc_sdyld16)] <- 0
rHighSev_sdyld16 <- rHighSev_sc_sdyld16
plot(rHighSev_sdyld16)

writeRaster(rHighSev_sdyld16, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rHighSev_sdyld16.tif", overwrite = T)

###modsev
ModSev_sc <- readOGR(dsn = "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/lt2021_1_LTW/lt_202012ModSev_subcatchments.shp") 
ModSev_sc@data$TOT_SDYLD <- ModSev_sc@data$SdYd_tn_ha
rModSev_sc_sdyld <- rasterize(ModSev_sc, rasterNoProj, field = "TOT_SDYLD")
rModSev_sc_sdyld[is.na(rModSev_sc_sdyld)] <- 0
rModSev_sdyld <-  rModSev_sc_sdyld #rModSev_c_sdyld +
plot(rModSev_sdyld)

writeRaster(rModSev_sdyld, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rModSev_sdyld.tif", overwrite = T)

ModSev_sc@data$TOT_TP <- ModSev_sc@data$TP.kg.ha.
rModSev_sc_tp <- rasterize(ModSev_sc, rasterNoProj, field = "TOT_TP")
rModSev_sc_tp[is.na(rModSev_sc_tp)] <- 0
rModSev_tp <-  rModSev_sc_tp #rModSev_c_tp +
plot(rModSev_tp)
freq(rModSev_tp)
hist(rModSev_tp)

writeRaster(rModSev_tp, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rModSev_tp.tif", overwrite = T)

ModSev_tab <- subset(ltw_tab, Scenario == "ModSev")
ModSev_tab <- ModSev_tab[,c(4,29)]
ModSev_tab_sc2 <- sp::merge(ModSev_sc, ModSev_tab, by = "WeppID", duplicateGeoms = TRUE)
rModSev_sc_sdyld16 <- rasterize(ModSev_tab_sc2, rasterNoProj, field = "Sediment.Yield.of.Particles.Under.0.016.mm..kg.ha.")
rModSev_sc_sdyld16[is.na(rModSev_sc_sdyld16)] <- 0
rModSev_sdyld16 <- rModSev_sc_sdyld16
plot(rModSev_sdyld16)

writeRaster(rModSev_sdyld16, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rModSev_sdyld16.tif", overwrite = T)

###lowsev
LowSev_sc <- readOGR(dsn = "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/lt2021_1_LTW/lt_202012LowSev_subcatchments.shp") 
LowSev_sc@data$TOT_SDYLD <- LowSev_sc@data$SdYd_tn_ha
rLowSev_sc_sdyld <- rasterize(LowSev_sc, rasterNoProj, field = "TOT_SDYLD")
rLowSev_sc_sdyld[is.na(rLowSev_sc_sdyld)] <- 0
rLowSev_sdyld <-  rLowSev_sc_sdyld #rLowSev_c_sdyld +
plot(rLowSev_sdyld)
freq(rLowSev_sdyld)

writeRaster(rLowSev_sdyld, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rLowSev_sdyld.tif", overwrite = T)

LowSev_sc@data$TOT_TP <- LowSev_sc@data$TP.kg.ha.
rLowSev_sc_tp <- rasterize(LowSev_sc, rasterNoProj, field = "TOT_TP")
rLowSev_sc_tp[is.na(rLowSev_sc_tp)] <- 0
rLowSev_tp <-  rLowSev_sc_tp #rLowSev_c_tp +
plot(rLowSev_tp)
freq(rLowSev_tp)
hist(rLowSev_tp)

writeRaster(rLowSev_tp, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rLowSev_tp.tif", overwrite = T)

LowSev_tab <- subset(ltw_tab, Scenario == "LowSev")
LowSev_tab <- LowSev_tab[,c(4,29)]
LowSev_tab_sc2 <- sp::merge(LowSev_sc, LowSev_tab, by = "WeppID", duplicateGeoms = TRUE)
rLowSev_sc_sdyld16 <- rasterize(LowSev_tab_sc2, rasterNoProj, field = "Sediment.Yield.of.Particles.Under.0.016.mm..kg.ha.")
rLowSev_sc_sdyld16[is.na(rLowSev_sc_sdyld16)] <- 0
rLowSev_sdyld16 <- rLowSev_sc_sdyld16
plot(rLowSev_sdyld16)

writeRaster(rLowSev_sdyld16, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rLowSev_sdyld16.tif", overwrite = T)

###rxfire
PrescFire_sc <- readOGR("C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/lt2021_1_LTW/lt_202012PrescFire_subcatchments.shp") 
PrescFire_sc@data$TOT_SDYLD <- PrescFire_sc@data$SdYd_tn_ha
rPrescFire_sc_sdyld <- rasterize(PrescFire_sc, rasterNoProj, field = "TOT_SDYLD")
rPrescFire_sc_sdyld[is.na(rPrescFire_sc_sdyld)] <- 0
rPrescFire_sdyld <- rPrescFire_sc_sdyld #rPrescFire_c_sdyld + 

writeRaster(rPrescFire_sdyld, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rPrescFire_sdyld.tif", overwrite = T)

PrescFire_sc@data$TOT_TP <- PrescFire_sc@data$TP.kg.ha.
rPrescFire_sc_tp <- rasterize(PrescFire_sc, rasterNoProj, field = "TOT_TP")
rPrescFire_sc_tp[is.na(rPrescFire_sc_tp)] <- 0
rPrescFire_tp <-  rPrescFire_sc_tp #rPrescFire_c_tp +
plot(rPrescFire_tp)
freq(rPrescFire_tp)
hist(rPrescFire_tp)

writeRaster(rPrescFire_tp, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rPrescFire_tp.tif", overwrite = T)

PrescFire_tab <- subset(ltw_tab, Scenario == "PrescFire")
PrescFire_tab <- PrescFire_tab[,c(4,29)]
PrescFire_tab_sc2 <- sp::merge(PrescFire_sc, PrescFire_tab, by = "WeppID", duplicateGeoms = TRUE)
rPrescFire_sc_sdyld16 <- rasterize(PrescFire_tab_sc2, rasterNoProj, field = "Sediment.Yield.of.Particles.Under.0.016.mm..kg.ha.")
rPrescFire_sc_sdyld16[is.na(rPrescFire_sc_sdyld16)] <- 0
rPrescFire_sdyld16 <- rPrescFire_sc_sdyld16
plot(rPrescFire_sdyld16)

writeRaster(rPrescFire_sdyld16, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rPrescFire_sdyld16.tif", overwrite = T)

##mechthin
Thinn85_sc <- readOGR("C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/lt2021_1_LTW/lt_202012Thinn85_subcatchments.shp") 
Thinn85_sc@data$TOT_SDYLD <- Thinn85_sc@data$SdYd.kg.ha
rThinn85_sc_sdyld <- rasterize(Thinn85_sc, rasterNoProj, field = "TOT_SDYLD")
rThinn85_sc_sdyld[is.na(rThinn85_sc_sdyld)] <- 0
rThinn85_sc_sdyld <- rThinn85_sc_sdyld / 1000
rThinn85_sdyld <-  rThinn85_sc_sdyld #rThinn85_c_sdyld +
writeRaster(rThinn85_sdyld, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rThinn85_sdyld.tif", overwrite = T)

Thinn85_sc@data$TOT_TP <- Thinn85_sc@data$TP.kg.ha
rThinn85_sc_tp <- rasterize(Thinn85_sc, rasterNoProj, field = "TOT_TP")
rThinn85_sc_tp[is.na(rThinn85_sc_tp)] <- 0
rThinn85_tp <-  rThinn85_sc_tp #rThinn85_c_tp +

writeRaster(rThinn85_tp, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rThinn85_tp.tif", overwrite = T)

Thinn85_tab <- subset(ltw_tab, Scenario == "Thinn85")
Thinn85_tab <- Thinn85_tab[,c(4,29)]
Thinn85_tab_sc2 <- sp::merge(Thinn85_sc, Thinn85_tab, by = "WeppID", duplicateGeoms = TRUE)
rThinn85_sc_sdyld16 <- rasterize(Thinn85_tab_sc2, rasterNoProj, field = "Sediment.Yield.of.Particles.Under.0.016.mm..kg.ha.")
rThinn85_sc_sdyld16[is.na(rThinn85_sc_sdyld16)] <- 0
rThinn85_sdyld16 <- rThinn85_sc_sdyld16
plot(rThinn85_sdyld16)

writeRaster(rThinn85_sdyld16, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rThinn85_sdyld16.tif", overwrite = T)

##handthin
Thinn96_sc <- readOGR("C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/lt2021_1_LTW/lt_202012Thinn96_subcatchments.shp") 
Thinn96_sc@data$TOT_SDYLD <- Thinn96_sc@data$SdYd.kg.ha
rThinn96_sc_sdyld <- rasterize(Thinn96_sc, rasterNoProj, field = "TOT_SDYLD")
rThinn96_sc_sdyld[is.na(rThinn96_sc_sdyld)] <- 0
rThinn96_sc_sdyld <- rThinn96_sc_sdyld / 1000
rThinn96_sdyld <-  rThinn96_sc_sdyld #rThinn96_c_sdyld +

writeRaster(rThinn96_sdyld, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rThinn96_sdyld.tif", overwrite = T)

rThinn96_sc_tp <- rasterize(Thinn96_sc, rasterNoProj, field = "TP.kg.ha.")
rThinn96_sc_tp[is.na(rThinn96_sc_tp)] <- 0
Thinn96_sc@data$TOT_TP <- Thinn96_sc@data$TP.kg.ha
rThinn96_sc_tp <- rasterize(Thinn96_sc, rasterNoProj, field = "TOT_TP")
rThinn96_tp <- rThinn96_sc_tp #rThinn96_c_tp + 
plot(rThinn96_tp)
freq(rThinn96_tp)
hist(rThinn96_tp)

writeRaster(rThinn96_tp, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rThinn96_tp.tif", overwrite = T)

Thinn96_tab <- subset(ltw_tab, Scenario == "Thinn96")
Thinn96_tab <- Thinn96_tab[,c(4,29)]
Thinn96_tab_sc2 <- sp::merge(Thinn96_sc, Thinn96_tab, by = "WeppID", duplicateGeoms = TRUE)
rThinn96_sc_sdyld16 <- rasterize(Thinn96_tab_sc2, rasterNoProj, field = "Sediment.Yield.of.Particles.Under.0.016.mm..kg.ha.")
rThinn96_sc_sdyld16[is.na(rThinn96_sc_sdyld16)] <- 0
rThinn96_sdyld16 <- rThinn96_sc_sdyld16
plot(rThinn96_sdyld16)

writeRaster(rThinn96_sdyld16, "C:/Users/cjmaxwe3/Downloads/newWEPPresults(1)/newWEPPresults/rasters/rThinn96_sdyld16.tif", overwrite = T)


######Set working directory####
p <- "E:/SNPLMA3/core7_LTB_scen/"

setwd(p)

####Set lists for for loops####
#scen_dir <- "Scenario1"
scen_dir <- c("Scenario2", "Scenario3", "Scenario4", "Scenario5")

scen_rep <- 1:3

scen_clim <- c("HADGEM2_4.5","HADGEM2_8.5","CanESM_4.5","CanESM_8.5","CNRM5_8.5","CNRM5_4.5", "MIROC5_4.5","MIROC5_8.5")

timesteps <- 1:100

###PROJECT RASTER SPATIALLY################################
####convert back to original LANDIS projection#############
rasterNoProj <- raster(nrow = 712, ncol = 378)
xMin = 215953.0
yMin = 4288434.0
res <- 100.0
xMax <- xMin + (rasterNoProj@ncols * res)
yMax <- yMin + (rasterNoProj@nrows * res)
rasExt <- extent(xMin,xMax,yMin,yMax)
rasterNoProj@extent <- rasExt
crs(rasterNoProj) <- "+proj=utm +zone=11 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
rasterNoProj@crs
rasterNoProj@extent
rasterNoProj

####reproject WEPP value rasters to LANDIS projection########
curcond_sy <- projectRaster(rcurcond_sdyld, rasterNoProj)
curcond_tp <- projectRaster(rcurcond_tp, rasterNoProj)
curcond_16 <- projectRaster(rcurcond_sdyld16, rasterNoProj) 
mech_sy <- projectRaster(rThinn85_sdyld, rasterNoProj)
mech_tp <- projectRaster(rThinn85_tp, rasterNoProj)
mech_16 <- projectRaster(rThinn85_sdyld16, rasterNoProj)
hand_sy <- projectRaster(rThinn96_sdyld, rasterNoProj)
hand_tp <- projectRaster(rThinn96_tp, rasterNoProj)
hand_16 <- projectRaster(rThinn96_sdyld16, rasterNoProj)
high_sev_sy <- projectRaster(rHighSev_sdyld, rasterNoProj)
high_sev_tp <- projectRaster(rHighSev_tp, rasterNoProj)
high_sev_16 <- projectRaster(rHighSev_sdyld16, rasterNoProj)
low_sev_sy <- projectRaster(rLowSev_sdyld, rasterNoProj)
low_sev_tp <- projectRaster(rLowSev_tp, rasterNoProj)
low_sev_16 <- projectRaster(rLowSev_sdyld16, rasterNoProj)
mod_sev_sy <- projectRaster(rModSev_sdyld, rasterNoProj)
mod_sev_tp <- projectRaster(rModSev_tp, rasterNoProj)
mod_sev_16 <- projectRaster(rModSev_sdyld16, rasterNoProj)
rx_sev_sy <- projectRaster(rPrescFire_sdyld, rasterNoProj)
rx_sev_tp <- projectRaster(rPrescFire_tp, rasterNoProj)
rx_sev_16 <- projectRaster(rPrescFire_sdyld16, rasterNoProj)

####Calculate landscape values###
cellStats(curcond_16, mean)
cellStats(curcond_sy, sum)
z1 <- zonal(curcond_sy, watershed_raster, mean)
print(z1)
z2 <- zonal(curcond_sy, watershed_raster, sum)
print(z2)
cellStats(curcond_tp, sum)
cellStats(curcond_16, sum)
cellStats(high_sev_sy, sum)
cellStats(high_sev_tp, sum)
cellStats(high_sev_16, sum)
cellStats(low_sev_sy, sum)
cellStats(low_sev_tp, sum)
cellStats(low_sev_16, sum)
cellStats(mod_sev_sy, sum)
cellStats(mod_sev_tp, sum)
cellStats(mod_sev_16, sum)
cellStats(rx_sev_sy, sum)
cellStats(rx_sev_tp, sum)
cellStats(rx_sev_16, sum)

####Look at data##########
plot(watershed_raster)
plot(curcond_sy)

TOT_LTB <- readOGR("E:/SNPLMA3/FMZ_LTB_total.shp")
grid_code <- TOT_LTW@data$gridcode
plot(TOT_LTB)

FMZ_LTW <- readOGR("E:/SNPLMA3/FMZ_LTW_mask4.shp")
plot(FMZ_LTW)

watershed_raster <- raster("E:/SNPLMA3/sed_yield/watershed_raster.tif")
watershed_raster <- projectRaster(watershed_raster, rasterNoProj, method = "ngb")
watershed_raster
plot(watershed_raster)

###############Set empty matrices to hold results######################################################################

i <- scen_dir[2]
j <- scen_rep[1]
k <- scen_clim[1]
l <- timesteps[1]

scen_data <- NULL
all_data <- NULL

scen_data2 <- NULL
all_data2 <- NULL

scen_data3 <- NULL
all_data3 <- NULL

scen_data4 <- NULL
all_data4 <- NULL

scen_data5 <- NULL
all_data5 <- NULL

###########Analysis loops through the clim/scen/rep/year combinations###############

for(i in scen_dir){
  for(j in scen_rep){
    for(k in scen_clim){
      print(paste0(p,i,"_",j,"_",k))  #print current combination
      
      for(l in timesteps){
        rp <- raster(paste0(p,i,"_",j,"_",k,"/harvest/prescripts-",l,".img")) #import harvest prescription file
        
        rp@crs <- rasterNoProj@crs          #spatially project prescription file
        rp@extent <- rasterNoProj@extent
        
        curthin <- rp  #copy and rename prescription file for current conditions analysis
        
        rp[rp[] < 2] <- NA #active and inactive cells set to NA  
        
        mech <- rp == 3
        hand <- rp ==2
        #rp[rp[] > 1] <- 1 #both harvest types reclassified to 1
        
        #plot(rp)
        
        mech_sy[is.na(mech_sy[])] <- 0   #set zero to NA values of WEPP data (so that harvest pixels aren't excluded)
        mech_16[is.na(mech_16[])] <- 0
        mech_tp[is.na(mech_tp[])] <- 0
        
        mech_load <- mech * mech_sy  #multiply the 1/NA mask of prescription by value/0 WEPP file so that only cells with prescription value = 1 wind up with a WEPP value
        mech_16 <- mech * mech_16
        mech_tp <- mech * mech_tp
        
        hand_sy[is.na(hand_sy[])] <- 0   #set zero to NA values of WEPP data (so that harvest pixels aren't excluded)
        hand_16[is.na(hand_16[])] <- 0
        hand_tp[is.na(hand_tp[])] <- 0
        
        hand_load <- hand * hand_sy  #multiply the 1/NA mask of prescription by value/0 WEPP file so that only cells with prescription value = 1 wind up with a WEPP value
        hand_16 <- hand * hand_16
        hand_tp <- hand * hand_tp
        
        
        fi <- paste0(p,i,"_",j,"_",k,"/scrapple-fire/fire-intensity-",l,".img") #bring in fire intensity file
        r <- raster(fi)
        #freq(r)
        r@crs <- rasterNoProj@crs #project fire intensity
        r@extent <- rasterNoProj@extent
        
        r1 <- r == 1  #create new raster of only low intensity fires
        r1[r1[]==0] <- 0  
        
        r2 <- r == 2  #create new raster of only mid intensity fires
        
        m2 <- c(1,2,0,0)  #reassigns mid fires from 1 to 2
        rclmatr2 <- matrix(m2, ncol = 2, byrow = T)
        rmod_fire <- reclassify(r2, rclmatr2)
        
        r3 <- r == 3 #create new raster of only high intensity fires
        m3 <- c(1,3,0,0) #reassigns high fires from 1 to 3
        rclmatr3 <- matrix(m3, ncol = 2, byrow = T)
        rhigh_fire <- reclassify(r3, rclmatr3)
        
        ra <- raster(paste0(p,i,"_",j,"_",k,"/scrapple-fire/ignition-type-",l,".img")) #bring in ignition type
        #freq(ra)
        rx <- ra == 3 #create new raster of Rx fires only
        rx[rx[] == 0] <- 0
        
        rx@crs <- rasterNoProj@crs
        rx@extent <- rasterNoProj@extent
        
        m4 <- c(1,4,0,0) #reassign rx fires as value 4
        rclmatr4 <- matrix(m4, ncol = 2, byrow = T)
        rrx_fire <- reclassify(rx, rclmatr4)
        
        rlow <- rx - r1 #separate rx and low intensity fires
        
        m <- c(-1,4,0,0,1,0) 
        rclmat <- matrix(m, ncol = 2, byrow = T)
        rlow_wildfire <- reclassify(rlow, rclmat)
        
        m1 <- c(4,1,0,0)
        rclmatr5 <- matrix(m1, ncol = 2, byrow = T)
        rlow_wildfire2 <- reclassify(rlow_wildfire, rclmatr5)
        
        all_fire <- rlow_wildfire2 + rmod_fire + rhigh_fire + rrx_fire #rebuild fires such that low = 1, mid = 2, high = 3, rx = 4
        
        r1 <- all_fire == 1 #separate low fires
        r1[r1[] == 0] <- NA #create 1/na mask 
        low_sev_sy[is.na(low_sev_sy[])]<- 0 #assign 0 for NA for wepp files
        low_sev_16[is.na(low_sev_16[])]<- 0
        low_sev_tp[is.na(low_sev_tp[])]<- 0
        r1_load <- r1 * low_sev_sy #multiple masks
        r1_16 <- r1 * low_sev_16
        r1_tp <- r1 * low_sev_tp
        
        r2 <- all_fire == 2
        r2[r2[] == 0] <- NA
        mod_sev_sy[is.na(mod_sev_sy[])]<- 0
        mod_sev_16[is.na(mod_sev_16[])]<- 0
        mod_sev_tp[is.na(mod_sev_tp[])]<- 0
        r2_load <- r2 * mod_sev_sy
        r2_16 <- r2 * mod_sev_16
        r2_tp <- r2 * mod_sev_tp
        
        r3 <- all_fire == 3
        r3[r3[] == 0] <- NA
        high_sev_sy[is.na(high_sev_sy[])]<- 0
        high_sev_16[is.na(high_sev_16[])]<- 0
        high_sev_tp[is.na(high_sev_tp[])]<- 0
        r3_load <- r3 * high_sev_sy
        r3_16 <- r3 * high_sev_16
        r3_tp <- r3 * high_sev_tp
        
        rx <- all_fire == 4        
        rx[rx[] == 0] <- NA
        rx_sev_sy[is.na(rx_sev_sy[])]<- 0
        rx_sev_16[is.na(rx_sev_16[])]<- 0        
        rx_sev_tp[is.na(rx_sev_tp[])]<- 0
        rx_load <- rx * rx_sev_sy
        rx_16 <- rx * rx_sev_16
        rx_tp <- rx * rx_sev_tp
        
        #plot(curthin)
        curthin[curthin[] < 2] <- NA #bring back copy of harvest presciption file from before
        curthin[curthin[] > 1] <- 1
        curthin[is.na(curthin[])] <- 0 #reassign NA back to zero to add together with fire file
        #plot(curthin)
        
        all_fire[all_fire[] > 0] <- 1
        #plot(all_fire)
        unaff <- curthin + all_fire  #create a map of all affected cells
        #plot(unaff)
        
        unaff[unaff[] > 0] <- 1 
        cua <- zonal(unaff, watershed_raster, fun = 'sum') #calculate all of the affected cells
        
        unaff[unaff[] == 0] <- NA #invert map so that unaffected cells have value 1, affected cells have value NA
        unaff[unaff[] == 1] <- 0
        unaff[is.na(unaff[])] <- 1
        plot(unaff)
        
        
        curcond_sy[is.na(curcond_sy)[]]<-0 #multiply 1/na by value/0
        current_load <- curcond_sy * unaff
        #plot(current_load)
        
        curcond_16[is.na(curcond_16)[]]<-0
        current_16 <- curcond_16 * unaff 
        
        curcond_tp[is.na(curcond_tp)[]]<-0
        current_tp <- curcond_tp * unaff   
        
        me_tot <- zonal(mech_load, watershed_raster, fun = 'sum')  #derive zonal stats by watershed for sedyld total
        ha_tot <- zonal(hand_load, watershed_raster, fun = 'sum')
        cu_tot <- zonal(current_load, watershed_raster, fun = 'sum')
        r1_tot <- zonal(r1_load, watershed_raster, fun = 'sum')
        r2_tot <- zonal(r2_load, watershed_raster, fun = 'sum')
        r3_tot <- zonal(r3_load, watershed_raster, fun = 'sum')
        rx_tot <- zonal(rx_load, watershed_raster, fun = 'sum')
        
        me_tp <- zonal(mech_tp, watershed_raster, fun = 'sum')  #derive zonal stats for total phos
        ha_tp <- zonal(mech_tp, watershed_raster, fun = 'sum')  #derive zonal stats for total phos
        cu_tp <- zonal(current_tp, watershed_raster, fun = 'sum')
        r1_tp <- zonal(r1_tp, watershed_raster, fun = 'sum')
        r2_tp <- zonal(r2_tp, watershed_raster, fun = 'sum')
        r3_tp <- zonal(r3_tp, watershed_raster, fun = 'sum')
        rx_tp <- zonal(rx_tp, watershed_raster, fun = 'sum')
        
        me_16 <- zonal(mech_16, watershed_raster, fun = 'sum') #zonal stats for sedyld 16microns
        ha_16 <- zonal(hand_16, watershed_raster, fun =)
        cu_16 <- zonal(current_16, watershed_raster, fun = 'sum')
        r1_16 <- zonal(r1_16, watershed_raster, fun = 'sum')
        r2_16 <- zonal(r2_16, watershed_raster, fun = 'sum')
        r3_16 <- zonal(r3_16, watershed_raster, fun = 'sum')
        rx_16 <- zonal(rx_16, watershed_raster, fun = 'sum')
        
        tha <- zonal(rp, watershed_raster, fun = 'sum') #zonal stats of all cells impacted by type
        r1a <- zonal(r1, watershed_raster, fun = 'sum')
        r2a <- zonal(r2, watershed_raster, fun = 'sum')
        r3a <- zonal(r3, watershed_raster, fun = 'sum')
        rxa <- zonal(rx, watershed_raster, fun = 'sum')
        cua2 <- tha[,2] + r1a[,2] + r2a[,2] + r3a[,2] + rxa[,2] #sum of affected cells as double check (but can allow for double counting of cells harvested and burned)
        
        
        scen_data <- cbind(cu_tot, me_tot, ha_tot, r1_tot, r2_tot, r3_tot, rx_tot, i, j, k, l)        #write outputs to empty matrix
        all_data <- rbind(all_data, scen_data)
        
        scen_data2 <- cbind(cu_tp, me_tp, ha_tp, r1_tp, r2_tp, r3_tp, rx_tp, i, j, k, l)        
        all_data2 <- rbind(all_data2, scen_data2)
        
        scen_data3 <- cbind(cu_16, me_16, ha_16, r1_16, r2_16, r3_16, rx_16, i, j, k, l)        
        all_data3 <- rbind(all_data3, scen_data3)
        
        scen_data4 <- cbind(cua, cua2, tha, r1a, r2a, r3a, rxa, i , j , k, l)
        all_data4 <- rbind(all_data4, scen_data4)
      }
    }
  }
}

write.csv(all_data, "E:/SNPLMA3/sed_yield/sdyd_tn_cu_2-5_v9.csv")   #write csv file
write.csv(all_data2, "E:/SNPLMA3/sed_yield/tp_kg_cu_2-5_v9.csv")  
write.csv(all_data3, "E:/SNPLMA3/sed_yield/s16_kgha_cu_2-5_v9.csv")
write.csv(all_data4, "E:/SNPLMA3/sed_yield/area_tx_2-5_v9.csv")

freq(watershed_raster)
###scenario1_only#####
######Set working directory####
p <- "E:/SNPLMA3/core7_LTB_scen/"

setwd(p)

####Set lists for for loops####
scen_dir <- "Scenario1"
#scen_dir <- c("Scenario2", "Scenario3", "Scenario4", "Scenario5")
i <- scen_dir[1]

scen_rep <- 1:3

scen_clim <- c("HADGEM2_4.5","HADGEM2_8.5","CanESM_4.5","CanESM_8.5","CNRM5_8.5","CNRM5_4.5", "MIROC5_4.5","MIROC5_8.5")

timesteps <- 1:100
scen_data <- NULL
all_data <- NULL

scen_data2 <- NULL
all_data2 <- NULL

scen_data3 <- NULL
all_data3 <- NULL

scen_data4 <- NULL
all_data4 <- NULL

scen_data5 <- NULL
all_data5 <- NULL

###########Analysis loops through the clim/scen/rep/year combinations###############

for(i in scen_dir){
  for(j in scen_rep){
    for(k in scen_clim){
      print(paste0(p,i,"_",j,"_",k))  #print current combination
      
      for(l in timesteps){
        #rp <- raster(paste0(p,i,"_",j,"_",k,"/harvest/prescripts-",l,".img")) #import harvest prescription file
        
        #rp@crs <- rasterNoProj@crs          #spatially project prescription file
        #rp@extent <- rasterNoProj@extent
        
        #curthin <- rp  #copy and rename prescription file for current conditions analysis
        
        #rp[rp[] < 2] <- NA #active and inactive cells set to NA  
        
        #mech <- rp == 3
        #hand <- rp ==2
        
        #rp[rp[] > 1] <- 1 #both harvest types reclassified to 1
        
        #plot(rp)
        
        #mech_sy[is.na(mech_sy[])] <- 0   #set zero to NA values of WEPP data (so that harvest pixels aren't excluded)
        #mech_16[is.na(mech_16[])] <- 0
        #mech_tp[is.na(mech_tp[])] <- 0
        
        #mech_load <- mech * mech_sy  #multiply the 1/NA mask of prescription by value/0 WEPP file so that only cells with prescription value = 1 wind up with a WEPP value
        #mech_16 <- mech * mech_16
        #mech_tp <- mech * mech_tp
        
        #hand_sy[is.na(hand_sy[])] <- 0   #set zero to NA values of WEPP data (so that harvest pixels aren't excluded)
        #hand_16[is.na(hand_16[])] <- 0
        #hand_tp[is.na(hand_tp[])] <- 0
        
        #hand_load <- hand * hand_sy  #multiply the 1/NA mask of prescription by value/0 WEPP file so that only cells with prescription value = 1 wind up with a WEPP value
        #hand_16 <- hand * hand_16
        #hand_tp <- hand * hand_tp
        
        fi <- paste0(p,i,"_",j,"_",k,"/scrapple-fire/fire-intensity-",l,".img") #bring in fire intensity file
        r <- raster(fi)
        freq(r)
        r@crs <- rasterNoProj@crs #project fire intensity
        r@extent <- rasterNoProj@extent
        
        r1 <- r == 1  #create new raster of only low intensity fires
        r1[r1[]==0] <- 0  
        rlow_wildfire2 <- r1
        
        r2 <- r == 2  #create new raster of only mid intensity fires
        
        m2 <- c(1,2,0,0)  #reassigns mid fires from 1 to 2
        rclmatr2 <- matrix(m2, ncol = 2, byrow = T)
        rmod_fire <- reclassify(r2, rclmatr2)
        
        r3 <- r == 3 #create new raster of only high intensity fires
        m3 <- c(1,3,0,0) #reassigns high fires from 1 to 3
        rclmatr3 <- matrix(m3, ncol = 2, byrow = T)
        rhigh_fire <- reclassify(r3, rclmatr3)
        
        ra <- raster(paste0(p,i,"_",j,"_",k,"/scrapple-fire/ignition-type-",l,".img")) #bring in ignition type
        freq(ra)
        #rx <- ra == 3 #create new raster of Rx fires only
        #rx[rx[] == 0] <- 0
        
        #rx@crs <- rasterNoProj@crs
        #rx@extent <- rasterNoProj@extent
        
        #m4 <- c(1,4,0,0) #reassign rx fires as value 4
        #rclmatr4 <- matrix(m4, ncol = 2, byrow = T)
        #rrx_fire <- reclassify(rx, rclmatr4)
        
        #rlow <- rx - r1 #separate rx and low intensity fires
        
        #m <- c(-1,4,0,0,1,0) 
        #rclmat <- matrix(m, ncol = 2, byrow = T)
        #rlow_wildfire <- reclassify(rlow, rclmat)
        
        #m1 <- c(4,1,0,0)
        #rclmatr5 <- matrix(m1, ncol = 2, byrow = T)
        #rlow_wildfire2 <- reclassify(rlow_wildfire, rclmatr5)
        
        all_fire <- rlow_wildfire2 + rmod_fire + rhigh_fire #+ rrx_fire #rebuild fires such that low = 1, mid = 2, high = 3, rx = 4
        
        r1 <- all_fire == 1 #separate low fires
        r1[r1[] == 0] <- NA #create 1/na mask 
        low_sev_sy[is.na(low_sev_sy[])]<- 0 #assign 0 for NA for wepp files
        low_sev_16[is.na(low_sev_16[])]<- 0
        low_sev_tp[is.na(low_sev_tp[])]<- 0
        r1_load <- r1 * low_sev_sy #multiple masks
        r1_16 <- r1 * low_sev_16
        r1_tp <- r1 * low_sev_tp
        
        r2 <- all_fire == 2
        r2[r2[] == 0] <- NA
        mod_sev_sy[is.na(mod_sev_sy[])]<- 0
        mod_sev_16[is.na(mod_sev_16[])]<- 0
        mod_sev_tp[is.na(mod_sev_tp[])]<- 0
        r2_load <- r2 * mod_sev_sy
        r2_16 <- r2 * mod_sev_16
        r2_tp <- r2 * mod_sev_tp
        
        r3 <- all_fire == 3
        r3[r3[] == 0] <- NA
        high_sev_sy[is.na(high_sev_sy[])]<- 0
        high_sev_16[is.na(high_sev_16[])]<- 0
        high_sev_tp[is.na(high_sev_tp[])]<- 0
        r3_load <- r3 * high_sev_sy
        r3_16 <- r3 * high_sev_16
        r3_tp <- r3 * high_sev_tp
        
        #rx <- all_fire == 4        
        #rx[rx[] == 0] <- NA
        #rx_sev_sy[is.na(rx_sev_sy[])]<- 0
        #rx_sev_16[is.na(rx_sev_16[])]<- 0        
        #rx_sev_tp[is.na(rx_sev_tp[])]<- 0
        #rx_load <- rx * rx_sev_sy
        #rx_16 <- rx * rx_sev_16
        #rx_tp <- rx * rx_sev_tp
        
        #plot(curthin)
        #curthin[curthin[] < 2] <- NA #bring back copy of harvest presciption file from before
        #curthin[curthin[] > 1] <- 1
        #curthin[is.na(curthin[])] <- 0 #reassign NA back to zero to add together with fire file
        #plot(curthin)
        
        all_fire[all_fire[] > 0] <- 1
        #plot(all_fire)
        unaff <- all_fire  #create a map of all affected cells
        #plot(unaff)
        
        unaff[unaff[] > 0] <- 1 
        unaff
        watershed_raster
        cua <- zonal(unaff, watershed_raster, fun = 'sum') #calculate all of the affected cells
        
        unaff[unaff[] == 0] <- NA #invert map so that unaffected cells have value 1, affected cells have value NA
        unaff[unaff[] == 1] <- 0
        unaff[is.na(unaff[])] <- 1
        #plot(unaff)
        
        
        curcond_sy[is.na(curcond_sy)[]]<-0 #multiply 1/na by value/0
        current_load <- curcond_sy * unaff
        #plot(current_load)
        
        curcond_16[is.na(curcond_16)[]]<-0
        current_16 <- curcond_16 * unaff 
        
        curcond_tp[is.na(curcond_tp)[]]<-0
        current_tp <- curcond_tp * unaff   
        
        #me_tot <- zonal(mech_load, watershed_raster, fun = 'sum')  #derive zonal stats by watershed for sedyld total
        #ha_tot <- zonal(hand_load, watershed_raster, fun = 'sum')
        cu_tot <- zonal(current_load, watershed_raster, fun = 'sum')
        r1_tot <- zonal(r1_load, watershed_raster, fun = 'sum')
        r2_tot <- zonal(r2_load, watershed_raster, fun = 'sum')
        r3_tot <- zonal(r3_load, watershed_raster, fun = 'sum')
        #rx_tot <- zonal(rx_load, watershed_raster, fun = 'sum')
        
        #me_tp <- zonal(mech_tp, watershed_raster, fun = 'sum')  #derive zonal stats for total phos
        #ha_tp <- zonal(mech_tp, watershed_raster, fun = 'sum')  #derive zonal stats for total phos
        cu_tp <- zonal(current_tp, watershed_raster, fun = 'sum')
        r1_tp <- zonal(r1_tp, watershed_raster, fun = 'sum')
        r2_tp <- zonal(r2_tp, watershed_raster, fun = 'sum')
        r3_tp <- zonal(r3_tp, watershed_raster, fun = 'sum')
        #rx_tp <- zonal(rx_tp, watershed_raster, fun = 'sum')
        
        #me_16 <- zonal(mech_16, watershed_raster, fun = 'sum') #zonal stats for sedyld 16microns
        #ha_16 <- zonal(hand_16, watershed_raster, fun =)
        cu_16 <- zonal(current_16, watershed_raster, fun = 'sum')
        r1_16 <- zonal(r1_16, watershed_raster, fun = 'sum')
        r2_16 <- zonal(r2_16, watershed_raster, fun = 'sum')
        r3_16 <- zonal(r3_16, watershed_raster, fun = 'sum')
        #rx_16 <- zonal(rx_16, watershed_raster, fun = 'sum')
        
        #tha <- zonal(rp, watershed_raster, fun = 'sum') #zonal stats of all cells impacted by type
        r1a <- zonal(r1, watershed_raster, fun = 'sum')
        r2a <- zonal(r2, watershed_raster, fun = 'sum')
        r3a <- zonal(r3, watershed_raster, fun = 'sum')
        #rxa <- zonal(rx, watershed_raster, fun = 'sum')
        #cua2 <-  r1a[,2] + r2a[,2] + r3a[,2]  #sum of affected cells as double check (but can allow for double counting of cells harvested and burned)
        
        
        scen_data <- cbind(cu_tot, r1_tot, r2_tot, r3_tot, i, j, k, l)        #write outputs to empty matrix
        all_data <- rbind(all_data, scen_data)
        
        scen_data2 <- cbind(cu_tp, r1_tp, r2_tp, r3_tp, i, j, k, l)        
        all_data2 <- rbind(all_data2, scen_data2)
        
        scen_data3 <- cbind(cu_16, r1_16, r2_16, r3_16, i, j, k, l)        
        all_data3 <- rbind(all_data3, scen_data3)
        
        scen_data4 <- cbind(cua, cua2, r1a, r2a, r3a, i , j , k, l)
        all_data4 <- rbind(all_data4, scen_data4)
      }
    }
  }
}

write.csv(all_data, "E:/SNPLMA3/sed_yield/sdyd_tnha_cu_1_v9.csv")   #write csv file
write.csv(all_data2, "E:/SNPLMA3/sed_yield/tp_kgha_cu_1_v9.csv")  
write.csv(all_data3, "E:/SNPLMA3/sed_yield/s16_kgha_cu_1_v9.csv")
write.csv(all_data4, "E:/SNPLMA3/sed_yield/area_tx_1_v9.csv")
