library(raster)
library(rgeos)
library(rgdal)
library(tidyverse)
library(spatialEco)

ltw <- readOGR("E:/SNPLMA3/FMZ_LTW_total.shp")

######################RASTER SPATIAL TEMPLATE#########################################
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

wd <- "F:/SNPLMA3/Documents/Fire/Emissions/Maps/"  #location of emissions outputs (from R script emission_map_maker_parallelized)
setwd(wd)

scen_dir <- c("Scenario1", "Scenario2", "Scenario3") #subset of scenarios--4 and 5 are not included in this manuscript because of Rx fires, which are handled in a separate script
scen_rep <- c("rep1", "rep2", "rep3", "rep4", "rep5","rep6","rep7", "rep8", "rep9")
timestep <- 1:100

LTW <- raster("E:/SNPLMA3/ltw_total_raster.tif")  ##LTW mask
LTW

i <- scen_dir[1]
j <- scen_rep[1]
k <- timestep[1]

scen_data <- NULL
rxscen_data <- NULL
all_data <- NULL

for(i in scen_dir){
  for(j in scen_rep){
    fd <- paste0(wd,i,"/",j,"/")
    print(fd)
    setwd(fd)
    lf <- list.files(fd)
    sta <- stack()
    i2 <- gsub("S","s", i)
    j2 <- str_extract(j, "\\d+")
    j3 <- gsub("rep","replicate",j)
    
    for(k in timestep){
      pattern <- paste0(i2,"_",j2,"_PM2.5.*-",k,".tif")
      print(pattern)
      st <- grep(pattern, lf, value = T) #grab both flaming and smoldering outputs
      sta <- stack(st)  
      sta@crs <- rasterNoProj@crs
      sta@extent <- rasterNoProj@extent
      
      print(paste0("F:/SNPLMA3/Round1/",i,"/",j3,"/scrapple-fire/day-of-fire-",k,".img"))
      
      df <- raster(paste0("F:/SNPLMA3/Round1/",i,"/",j3,"/scrapple-fire/day-of-fire-",k,".img"))  #find day of fire information
      df@crs <- rasterNoProj@crs
      df@extent <- rasterNoProj@extent
      df_w <- mask(df, LTW) #mask to LTW
      
      staig1 <- mask(sta, df) #mask emissions to day of fire
      staig1ltw <- mask(staig1, LTW)  ##mask emissions to ltw
      uniday <- zonal(staig1ltw, df, fun='sum') #zonal stats across both flaming and smoldering
      colnames(uniday) <- c("day", "PM2.5.Flaming", "PM2.5.Smoldering")
      scen_data <- cbind(uniday, i, j, k)
      
      all_data <- rbind(scen_data, rxscen_data, all_data)
      
    }
  }
} 

all_data<- as.data.frame(all_data)

colnames(all_data) <- c("Day", "PM2.5.Flaming", "PM2.5.Smoldering", "Scenario", "Replicate", "Year")  

#colnames(all_data) <- c("day","Ch4.Flaming", "Ch4.Smoldering","CO.Flaming", "CO.Smoldering", "CO2.Flaming", "CO2.Smoldering", "N2O.Flaming", "N2O.Smoldering", "NH3.Flaming", "NH3.Smoldering", "NMOC.Flaming", "NMOC.Smoldering",
#                        "NOx.Flaming", "NOx.Smoldering", "PM10.Flaming", "PM10.Smoldering", "PM2.5.Flaming", "PM2.5.Smoldering", "SO2.Flaming", "SO2.Smoldering", "scenario", "replicate",  "year", "ig.type")

#write.csv(all_data, "F:/SNPLMA3/Round1/LTW_annual_emissions_scen1-3_r1.csv") #intermediate save

#####this section spreads the smoldering emissions across three days
all_data$Day <- as.numeric(all_data$Day)
all_data$PM2.5.Flaming <- as.numeric(all_data$PM2.5.Flaming)
all_data$PM2.5.Smoldering <- as.numeric(all_data$PM2.5.Smoldering)
all_data$Year <- as.numeric(all_data$Year)

