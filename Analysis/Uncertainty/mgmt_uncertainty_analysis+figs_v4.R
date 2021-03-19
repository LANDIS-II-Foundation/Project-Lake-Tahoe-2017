library(rgeos)
library(spatialEco)
library(rgdal)
library(ggplot2)
library(cowplot)
library(ggExtra)
library(ggpubr)
library(lattice)

setwd("E:/SNPLMA3")

FMZ_LTW <- readOGR("FMZ_LTW_mask4.shp")
plot(FMZ_LTW, col=c("red", "blue" , "green", "yellow"))

group.colors <- c(Low = '#05A05A', Medium = '#FFD700', High = '#FF3300', Total_wildfire = '#C0C0C0', Rx = '#326ADA', All_fire = '#696969')
scen.colors <- c(Scenario1 = '#0000FF', Scenario2 = '#FF0000', Scenario3 = '#008000', Scenario4 = '#FFD700')
clim_colors <- c(CanESM_4.5 = '#CC0000', CanESM_8.5 = '#990000', CNRM5_4.5 = 'wheat1', CNRM5_8.5 = 'wheat3', HADGEM2_4.5 = '#1475FF', HADGEM2_8.5 = '#022B97', MIROC5_4.5 = '#bbbbbb', MIROC5_8.5 = '#828282')

factor.colors <- c(A = '#0000FF', B = '#FF0000', C = '#008000', D = '#FFD700', E = 'light_grey', G = 'dark_grey' )

fancy_scientific <- function(l) {
  # turn in to character string in scientific notation
  l <- format(l, scientific = TRUE)
  l <- gsub("0e\\+00","0",l)
  # quote the part before the exponent to keep all the digits
  l <- gsub("^(.*)e", "'\\1'e", l)
  # turn the 'e+' into plotmath format
  l <- gsub("e", "%*%10^", l)
  # return this as an expression
  parse(text=l)
}

lmp <- function (modelobject) {
  f <- summary(modelobject)$fstatistic
  p <- pf(f[1],f[2],f[3],lower.tail=F)
  attributes(p) <- NULL
  return(p)
}
##############################################################

totc <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/LTB_totc_allclim_allscen_avgreps_scenv3.csv")
totc$RCP <- as.factor(totc$RCP)
scenC <- ggplot(totc, aes(x = Year, y = Mean, linetype = RCP, fill = Climate)) +
  geom_line(size = 1) +
  geom_ribbon(aes(ymax = Mean + SD, ymin = Mean - SD), alpha = 0.6) +
  theme_bw() + 
  theme(text= element_text(size = 24), legend.position="bottom") +
  coord_cartesian(ylim=c(0, 225)) +
  facet_wrap(~Scenario, ncol = 5 ) +
  scale_fill_manual(values = clim_colors)
scenC + labs(title = "Mean Total Carbon (Mg/ha), Lake Tahoe Basin", y = "C Mg/ha", fill = "Climate Projection")

fire_5_7 <- read.csv("E:/SNPLMA3/Scenv3/LTB_fire_byinten_allclim_allscen_scenv3.csv")
fire_5_7$RCP <- as.factor(fire_5_7$RCP)
levels(fire_5_7$Type)

fire_high <- subset(fire_5_7, Severity == "High")
fireh <- ggplot(fire_high, aes(x = Year, y = Cumulative_ha, fill = Climate )) +
  geom_line(aes(linetype = RCP), size = 1, alpha = 0.9) +
  #  geom_line(aes(x = Year, y = Cumulative, color = Severity)) +
  #  geom_ribbon(aes(ymax = Cumulative + SD, ymin = Cumulative - SD, fill = Severity), alpha = 0.3) +
  geom_ribbon(aes(ymax = Cumulative_ha + SD_ha, ymin = Cumulative_ha - SD_ha), alpha = 0.7) +
  facet_wrap(~Scenario, ncol = 5) +
  theme_bw() +
  theme(text= element_text(size = 24), legend.position = 'bottom') +
  scale_fill_manual(values = clim_colors) +
  scale_color_manual(values = clim_colors, guide = F) +
  scale_y_continuous(labels=fancy_scientific)
fireh + labs(title = "High severity fire area, Lake Tahoe West", y = "Cumulative mean fire area (in hectares)", fill = "Climate Projection")

