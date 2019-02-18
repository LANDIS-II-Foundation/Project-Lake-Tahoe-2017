##This script creates input maps for NECN-H Successionfrom inputs previously found in Century Succession
##For now, instead of using new spatial data, we are simplying converting ecoregion info into surfaces
##Basic proccess:
##1 - Read in ecoregion maps
##2 - Series of reclass functions to change ecoregion code into parameter-specific value (i.e. drainage class)
##3 - Export map
##Map generation will be automated, parameter generation will not be
##Alec Kretchun, Portland State 2017

##Read things
library(raster)
library(rgdal)

dat.dir <- "I:/SNPLMA2/LTB_Modeling/LTB_WorkingCopy/ClimateChangeFuelTreatments_Low-Ignitions/"
out.dir <- "I:/SNPLMA3/Data/NECN_H_maps/"

necn.file <- read.table("I:/LANDIS_code/GitHub/Extension-NECN-Succession/trunk/tests/v6.2-No-Ecoregion/century-succession_landscape.txt", 
                        skip = 11, fill=TRUE) ##getting necessary map names from NECN example input file
necn.mapnames <- grep("MapName", necn.file[,1], value=TRUE) ##List of maps that NECN-H requires
century.filename <- "century-succession-A2.txt"
century.file <- read.table(paste(dat.dir, century.filename, sep=""), skip = 97, fill=TRUE) #skipping straight to the ecoregion parameter sections of century
century.ecoregion.info <- read.csv(paste(out.dir, "Old_LTB_ecoregion_inputs.csv", sep=""))  ##This is from an externally generated csv if ecoregion parameters from the old Century ext
ecoregion.map <- raster(paste(dat.dir, "ecoregions5.img", sep=""))
eco.extent <- extent(ecoregion.map)

##Run from here down to produce new maps
ecoregion.df <- as.data.frame(ecoregion.map)
ecoregion.list <- sort(unique(ecoregion.df[,2]))
ecoregion.list <- ecoregion.list[ecoregion.list!=0]

##Replace each ecoregion value with corresponding soil property value
eco.variable.col <- 26
eco.variable <- century.ecoregion.info[,eco.variable.col] ##Selecting the Century input to replace

ecoregion.df[ecoregion.df==ecoregion.list[1]] <- eco.variable[1] ##replacing individual value. Makes ure ecoregion.df gets reset
ecoregion.df[ecoregion.df==ecoregion.list[2]] <- eco.variable[2]
ecoregion.df[ecoregion.df==ecoregion.list[3]] <- eco.variable[3]
ecoregion.df[ecoregion.df==ecoregion.list[4]] <- eco.variable[4]
ecoregion.df[ecoregion.df==ecoregion.list[5]] <- eco.variable[5]

eco.values <- as.numeric(ecoregion.df[,2])
raster.matrix <- t(matrix(eco.values, nrow = ncol(ecoregion.map), ncol = nrow(ecoregion.map)))
eco.reclass <- raster(raster.matrix)
extent(eco.reclass) <- eco.extent
plot(eco.reclass)

century.colnames <- colnames(century.ecoregion.info)
raster.name <- century.colnames[eco.variable.col] 
writeRaster(eco.reclass, file=paste(out.dir, raster.name, ".img", sep=""))