timesteps <- 1:100
t <- timesteps[1]
r <- scen_rep[1]
i <- dfire[1]

all_data2 <- subset(all_data, Day > 0)
all_data2 <- subset(all_data2, PM2.5.Flaming > 0)

all_data3 <- NULL
all_data4 <- NULL
all_data6 <- NULL

for(s in scen_dir){
  for(r in scen_rep){
    for(t in timesteps){
    fe1 <- subset(all_data2, Scenario == s)  
    fe <- subset(fe1, Year == t)
    fe2 <- subset(fe, Replicate == r)
    dfire <- sort(unique(fe2$Day))
    
    #  i <- dfire[2]
    #  
    #    for(i in dfire){
    #      numcells <- sum(fe2$day == i)
    #      pmf <- sum(fe2[which(fe2[,1] == i) ,2])
    #      pms <- sum(fe2[which(fe2[,1] == i) ,3])
    #      fdata <- cbind(i, numcells, pmf, pms)
    #      all_data <- rbind(all_data, fdata)
    #    }
    
    #all_data2 <- as.data.frame(all_data)
    
    for(i in dfire){
      i2 <- i+1
      i3 <- i+2
      pms1 <- (fe2[which(fe2[,1] == i),3])*0.5  #smoldering day of fire
      pms2 <- (fe2[which(fe2[,1] == i),3])*0.3  #smoldering day after
      pms3 <- (fe2[which(fe2[,1] == i),3])*0.2  #smoldering two days after
      pmf1 <- (fe2[which(fe2[,1] == i),2])
      #num1 <- (all_data2[which(all_data2[,1] == i),2])
      tpmi <- pmf1 + pms1
      c_var <- cbind(i, tpmi)
      r1_var <- cbind(i2, pms2)
      r2_var <- cbind(i3, pms3)
      cr1_var<- rbind(c_var, r1_var, r2_var)
      all_data3 <- rbind(all_data3, cr1_var)
      all_data4 <- cbind(all_data3, s, r, t)
    }
    all_data6 <- rbind(all_data4, all_data6)  ##stitch the file back together
    }
  }
}


all_data6 <- as.data.frame(all_data6)
colnames(all_data6) <- c("Day", "TotPM", "Scenario", "Replicate", "Year")  

all_data6$Day <- as.numeric(all_data6$Day)
all_data6$TotPM <- as.numeric(all_data6$TotPM)
all_data6$Year <- as.numeric(all_data6$Year)
all_data6$Scenario <- as.factor(all_data6$Scenario)
all_data6$Replicate <- as.factor(all_data6$Replicate)

all_data5 <- all_data6 %>%                       ##sum across identical days to get total pm2.5 for a calendar day
  group_by(Scenario, Replicate, Year, Day) %>%
  summarise(Total_PM2.5 = sum(TotPM))

write.csv(all_data5, "F:/SNPLMA3/Round1/LTW_emissions_scen1-3_r1_byday.csv")

####annual emissions figure#############
library(ggplot2)
library(scales)

cbPalette <- c("#D55E00", "#CC79A7", "#56B4E9","#959595"  , "#009E73", "#F0E442", "#0072B2", "#E69F00")

r1_s1_5 <- read.csv("F:/SNPLMA3/Round1/R1S1-5_annual_cumulative_emissions.csv")

r1_ace <- ggplot(data = r1_s1_5, mapping = aes(x = Year, y = MeanCumPM2.5, linetype = Scenario, fill = Scenario)) +
  geom_line() +
  geom_ribbon(aes(ymax = MeanCumPM2.5 + SDCumPM2.5, ymin = MeanCumPM2.5 - SDCumPM2.5), alpha = 0.7) +
  scale_y_continuous(labels = comma) +
  scale_fill_manual(values=cbPalette) +
  labs(y = "Mean Cumulative PM2.5 Emissions (Mg)") +
  theme_bw()

plot(r1_ace)

pdf("F:/SNPLMA3/Round1/r1s1-5_cumulative_emissionsv5.pdf",         # File name
    width = 5, 
    height = 5, # Width and height in inches
)

plot(r1_ace)

dev.off()

