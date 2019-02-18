##This script adds biomass values to IC text file, updating it for us in NECN-H ext
##This is only applicable for updates to old LANDIS-II IC files
##For this specific conversion, I am going to copy/paste first sevarl ICs until plot cns are used (line 30)
##Alec Kretchun, PSU, 2017

options(scipen=999) #This removes scientific notation in printing. Plot CNs are very long

#Set up directories
w.dir <- "I:/SNPLMA3/LANDIS_modeling/LTW_NECN_H/"
out.dir <- "I:/SNPLMA3/LANDIS_modeling/LTW_NECN_H/R_derived_inputs/"
data.dir <- "I:/SNPLMA3/Data/FIA/"

##Read things
fia.dat <- read.csv(paste(data.dir, "forest_age_estimates.csv", sep=""))
ic.old <- read.table(paste(w.dir, "init-commLTB.txt", sep=""), skip = 29, fill=TRUE) ##Coercing cohort ages into next rows. NOT GOOD

#Setting up stock shrub communities
shrubs <- c("NonnResp", "FixnResp")
shrub.one <-  paste("NonnResp 20 (50) 50 (100)")
shrub.two <- paste("FixnResp 20 (50) 50 (100)")

##Conversion factors for biomass
TPA.factor <- 6.018046 #trees/acre adjust (TPA in FIA)
conv.factor <- .112085 #Convert from lbs/acre to g/m-2
##Select relevant columns from FIA
fia.dat.select <- fia.dat[,c(2, 4, 6, 12, 24)]
plot.cns <- unique(fia.dat.select[,3]) #Getting unique plot CNs from FIA

######################Calculate FIA biomass###############################
##Summing biomass by cohort on every plot of FIA data. 
fia.cohort.plot <- NULL
for (i in plot.cns){
  fia.cn.select <- subset(fia.dat.select, fia.dat.select[,3]==i)
  for (j in unique(fia.cn.select$sp_name)){
    spp.select <- subset(fia.cn.select, fia.cn.select$sp_name == j)
    spp.biomass <- tapply(spp.select$AGLB_tons, spp.select$age_pred10, sum) #summing across cohort
    spp.cohort <- cbind(rep(j, length(spp.biomass)), rep(unique(spp.select$plot), length(spp.biomass)), 
                      as.numeric(names(spp.biomass)), spp.biomass) #creating new dataframe of ic-related info
    colnames(spp.cohort) <- c("sp_name", "plot_cn", "age_cohort", "biomass_total")
    fia.cohort.plot <- rbind(fia.cohort.plot, spp.cohort)
    }
}
rm(i)

fia.cohort.plot <- fia.cohort.plot[complete.cases(fia.cohort.plot),] ##144 Nas entries in biomass from 20553 total cohort entries

####################Match up IC mapcode with plot CNs############################################

mapcodes <- unique(ic.old[grep("MapCode", ic.old[,1]),2]) #getting ic mapcodes to loop through
mapcode.lines <- grep("MapCode", ic.old[,1])
mapcode.lines <- c(mapcode.lines, (nrow(ic.old)+1)) #adding final line number for loop

mapcode.plots <- NULL
shrub.nums <- NULL

##Looping through ic file to extract mapcodes, plot cns, and extract number of shrubs per plot
for(i in 1:(length(mapcode.lines)-1)){
  IC.start <- mapcode.lines[i] #isolating IC rows
  IC.end <- mapcode.lines[i+1]-1#isolating IC rows
  IC.select <- ic.old[IC.start:IC.end, ] ##isolating IC rows. Right now, cutting off last IC
  mapcode.plot <- t(IC.select[1:2,2])
  shrub.num <- sum(table(shrubs[shrubs %in% IC.select[,1]])) #If only 1 shrub, its NonnResp
  ic.info <- cbind(mapcode.plot, shrub.num)
  mapcode.plots <- rbind(mapcode.plots, ic.info)
  #shrub.nums <- rbind(shrub.nums, shrub.num)
  #print(shrub.num)
}
rm(i)
colnames(mapcode.plots) <- c("MapCode", "plot_cn", "shrub_num")

##Match mapcodes to plot cns
fia.ic.merge <- merge(fia.cohort.plot, mapcode.plots, by = "plot_cn")