fire_tot <- subset(fire_5_7, Type == "Total Wildfire")
firet <- ggplot(fire_tot, aes(x = Year, y = Cumulative, fill = Climate )) +
  geom_line(aes(color = Climate)) +
  #  geom_line(aes(x = Year, y = Cumulative, color = Severity)) +
  #  geom_ribbon(aes(ymax = Cumulative + SD, ymin = Cumulative - SD, fill = Severity), alpha = 0.3) +
  geom_ribbon(aes(ymax = Cumulative + CumulativeSD, ymin = Cumulative - CumulativeSD), alpha = 0.9) +
  facet_wrap(~Scenario, ncol = 5) +
  theme_bw() +
  theme(text= element_text(size = 36), legend.position = 'bottom') +
  scale_fill_manual(values = clim_colors) +
  scale_color_manual(values = clim_colors, guide = F) +
  scale_y_continuous(labels=fancy_scientific)
firet + labs(title = "Total wildfire area, Lake Tahoe Basin", y = "Cumulative mean fire area (in hectares)", fill = "Climate Projection")

totc <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/LTB_totc_allclim_allscen_avgreps_scenv3.csv")
scenC <- ggplot(totc, aes(x = Year, y = Mean, fill = Climate)) +
  geom_line() +
  geom_ribbon(aes(ymax = Mean + SD, ymin = Mean - SD), alpha = 0.7) +
  theme_bw() + 
  theme(text= element_text(size = 36), legend.position="bottom") +
  coord_cartesian(ylim=c(0, 225)) +
  facet_wrap(~Scenario, ncol = 5 ) +
  scale_fill_manual(values = clim_colors)
scenC + labs(title = "Mean Total Carbon (Mg/ha), Lake Tahoe Basin", y = "C Mg/ha", fill = "Climate Projection")

fire_5_7 <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/LTB_fire_high_tot_cum_allclim_scenv3.csv")
levels(fire_5_7$Type)

fire_high <- subset(fire_5_7, Type == "High")
fireh <- ggplot(fire_high, aes(x = Year, y = Cumulative, fill = Climate )) +
  geom_line(aes(color = Climate)) +
  #  geom_line(aes(x = Year, y = Cumulative, color = Severity)) +
  #  geom_ribbon(aes(ymax = Cumulative + SD, ymin = Cumulative - SD, fill = Severity), alpha = 0.3) +
  geom_ribbon(aes(ymax = Cumulative + CumulativeSD, ymin = Cumulative - CumulativeSD), alpha = 0.9) +
  facet_wrap(~Scenario, ncol = 5) +
  theme_bw() +
  theme(text= element_text(size = 36), legend.position = 'bottom') +
  scale_fill_manual(values = clim_colors) +
  scale_color_manual(values = clim_colors, guide = F) +
  scale_y_continuous(labels=fancy_scientific)
fireh + labs(title = "High severity fire area, Lake Tahoe Basin", y = "Cumulative mean fire area (in hectares)", fill = "Climate Projection")


###multipanel###########
fire_tot <- subset(fire_5_7, Type == "Total Wildfire")

scenC <- ggplot(totc, aes(x = Year, y = Mean, fill = Climate)) +
  geom_line() +
  geom_ribbon(aes(ymax = Mean + SD, ymin = Mean - SD), alpha = 0.7) +
  theme_bw() + 
  theme(text= element_text(size = 24),axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) +
  coord_cartesian(ylim=c(0, 225)) +
  facet_wrap(~Scenario, ncol = 5 ) +
  scale_fill_manual(values = clim_colors)
scen2 <- scenC + labs(title = '', y = "C Mg/ha", fill = "Climate Projection")

firet <- ggplot(fire_tot, aes(x = Year, y = Cumulative, fill = Climate )) +
  geom_line(aes(color = Climate)) +
  #  geom_line(aes(x = Year, y = Cumulative, color = Severity)) +
  #  geom_ribbon(aes(ymax = Cumulative + SD, ymin = Cumulative - SD, fill = Severity), alpha = 0.3) +
  geom_ribbon(aes(ymax = Cumulative + CumulativeSD, ymin = Cumulative - CumulativeSD), alpha = 0.9) +
  facet_wrap(~Scenario, ncol = 5) +
  theme_bw() +
  theme(text= element_text(size = 24), axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) +
  scale_fill_manual(values = clim_colors) +
  scale_color_manual(values = clim_colors, guide = F) +
  scale_y_continuous(labels=fancy_scientific)
