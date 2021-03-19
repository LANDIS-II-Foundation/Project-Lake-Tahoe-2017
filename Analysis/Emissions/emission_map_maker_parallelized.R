library(raster)
library(foreach)

output.dir <- "E:/SNPLMA3/Round1/emissions/"
w.dir <- "E:/SNPLMA3/Round1/"
scenarios <- c("Scenario1", "Scenario2", "Scenario3", "Scenario4", "Scenario5" ) 
replicates <- 1:10
years <- 1:100

#climates <- c("HADGEM2_4.5","HADGEM2_8.5","CanESM_4.5","CanESM_8.5","CNRM5_8.5","CNRM5_4.5", "MIROC5_4.5","MIROC5_8.5")  ##for Round 2 modeling

######################PROJECT RASTER SPATIALLY#########################################
rasterNoProj <- raster(nrow = 712, ncol = 378)
newproj <-  "+proj=utm +zone=11 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
xMin = 215953
yMin = 4287482
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

##Emissions factors based on Urbanski et al. 2014 <http://dx.doi.org/10.1016/j.foreco.2013.05.045>

#Flaming, wildfire
flaming.CO2	  <- 1600
flaming.CO	  <- 135
flaming.CH4	  <- 7.32
flaming.NMOC	<- 59.55
flaming.PM10   <- 27.4
flaming.PM2.5	 <- 23.20
flaming.NOx	   <- 2.0
flaming.NH3   	<- 1.50
flaming.N2O	  <- 0.16
flaming.SO2	  <- 1.06

#Flaming, Rx burns
# rx.flaming.CO2	<- 1598
# rx.flaming.CO	<- 105
# rx.flaming.CH4	<- 4.86
# rx.flaming.NMOC	<- 45.34
# rx.flaming.PM2.5	<- 17.57
# rx.flaming.NOx	<- 2.06
# rx.flaming.NH3	<- 1.53
# rx.flaming.N2O	<- 0.16
# rx.flaming.SO2	<- 1.06

#Smoldering, wildfire
smoldering.CO2   <- 1408
smoldering.CO	   <- 229
smoldering.CH4  	<- 13.94
smoldering.NMOC	  <- 84.9
smoldering.PM2.5  	<- 33
smoldering.PM10   <- 39.9
smoldering.NOx   	<- 0
smoldering.NH3   	<- 0.48
smoldering.N2O    <-	0
smoldering.SO2    	<- 0

#smoldering, RX burns
# rx.smoldering.CO2	<- 1305
# rx.smoldering.CO	<- 271
# rx.smoldering.CH4	<- 7.47
# rx.smoldering.NMOC <-	247.67
# rx.smoldering.PM2.5 <- 50
# rx.smoldering.NOx	<- 0.67
# rx.smoldering.NH3	<- 2.67
# rx.smoldering.N2O	<- 0
# rx.smoldering.SO2	<- 1.76

flaming.factors <- flaming.PM2.5  #can include more of the list above


smoldering.factors <- smoldering.PM2.5 

emission.name <- "PM2.5"

library(doParallel)
cl <- registerDoParallel(cores = 4) 
getDoParWorkers()


foreach(i = 1:4) %dopar% {
  for(replicate in replicates){
#    for(climate in climates)
      for (k in years){
        for(j in 1:length(flaming.factors)){#This is used when automating all maps
        library(raster)        
        scenario <- scenarios[i]
          
          emission.selector <- j #for selecting emissions factor and particulate. This is used when automating all maps
        
        
        flaming.emissions.select <- flaming.factors[emission.selector] #This is used when automating all maps
        smoldering.emissions.select <- smoldering.factors[emission.selector] #This is used when automating all maps
        
        
        map.path <- paste(w.dir, scenario, replicate, "/scrapple-fire/", sep="")
        
        # Flaming emissions
        flaming.map <-raster(paste(map.path, "flaming-consumptions-", years[k], ".img", sep=""), band=1) #change years[1] to years[i]
        flaming.df <- as.data.frame(flaming.map)
        flaming.df.kg <- (flaming.df[,1]* 10000) / 1000 #convert g/m-2 to kg/ha. Multiple by m-2 in a hecatre, dividing by g in a kg
        flaming.emissions <- as.matrix(flaming.df.kg * flaming.emissions.select, ncol=1) #applying emissions factor
        flaming.emissions.Mg <- flaming.emissions/1000 ##converting to Megagrams
        flaming.production.map <- raster(flaming.emissions.Mg, template = flaming.map) #recreating raster
        flaming.production.map@crs <- rasterNoProj@crs
        flaming.production.map@extent <- rasterNoProj@extent
        
        # Smoldering emissions
        smoldering.map <- raster(paste(map.path, "smolder-consumption-", years[k], ".img", sep=""), band =1) #change years[1] to years[i]
        smoldering.df <- as.data.frame(smoldering.map)
        smoldering.df.kg <- (smoldering.df[,1]* 10000) / 1000 #convert g/m-2 to kilograms. Multiple by m-2 in a hecatre, dividing by g in a kg
        smoldering.emissions <- as.matrix(smoldering.df.kg * smoldering.emissions.select, ncol=1)
        smoldering.emissions.Mg <- smoldering.emissions/1000 ##converting to Megagrams
        smoldering.production.map <- raster(smoldering.emissions.Mg, template = smoldering.map)
        smoldering.production.map@crs <- rasterNoProj@crs
        smoldering.production.map@extent <- rasterNoProj@extent
        
        ## Heat production
        ## formula for heat production is (8000 btu/lb) x the fuel consumed during the flaming stage of consumption (fine woody, litter, canopy, shrub) + 10% of the fuel consumed during the smoldering phase of consumption
        ## Units should be in kW/m2 or btu/ft2/min
        ## conversion factors: 453.592 grams/lb, 3412.142btu/hr in 1kW
        ## 
        heat.fuels.lbs <- (flaming.df + (0.1 * smoldering.df)) /453.92 # converting consumed fuels to lbs/m-2
        heat.produced <- as.matrix(8000 * heat.fuels.lbs) # applying heat produced factor to fuels consumed to get btus/m-2
        ##conversion to kW/m2
        heat.produced.kW <- heat.produced/3412.142 #converting from btu/m-2 to kW/m-2
        
        heat.produced.map <- raster(heat.produced, template = smoldering.map)
        heat.produced.map@crs <- rasterNoProj@crs
        heat.produced.map@extent <- rasterNoProj@extent
        
        ## Writing new rasters of emissions
        flaming.raster.name <- paste0(output.dir,"/",scenario, replicate, "_", emission.name[emission.selector], "-Flaming-",years[k], ".tif")
        writeRaster(flaming.production.map, file=flaming.raster.name,
                    datatype='FLT4S', nl=1,overwrite=TRUE)
        
        smoldering.raster.name <- paste0(output.dir,"/",scenario, replicate, "_", emission.name[emission.selector],"-smoldering-",years[k], ".tif")
        writeRaster(smoldering.production.map, file=smoldering.raster.name,  
                    datatype='FLT4S', nl=1,overwrite=TRUE)
        
        heat.raster.name <- paste0(output.dir,"/",scenario,"_", replicate,"_", climate,"_","heat-", years[k], ".tif")
        writeRaster(heat.produced.map, file=heat.raster.name, datatype='FLT4S', nl=1,overwrite=TRUE)
      }
    }
  }
}

stopImplicitCluster()