#fia.ic.merge <- subset(fia.ic.merge, fia.ic.merge[,5] == 5) ##single ic code for testing purposes
IC.output.file <- paste(out.dir, "LTB_NECNH_IC.txt", sep="")
ic.spp.list <- NULL
##Looping through FIA data to create new IC file
##Should I include FIA plot cn like Louise did?
for (l in unique(fia.ic.merge$MapCode)){ ##Loop for individual mapcode
  ic.mapcode.select <- subset(fia.ic.merge, fia.ic.merge$MapCode==l)
  IC.mapcode <- noquote(paste("MapCode ", l)) ##This is hardcoded as 4 because thats our target IC for the FIA sites
  cat(NULL, file=IC.output.file, sep="\n", append=TRUE)#write blank space
  cat(IC.mapcode, file=IC.output.file, "\n", append=TRUE) #write  mapcode
  for (k in unique(ic.mapcode.select$sp_name)){ ##Loop for individual species
    ic.spp.select <- subset(ic.mapcode.select, ic.mapcode.select$sp_name==k)
    ic.cohort.biomass.list <-NULL
    for (m in unique(ic.spp.select$age_cohort)){
      ic.cohort.select <- subset(ic.spp.select, ic.spp.select$age_cohort==m)
      ic.cohort.biomass.lbs <- as.numeric(levels(ic.cohort.select$biomass_total))[ic.cohort.select$biomass_total] #converting to numeric     
      ic.cohort.biomass.gm <- (ic.cohort.biomass.lbs/TPA.factor) * conv.factor #converting from lbs/acre to lbs/m-2
      ic.cohort.biomass <- paste(m, " (", round(ic.cohort.biomass.gm), ")", sep="")
      ic.cohort.biomass.list <- c(ic.cohort.biomass.list, ic.cohort.biomass)
      ic.spp.list <- c(k, ic.cohort.biomass.list)
      #cat(ic.cohort.biomass.list, file=IC.output.file, "\n", append=TRUE)
    }
    cat(ic.spp.list, file=IC.output.file, "\n", append=TRUE)
  }
  cat(shrub.one, file=IC.output.file, "\n", append=TRUE) #printing Non n-fixing shrubs, which are in every cell
  if (unique(ic.spp.select$shrub_num)==2){ 
    cat(shrub.two, file=IC.output.file, "\n", append=TRUE)  #Printing N-fixing suhrubs, which are NOT in every cell
  }
}

rm(l)
rm(k)
rm(m)


############THIS IS MOOT UNTIL I SAY OTHERWISE#########################
##Looping through each MapCode
##Steps are: 1) single out MapCode/Plot #
##2) Single out species
##3) Sum FIA biomass by cohort age
##4) single out age cohort
##5) Assign total biomass to cohort, as "Age (Biomass)"
##6) Write to text file
# mapcodes <- unique(ic.old[grep("MapCode", ic.old[,1]),2]) #getting ic mapcodes to loop through
# mapcode.lines <- grep("MapCode", ic.old[,1])
# mapcode.lines <- c(mapcode.lines, (nrow(ic.old)+1)) #adding final line number for loop
# 
# x.mapcode.plots <- NULL
# shrub.nums <- NULL
# for(i in 1:(length(mapcode.lines)-1)){
#   IC.start <- mapcode.lines[i] #isolating IC rows
#   IC.end <- mapcode.lines[i+1]-1#isolating IC rows
#   IC.select <- ic.old[IC.start:IC.end, ] ##isolating IC rows. Right now, cutting off last IC
#   x.mapcode.plot <- t(IC.select[2,1:2])
#   x.mapcode.plots <- rbind(mapcode.plots, mapcode.plot)
#   shrub.num <- sum(table(shrubs[shrubs %in% IC.select[,1]]))  
#   shrub.nums <- rbind(shrub.nums, shrub.num)
#   
#   #print(shrub.num)
# }
# rm(i)
####################THIS ONE DOESN"T DO SHRUB NUMBER##########################
##Match up IC mapcode with plot CNs
##Looping through IC file to get mapcode/plot cn combos
# mapcodes <- unique(ic.old[grep("MapCode", ic.old[,1]),2]) #getting ic mapcodes to loop through
# mapcode.lines <- grep("MapCode", ic.old[,1])
# #mapcode.lines <- c(mapcode.lines, (nrow(ic.old)+1)) #adding final line number for loop
# 
# mapcode.plots <- NULL
# for(i in 1:length(mapcode.lines)){
#   IC.start <- mapcode.lines[i] #isolating IC rows
#   IC.lines.select <- ic.old[IC.start:(IC.start+1),]
#   mapcode.plot <- t(IC.lines.select[,2])
#   mapcode.plots <- rbind(mapcode.plots, mapcode.plot)
# }
# rm(i)

# ALB <- 17500 #this is in lbs
# TPA.factor <- 6.018046 #trees/acre adjust (TPA in FIA)
# conv.factor <- .112085 #Convert from lbs/acre to g/m-2
# 
# (ALB/TPA.factor) * conv.factor
# ALB * conv.factor