fire2 <- firet + labs(title = "", y = "Cum. Total Fire", fill = "Climate Projection")

fireh <- ggplot(fire_high, aes(x = Year, y = Cumulative, fill = Climate )) +
  geom_line(aes(color = Climate)) +
  #  geom_line(aes(x = Year, y = Cumulative, color = Severity)) +
  #  geom_ribbon(aes(ymax = Cumulative + SD, ymin = Cumulative - SD, fill = Severity), alpha = 0.3) +
  geom_ribbon(aes(ymax = Cumulative + CumulativeSD, ymin = Cumulative - CumulativeSD), alpha = 0.9) +
  facet_wrap(~Scenario, ncol = 5) +
  theme_bw() +
  theme(text= element_text(size = 24)) +
  scale_fill_manual(values = clim_colors) +
  scale_color_manual(values = clim_colors, guide = F) +
  scale_y_continuous(labels=fancy_scientific)
fireh2 <- fireh + labs(title = "", y = "Cum. High Sev.", fill = "Climate Projection")

ggarrange(scen2, fire2, fireh2,
          labels= c('A',"B","C"), heights = c(1,1,1),
          ncol = 1, nrow = 3, legend = 'right', common.legend = T, align = "v")

#################################
library(car)
library(cowplot)
library(tidyr)
library(ggpubr)

allanc <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/LTB_fire_analysis.csv")
totc <- allanc

model.1 = lm (Carbon ~ Climate + Scenario, data = allanc)

Anova(model.1, type="II")
summary(model.1)

timesteps <- 1:100
#timesteps <- c(10,20,30,40,50,60,70,80,90,100)
i <- timesteps[10]

all_data <- NULL
pval_data <- NULL
all_data2 <- NULL

for(i in timesteps){
  ti <- subset(totc, Year == i) 
  model.2 = lm(Carbon ~ Climate + Scenario, data = ti)
  a1 <- Anova(model.2, type = "II")
  fval <- a1$`Pr(>F)`
  summ <- summary(model.2)
  ars <- summ$adj.r.squared
  pval <- summ$coefficients[,4]
  fstat <- summ$fstatistic
  fp <- pf(fstat[1],fstat[2],fstat[3],lower.tail=F)
  sumsq <- a1$`Sum Sq`
  Climate <- sumsq[1]
  Management <- sumsq[2]
  Error <- sumsq[3]
  Magn <- (sumsq[1] + sumsq[2] + sumsq[3])

  propor <- cbind(Climate, Management, Error, Magn, fval, ars, i)
  all_data <- rbind(all_data, propor)
  
  pval_data <- cbind(pval, i)
  all_data2 <- rbind(all_data2, pval_data)
}

all_data <- as.data.frame(all_data)
all_data$i <- as.factor(all_data$i)
tanc <- gather(all_data, i, value, Climate:ars)
colnames(tanc) <- c('year', 'type', 'value')
tanc$type <- as.factor(tanc$type)
tanc$year <- as.numeric(tanc$year)

write.csv(tanc, "E:/SNPLMA3/Scenv3/Manuscript/C_anova_annual_v3.csv")
write.csv(all_data2,"E:/SNPLMA3/Scenv3/Manuscript/C_anova_annual_v2_pvalues.csv" )

tanc <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/C_anova_annual_2.csv")
tanc <- subset(tanc, Factor != "Magnitude")
tanc$Factor = reorder(tanc$Factor, tanc$Order)
levels(tanc$Factor)

tac <- ggplot(tanc, aes(x = Year, y = Relativized.Value, color = Factor, linetype = Factor)) +
  geom_hline(yintercept = 0.05) + 
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 36), legend.position = 'bottom') +
  #scale_color_manual(values = factor.colors, guide = F) +
  #scale_linetype_manual(values = factor.lines, guide = T) +
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  labs(title = '', x = 'Model Year', y = 'Variance (SS) explained by factor, relativized', color = "", linetype = "" )
tac

deanc <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/LTB_fire_analysis_deacde.csv")

model.1 = lm (Carbon ~ Climate + Scenario, data = deanc)

Anova(model.1, type="II")
summary(model.1)

#timesteps <- 1:100
timesteps <- c(10,20,30,40,50,60,70,80,90,100)
i <- timesteps[10]
all_data <- NULL

for(i in timesteps){
  ti <- subset(deanc, Year == i) 
  model.2 = lm(Carbon ~ Climate + Scenario, data = ti)
  a1 <- Anova(model.2, type = "II")
  fval <- a1$`Pr(>F)`
  summ <- summary(model.2)
  ars <- summ$adj.r.squared
  pval <- summ$coefficients[,4]
  fstat <- summ$fstatistic
  fp <- pf(fstat[1],fstat[2],fstat[3],lower.tail=F)
  sumsq <- a1$`Sum Sq`
  Climate <- sumsq[1]
  Management <- sumsq[2]
  Error <- sumsq[3]
  Magn <- (sumsq[1] + sumsq[2] + sumsq[3])
  
  propor <- cbind(Climate, Management, Error, Magn, fval, ars, i)
  all_data <- rbind(all_data, propor)
  
  pval_data <- cbind(pval, i)
  all_data2 <- rbind(all_data2, pval_data)
}

all_data <- as.data.frame(all_data)
all_data$i <- as.factor(all_data$i)
tanc <- gather(all_data, i, value, Climate:ars)
colnames(tanc) <- c('year', 'type', 'value')
tanc$type <- as.factor(tanc$type)
tanc$year <- as.numeric(tanc$year)

write.csv(tanc, "E:/SNPLMA3/Scenv3/Manuscript/C_anova_decade_v3.csv")
write.csv(all_data2,"E:/SNPLMA3/Scenv3/Manuscript/C_anova_decade_v2_pvalues.csv" )

danc <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/C_anova_decade_2.csv")
#danc$Order <- as.factor(danc$Order)
danc$Factor = reorder(danc$Factor, danc$Order)

dac <- ggplot(danc, aes(x = Decade, y = Relativized.Value, color = Factor, linetype = Factor)) +
  geom_hline(yintercept = 0.05) + 
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 36), legend.position = 'bottom') +
  guides(color = F, linetype = F)+
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  labs(title = '', x = 'Model Year', y = "", color = '', linetype = '')
dac

ggarrange(tac, dac, common.legend = T, legend = "right")


c_anova_pval <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/C_anova_decade_v2_pvalues.csv")

cap <- ggplot(c_anova_pval, aes( x = Year, y = P_value, color = Variable, linetype = Time)) +
  geom_hline(yintercept = 0.05) + 
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 36), legend.position = 'bottom')
cap  

###############Total_Fire###################
allanc <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/LTB_fire_analysis.csv")

model.1 = lm (Total ~ Climate + Scenario, data = allanc)

Anova(model.1, type="II")
summary(model.1)

#anovaVCA(Carbon ~ Climate + Scenario, allanc)

timesteps <- 1:100
#timesteps <- c(10,20,30,40,50,60,70,80,90,100)
#i <- timesteps[10]
all_data <- NULL

for(i in timesteps){
  ti <- subset(allanc, Year == i) 
  model.2 = lm(Total ~ Climate + Scenario, data = ti)
  a1 <- Anova(model.2, type = "II")
  fval <- a1$`Pr(>F)`
  summ <- summary(model.2)
  ars <- summ$adj.r.squared
  pval <- summ$coefficients[,4]
  fstat <- summ$fstatistic
  fp <- pf(fstat[1],fstat[2],fstat[3],lower.tail=F)
  sumsq <- a1$`Sum Sq`
  Climate <- sumsq[1]
  Management <- sumsq[2]
  Error <- sumsq[3]
  Magn <- (sumsq[1] + sumsq[2] + sumsq[3])
  
  propor <- cbind(Climate, Management, Error, Magn, fval, ars, i)
  all_data <- rbind(all_data, propor)
  
  pval_data <- cbind(pval, i)
  all_data2 <- rbind(all_data2, pval_data)
}

all_data <- as.data.frame(all_data)
#all_data$i <- as.factor(all_data$i)
tanc <- gather(all_data, i, value, Climate:ars)
#colnames(tanc) <- c('year', 'type', 'value')
tanc$type <- as.factor(tanc$type)
tanc$year <- as.numeric(tanc$year)

write.csv(tanc, "E:/SNPLMA3/Scenv3/Manuscript/total_anova_annual_v3.csv")

tanc1 <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/total_anova_annual_4.csv")
tanc <- subset(tanc1, Factor != "Magnitude")
levels(tanc$Factor)
tanc1$Factor = reorder(tanc1$Factor, tanc1$Order)
levels(tanc1$Factor)

tac <- ggplot(tanc1, aes(x = Year, y = Relativized.Value, color = Factor, linetype = Factor)) +
  geom_hline(yintercept = 0.05) + 
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 36), legend.position = 'bottom') +
  #scale_color_manual(values = factor.colors, guide = T) +
  #scale_linetype_manual(values = factor.lines, guide = F) +
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  labs(title = '', x = 'Model Year', y = 'Variance (SS) explained by factor, relativized', color = "", linetype = "" )
tac

deanc <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/LTB_fire_analysis_deacde.csv")

model.1 = lm (Total ~ Climate + Scenario, data = deanc)

Anova(model.1, type="II")
summary(model.1)

timesteps <- 1:100
timesteps <- c(10,20,30,40,50,60,70,80,90,100)
i <- timesteps[10]
all_data <- NULL

for(i in timesteps){
  ti <- subset(deanc, Decade == i) 
  model.2 = lm(Total ~ Climate + Scenario, data = ti)
  a1 <- Anova(model.2, type = "II")
  fval <- a1$`Pr(>F)`
  summ <- summary(model.2)
  ars <- summ$adj.r.squared
  pval <- summ$coefficients[,4]
  fstat <- summ$fstatistic
  fp <- pf(fstat[1],fstat[2],fstat[3],lower.tail=F)
  sumsq <- a1$`Sum Sq`
  Climate <- sumsq[1]
  Management <- sumsq[2]
  Error <- sumsq[3]
  Magn <- (sumsq[1] + sumsq[2] + sumsq[3])
  
  propor <- cbind(Climate, Management, Error, Magn, fval, ars, i)
  all_data <- rbind(all_data, propor)
  
  pval_data <- cbind(pval, i)
  all_data2 <- rbind(all_data2, pval_data)
}

all_data <- as.data.frame(all_data)
#all_data$i <- as.factor(all_data$i)
tanc <- gather(all_data, i, value, Climate:ars)
#colnames(tanc) <- c('year', 'type', 'value')
tanc$type <- as.factor(tanc$type)
tanc$year <- as.numeric(tanc$year)

write.csv(tanc, "E:/SNPLMA3/Scenv3/Manuscript/total_anova_decade_4.csv")

danc1 <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/total_anova_decade_2.csv")
danc1$Factor = reorder(danc1$Factor, danc1$Order)
levels(danc1$Factor)
#danc <- subset(danc, Factor != "Magnitude")

dac <- ggplot(danc1, aes(x = Decade, y = Relativized.Value, color = Factor, linetype = Factor)) +
  geom_hline(yintercept = 0.05) + 
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 36), legend.position = 'bottom') +
  guides(color = F, linetype = F)+
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  labs(title = '', x = 'Model Year', y = "", color = '', linetype = '')
dac

ggarrange(tac, dac, common.legend = T, legend = "right")

#####HIGH_fire########
allanc <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/LTB_fire_analysis.csv")

model.1 = lm (High ~ Climate + Scenario, data = allanc)

Anova(model.1, type="II")
summary(model.1)

#anovaVCA(Carbon ~ Climate + Scenario, allanc)

timesteps <- 2:100
#timesteps <- c(10,20,30,40,50,60,70,80,90,100)
#i <- timesteps[10]
all_data <- NULL

for(i in timesteps){
  ti <- subset(allanc, Year == i) 
  model.2 = lm(High ~ Climate + Scenario, data = ti)
  a1 <- Anova(model.2, type = "II")
  fval <- a1$`Pr(>F)`
  summ <- summary(model.2)
  ars <- summ$adj.r.squared
  pval <- summ$coefficients[,4]
  fstat <- summ$fstatistic
  fp <- pf(fstat[1],fstat[2],fstat[3],lower.tail=F)
  sumsq <- a1$`Sum Sq`
  Climate <- sumsq[1]
  Management <- sumsq[2]
  Error <- sumsq[3]
  Magn <- (sumsq[1] + sumsq[2] + sumsq[3])
  
  propor <- cbind(Climate, Management, Error, Magn, fval, ars, i)
  all_data <- rbind(all_data, propor)
  
  pval_data <- cbind(pval, i)
  all_data2 <- rbind(all_data2, pval_data)
}

all_data <- as.data.frame(all_data)
#all_data$i <- as.factor(all_data$i)
tanc <- gather(all_data, i, value, Climate:ars)
#colnames(tanc) <- c('year', 'type', 'value')
tanc$type <- as.factor(tanc$type)
tanc$year <- as.numeric(tanc$year)

write.csv(tanc, "E:/SNPLMA3/Scenv3/Manuscript/high_anova_annual_4.csv")

tanc2 <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/high_anova_annual_2.csv")
levels(tanc2$Factor)
tanc2$Factor = reorder(tanc2$Factor, tanc2$Order)
levels(tanc2$Factor)

tac <- ggplot(tanc2, aes(x = Year, y = Relativized.Value, color = Factor, linetype = Factor)) +
  geom_hline(yintercept = 0.05) + 
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 36), legend.position = 'bottom') +
  #scale_color_manual(values = factor.colors, guide = T) +
  #scale_linetype_manual(values = factor.lines, guide = F) +
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  ylim(0,1) +
  labs(title = '', x = 'Model Year', y = 'Variance (SS) explained by factor, relativized', color = "", linetype = "" )
tac


tanc <- subset(tanc, Factor != "Magnitude")
tanc$Factor
tac <- ggplot(tanc, aes(x = Year, y = Relativized.Value, color = Factor, linetype = Factor)) +
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 36), legend.position = 'bottom') +
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  labs(title = '', x = 'Model Year', y = 'Variance (SS) explained by factor, relativized', color = 'Factor', linetype = 'Factor')
tac

deanc <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/LTB_fire_analysis_deacde.csv")

model.1 = lm (High ~ Climate + Scenario, data = deanc)

Anova(model.1, type="II")
summary(model.1)

timesteps <- 1:100
timesteps <- c(10,20,30,40,50,60,70,80,90,100)
i <- timesteps[10]
all_data <- NULL

for(i in timesteps){
  ti <- subset(deanc, Decade == i) 
  model.2 = lm(High ~ Climate + Scenario, data = ti)
  a1 <- Anova(model.2, type = "II")
  fval <- a1$`Pr(>F)`
  summ <- summary(model.2)
  ars <- summ$adj.r.squared
  pval <- summ$coefficients[,4]
  fstat <- summ$fstatistic
  fp <- pf(fstat[1],fstat[2],fstat[3],lower.tail=F)
  sumsq <- a1$`Sum Sq`
  Climate <- sumsq[1]
  Management <- sumsq[2]
  Error <- sumsq[3]
  Magn <- (sumsq[1] + sumsq[2] + sumsq[3])
  
  propor <- cbind(Climate, Management, Error, Magn, fval, ars, i)
  all_data <- rbind(all_data, propor)
  
  pval_data <- cbind(pval, i)
  all_data2 <- rbind(all_data2, pval_data)
}

all_data <- as.data.frame(all_data)
#all_data$i <- as.factor(all_data$i)
tanc <- gather(all_data, i, value, Climate:ars)
#colnames(tanc) <- c('year', 'type', 'value')
tanc$type <- as.factor(tanc$type)
tanc$year <- as.numeric(tanc$year)

write.csv(tanc, "E:/SNPLMA3/Scenv3/Manuscript/high_anova_decade_4.csv")

danc2 <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/high_anova_decade.csv")
levels(danc2$Factor)
danc2$Factor = reorder(danc2$Factor, danc2$Order)
levels(danc2$Factor)

dac <- ggplot(danc, aes(x = Decade, y = Relativized.Values, color = Factor, linetype = Factor)) +
  geom_hline(yintercept = 0.05) + 
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 36), legend.position = 'bottom') +
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  labs(title = '', x = 'Model Year', y = "", color = 'Factor', linetype = 'Factor')
dac

dac <- ggplot(danc2, aes(x = Decade, y = Relativized.Values, color = Factor, linetype = Factor)) +
  geom_hline(yintercept = 0.05) + 
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 36), legend.position = 'bottom') +
  guides(color = F, linetype = F)+
  ylim(0,1) +
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  labs(title = '', x = 'Model Year', y = "", color = '', linetype = '')
dac

ggarrange(tac, dac, common.legend = T, legend = "right")


#################################actual plots#################
clim_colors <- c(CanESM_4.5 = '#CC0000', CanESM_8.5 = '#990000', CNRM5_4.5 = '#FF8748', CNRM5_8.5 = '#C75205', HADGEM2_4.5 = '#54F953', HADGEM2_8.5 = '#039702', MIROC5_4.5 = '#1475FF', MIROC5_8.5 = '#022B97')

tanc <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/C_anova_annual_2.csv")
tpval <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/C_anova_annual_2_pval.csv")
tanc$Factor = reorder(tanc$Factor, tanc$Order)
levels(tanc$Factor)

danc <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/C_anova_decade_2.csv")
#danc$Order <- as.factor(danc$Order)
danc$Factor = reorder(danc$Factor, danc$Order)
dpval <- subset(danc, Factor == c("Climate P(f)", "Management P(f)"))
danc <- subset(danc, Order < 5)
levels(danc$Factor)

tac <- ggplot(tanc, aes(x = Year, y = Relativized.Value, color = Factor)) +
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 24), legend.position = 'right') +
  scale_color_manual(labels = c("Climate", "Management", "Error", "Adj. R^2"), values = c('#CC0000','#FF8748','#1475FF', 'black'), guide = F) +
  #scale_linetype_manual(values = factor.lines, guide = T) +
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  labs(title = '', x = '', y = 'Variance explained (SS)', color = "", linetype = "" )
#tac

dac <- ggplot(danc, aes(x = Decade, y = Relativized.Value, color = Factor)) +
  #geom_hline(yintercept = 0.05) + 
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 24), legend.position = 'right') +
  scale_color_manual(values = c('#CC0000','#FF8748','#1475FF', 'black')) +
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  labs(title = '', x = '', y = "", color = '', linetype = '')
#dac

tval <- ggplot(tpval, aes(x = Year, y = Relativized.Value, color = Factor))+
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 24), legend.position = 'right') +
  scale_color_manual(labels = c("Climate", "Management"), values = c('#CC0000','#FF8748'), guide = F) +
  #scale_linetype_manual(values = factor.lines, guide = T) +
  ylim(0,0.25) +
  labs(title = '', x = 'Model Year', y = 'P-value', color = "", linetype = "" )
#tval

dval <- ggplot(dpval, aes(x = Decade, y = Relativized.Value, color = Factor)) +
geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 24), legend.position = 'right') +
  scale_color_manual(labels = c("Climate", "Management"), values = c('#CC0000','#FF8748')) +
  ylim(0,0.25) +
  #scale_linetype_manual(values = factor.lines, guide = T) +
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  labs(title = '', x = 'Model Year', y = '', color = "", linetype = "" )
#dval

ggarrange(tac, dac, tval, dval,
          heights = c(2, 1),
          labels= c('A',"B","C","D"),
          ncol = 2, nrow = 2)

tanc1 <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/total_anova_annual_5.csv")
tanc1$Factor = reorder(tanc1$Factor, tanc1$Order)
tpval <- subset(tanc1, Factor == c("Climate P(f)", "Management P(f)"))
tanc1 <- subset(tanc1, Order < 6)
levels(tanc1$Factor)

danc1 <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/total_anova_decade_5.csv")
danc1$Factor = reorder(danc1$Factor, danc1$Order)
dpval <- subset(danc1, Factor == c("Climate P(f)", "Management P(f)"))
danc1 <- subset(danc1, Order < 5)
levels(danc1$Factor)

tac <- ggplot(tanc1, aes(x = Year, y = Relativized.Value, color = Factor)) +
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 24), legend.position = 'right') +
  scale_color_manual(labels = c("Climate", "Management", "Error", "Adj. R^2"), values = c('#CC0000','#FF8748','#1475FF', 'black'), guide = F) +
  #scale_linetype_manual(values = factor.lines, guide = T) +
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  labs(title = '', x = '', y = 'Variance explained (SS)', color = "", linetype = "" )
tac

dac <- ggplot(danc1, aes(x = Decade, y = Relativized.Value, color = Factor)) +
  #geom_hline(yintercept = 0.05) + 
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 24), legend.position = 'right') +
  scale_color_manual(values = c('#CC0000','#FF8748','#1475FF', 'black')) +
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  labs(title = '', x = '', y = "", color = '', linetype = '')
dac

tval <- ggplot(tpval, aes(x = Year, y = Relativized.Value, color = Factor))+
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 24), legend.position = 'right') +
  scale_color_manual(labels = c("Climate", "Management"), values = c('#CC0000','#FF8748'), guide = F) +
  #scale_linetype_manual(values = factor.lines, guide = T) +
  ylim(0,0.25) +
  labs(title = '', x = 'Model Year', y = 'P-value', color = "", linetype = "" )
tval

dval <- ggplot(dpval, aes(x = Decade, y = Relativized.Value, color = Factor)) +
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 24), legend.position = 'right') +
  scale_color_manual(labels = c("Climate", "Management"), values = c('#CC0000','#FF8748')) +
  ylim(0,0.25) +
  #scale_linetype_manual(values = factor.lines, guide = T) +
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  labs(title = '', x = 'Model Year', y = '', color = "", linetype = "" )
dval

ggarrange(tac, dac, tval, dval,
          heights = c(2, 1),
          labels= c('A',"B","C","D"),
          ncol = 2, nrow = 2)

tanc2 <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/high_anova_annual_5.csv")
tanc2$Factor = reorder(tanc2$Factor, tanc2$Order)
tpval <- subset(tanc2, Factor == c("Climate P(f)", "Management P(f)"))
tanc2 <- subset(tanc2, Order < 5)

danc2 <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/high_anova_decade_5.csv")
danc2$Factor = reorder(danc2$Factor, danc2$Order)
dpval <- subset(danc2, Factor == c("Climate P(f)", "Management P(f)"))
danc2 <- subset(danc2, Order < 5)

tac <- ggplot(tanc2, aes(x = Year, y = Relativized.Value, color = Factor)) +
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 24), legend.position = 'right') +
  scale_color_manual(labels = c("Climate", "Management", "Error", "Adj. R^2"), values = c('#CC0000','#FF8748','#1475FF', 'black'), guide = F) +
  ylim(0,1) +
  #scale_linetype_manual(values = factor.lines, guide = T) +
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  labs(title = '', x = '', y = 'Variance explained (SS)', color = "", linetype = "" )
tac

dac <- ggplot(danc2, aes(x = Decade, y = Relativized.Values, color = Factor)) +
  #geom_hline(yintercept = 0.05) + 
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 24), legend.position = 'right') +
  scale_color_manual(values = c('#CC0000','#FF8748','#1475FF', 'black')) +
  ylim(0,1) +
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  labs(title = '', x = '', y = "", color = '', linetype = '')
dac

tval <- ggplot(tpval, aes(x = Year, y = Relativized.Value, color = Factor))+
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 24), legend.position = 'right') +
  scale_color_manual(labels = c("Climate", "Management"), values = c('#CC0000','#FF8748'), guide = F) +
  #scale_linetype_manual(values = factor.lines, guide = T) +
  ylim(0,0.25) +
  labs(title = '', x = 'Model Year', y = 'P-value', color = "", linetype = "" )
tval

dval <- ggplot(dpval, aes(x = Decade, y = Relativized.Values, color = Factor)) +
  geom_line(size = 1.5)+
  theme_bw() + 
  theme(text= element_text(size = 24), legend.position = 'right') +
  scale_color_manual(labels = c("Climate", "Management"), values = c('#CC0000','#FF8748')) +
  ylim(0,0.25) +
  #scale_linetype_manual(values = factor.lines, guide = T) +
  #  scale_y_continuous(sec.axis = sec_axis(~ . * 16000, name = 'Total Variance')) +
  labs(title = '', x = 'Model Year', y = '', color = "", linetype = "" )
dval

ggarrange(tac, dac, tval, dval,
          heights = c(2, 1),
          labels= c('A',"B","C","D"),
          ncol = 2, nrow = 2)
