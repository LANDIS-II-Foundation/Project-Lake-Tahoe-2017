library(ggplot2)
library(ggpubr)
library(stargazer)


clim_colors <- c(CanESM_4.5 = '#CC0000', CanESM_8.5 = '#990000', CNRM5_4.5 = '#FF8748', CNRM5_8.5 = '#C75205', HADGEM2_4.5 = '#54F953', HADGEM2_8.5 = '#039702', MIROC5_4.5 = '#1475FF', MIROC5_8.5 = '#022B97')

factor.colors <- c(A = '#0000FF', B = '#FF0000', C = '#008000', D = '#FFD700', E = 'light_grey', G = 'dark_grey' )

scen.colors <- c(Scenario1 = 'blue', Scenario2 = 'red', Scenario3 = 'green', Scenario4 = 'yellow', Scenario5 = 'purple')


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

#####NEEC#####################################

neec <- read.csv("E:/SNPLMA3/core7_LTB_scen/NEE_byscenario_scenv3.csv")

nec <- ggplot(neec, aes(x = Time, y = Mean, fill = Scenario)) +
  theme_bw()+
  geom_line()+
  geom_ribbon(aes(ymax = Mean + SD, ymin = Mean - SD), alpha = 0.5) +
  geom_smooth() +
  facet_wrap(~Scenario, ncol = 5)
nec

neec2 <- read.csv("E:/SNPLMA3/core7_LTB_scen/NEE_byscenario_byclim_scenv3.csv")
neec2 <- subset(neec2, Time > 0)

nec2 <- ggplot(neec2, aes(x = Time, y = Mean, fill = Climate)) +
  theme_bw()+
  geom_line(alpha = 0.2)+
  geom_ribbon(aes(ymax = Mean + SD, ymin = Mean - SD), alpha = 0.2) +
  geom_smooth() +
  facet_wrap(~Scenario, ncol = 5)
nec2

##########Fire by climate############################

fire_5_7 <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/LTB_fire_low_mod_high_cum_allclim_scenv3.csv")
levels(fire_5_7$Type)

fire_low <- subset(fire_5_7, Type == "Low")
firel <- ggplot(fire_low, aes(x = Year, y = Cumulative, fill = Climate )) +
  geom_line(aes(color = Climate)) +
  #  geom_line(aes(x = Year, y = Cumulative, color = Severity)) +
  #  geom_ribbon(aes(ymax = Cumulative + SD, ymin = Cumulative - SD, fill = Severity), alpha = 0.3) +
  geom_ribbon(aes(ymax = Cumulative + CumulativeSD, ymin = Cumulative - CumulativeSD), alpha = 0.9) +
  facet_wrap(~Scenario, ncol = 5) +
  theme_bw() +
#  theme(text= element_text(size = 36), legend.position = 'bottom') +
  scale_fill_manual(values = clim_colors) +
  scale_color_manual(values = clim_colors, guide = F) +
  scale_y_continuous(limits = c(0, 150000), labels=fancy_scientific)
firel + labs(title = "Low severity fire area, Lake Tahoe Basin", y = "Cumulative mean fire area (in hectares)", fill = "Climate Projection")

fire_mod <- subset(fire_5_7, Type == "Moderate")
firem <- ggplot(fire_mod, aes(x = Year, y = Cumulative, fill = Climate )) +
  geom_line(aes(color = Climate)) +
  #  geom_line(aes(x = Year, y = Cumulative, color = Severity)) +
  #  geom_ribbon(aes(ymax = Cumulative + SD, ymin = Cumulative - SD, fill = Severity), alpha = 0.3) +
  geom_ribbon(aes(ymax = Cumulative + CumulativeSD, ymin = Cumulative - CumulativeSD), alpha = 0.9) +
  facet_wrap(~Scenario, ncol = 5) +
  theme_bw() +
  theme(axis.text.y = element_blank()) +
#  theme(text= element_text(size = 36), legend.position = 'bottom') +
  scale_fill_manual(values = clim_colors) +
  scale_color_manual(values = clim_colors, guide = F) 
#  scale_y_continuous(labels=fancy_scientific)
firem + labs(title = "Moderate severity fire area, Lake Tahoe Basin", y = "Cumulative mean fire area (in hectares)", fill = "Climate Projection")

fire_high <- subset(fire_5_7, Type == "High")
fireh <- ggplot(fire_high, aes(x = Year, y = Cumulative, fill = Climate )) +
  geom_line(aes(color = Climate)) +
  #  geom_line(aes(x = Year, y = Cumulative, color = Severity)) +
  #  geom_ribbon(aes(ymax = Cumulative + SD, ymin = Cumulative - SD, fill = Severity), alpha = 0.3) +
  geom_ribbon(aes(ymax = Cumulative + CumulativeSD, ymin = Cumulative - CumulativeSD), alpha = 0.9) +
  facet_wrap(~Scenario, ncol = 5) +
  theme_bw() +
#  theme(text= element_text(size = 36), legend.position = 'bottom') +
  scale_fill_manual(values = clim_colors) +
  scale_color_manual(values = clim_colors, guide = F) +
  scale_y_continuous(limits = c(0, 150000), labels=fancy_scientific)
fireh + labs(title = "High severity fire area, Lake Tahoe Basin", y = "Cumulative mean fire area (in hectares)", fill = "Climate Projection")

fire_all <- subset(fire_5_7, Type == "Total Wildfire")
fireall <- ggplot(fire_all, aes(x = Year, y = Cumulative, fill = Climate )) +
  geom_line(aes(color = Climate)) +
  #  geom_line(aes(x = Year, y = Cumulative, color = Severity)) +
  #  geom_ribbon(aes(ymax = Cumulative + SD, ymin = Cumulative - SD, fill = Severity), alpha = 0.3) +
  geom_ribbon(aes(ymax = Cumulative + CumulativeSD, ymin = Cumulative - CumulativeSD), alpha = 0.9) +
  facet_wrap(~Scenario, ncol = 5) +
  theme_bw() +
  theme(axis.text.y = element_blank()) +
#  theme(text= element_text(size = 36), legend.position = 'bottom') +
  scale_fill_manual(values = clim_colors) +
  scale_color_manual(values = clim_colors, guide = F)
#  scale_y_continuous(labels=fancy_scientific)
fireall + labs(title = "Total fire area, Lake Tahoe Basin", y = "Cumulative mean fire area (in hectares)", fill = "Climate Projection")

ggarrange(firel, firem, fireh, fireall,
          labels = c("A", "B","C", "D"),
          ncol = 2, nrow = 2,
          common.legend = T,
          legend = "right")

#############fire_no_clim##################################################

fire_5_7 <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/LTB_fire_low_mod_high_cum_scenv3.csv")
levels(fire_5_7$Type)

fire2 <- ggplot(fire_5_7, aes(x = Year, y = Cumulative, fill = Type)) +
  geom_line(aes(color = Type)) +
  geom_ribbon(aes(ymax = Cumulative + Cumulative_SD, ymin = Cumulative - Cumulative_SD), alpha = 0.9) +
  facet_wrap(~Scenario, ncol = 5) +
  theme_bw() +
  scale_color_discrete(guide = F)

fire2 + labs(title = "Cumulative area burned by severity", y = "Cumulative mean fire area (in hectares)", fill = "Fire type" )

fire_dri <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/LTB_fire_low_mod_high_cum_scenv3_DRI.csv")

fd <- ggplot(data = fire_dri, aes(x = DRI, y = Mean, color = Type)) +
  geom_point(aes(shape = Scenario)) +
  theme_bw() +
  geom_smooth()
fd

fd_low <- subset(fire_dri, Type == "Low")
fd <- ggplot(data = fd_low, aes(x = DRI, y = Mean, color = Scenario)) +
  geom_point(aes(shape = Scenario)) +
  theme_bw() +
  geom_smooth()
fd

fd_high <- subset(fire_dri, Type == "High")
fdh <- ggplot(data = fd_high, aes(x = DRI, y = Mean, color = Scenario)) +
  geom_point(aes(shape = Scenario)) +
  theme_bw() 
#  geom_smooth()
fdh

fd_tot <- subset(fire_dri, Type == "Total Wildfire")
fdt <- ggplot(data = fd_tot, aes(x = DRI, y = Mean, color = Scenario)) +
  geom_point(aes(shape = Scenario)) +
  theme_bw() 
#  geom_smooth()
fdt

ml <- glm(Mean ~ DRI + Scenario, data = fd_low)
summary(ml)
plot(ml)

mtot <- glm(Mean ~ DRI + Scenario, data = fd_tot)
summary(mtot)
plot(ml)

####LM_PERC_DRI#########################

fdri <- read.csv("E:/SNPLMA3/Scenv3/Manuscript/LTB_lm_perc_DRI.csv")
mfd <- glm(PERC ~ DRI + Scenario, data = fdri)
summary(mfd)
plot(mfd)

mfd <- glm(PERC ~ logDRI + Period, data = fdri)
summary(mfd)
stargazer(mfd, type = "html", title = "Table 2: Fire vs DRI", out = "E:/SNPLMA3/Manuscripts/MS2_table2.html")
plot(mfd)

mfd1 <- glm(PERC ~ Period + Scenario, data = fdri)
summary(mfd1)
plot(mfd1)

library(lme4)
mfd <- lmer(PERC ~ (DRI|Scenario), data = fdri)
summary(mfd)
plot(mfd)

fdt <- ggplot(data = fdri, aes(x = DRI, y = PERC, color = Scenario)) +
  geom_point(aes(shape = Period)) +
  theme_bw() +
  scale_x_continuous(trans = 'log10') 
#  geom_smooth()
fdt + labs(title = "DRI against percentage of low and moderate severity fire", y = "Percentage of low and moderate severity fire per year", color = "Scenario")


###################################################

firelpm <-read.csv("E:/SNPLMA3/Scenv3/Manuscript/LTB_fire_lowmod_cum_scenv3.csv")  
firelm <- ggplot(firelpm, aes(x = Year, y = Cumulative, fill = Climate )) +
  geom_line(aes(color = Climate)) +
  #  geom_line(aes(x = Year, y = Cumulative, color = Severity)) +
  #  geom_ribbon(aes(ymax = Cumulative + SD, ymin = Cumulative - SD, fill = Severity), alpha = 0.3) +
  geom_ribbon(aes(ymax = Cumulative + Cum_SD, ymin = Cumulative - Cum_SD), alpha = 0.9) +
  facet_wrap(~Scenario, ncol = 5) +
  theme_bw() +
  theme(text= element_text(size = 36), legend.position = 'bottom') +
  scale_fill_manual(values = clim_colors) +
  scale_color_manual(values = clim_colors, guide = F) +
  scale_y_continuous(labels=fancy_scientific)
firelm + labs(title = "Low + Mod severity fire area, Lake Tahoe Basin", y = "Cumulative mean fire area (in hectares)", fill = "Climate Projection")

drim <- read.csv("E:/SNPLMA3/ltb_mz_decade_dri.csv")
#drim$Zone <- as.factor(drim$Zone)
dri <- ggplot(drim, aes(x = Year, y = Mean, color = Zone, fill = Zone)) + 
  geom_line() +
  geom_ribbon(aes(ymax = Mean + SD, ymin = Mean - SD), alpha = 0.2) +
  facet_wrap(~Scenario, ncol = 5) +
  theme_bw() +
  scale_fill_discrete(guide = F) +
  scale_y_continuous(trans = "log")
#  scale_fill_manual(values = scen.colors, guide = F) 
#  theme(text= element_text(size = 36), legend.position = 'bottom') +
#  scale_fill_manual(values = clim_colors) +
#  scale_color_manual(values = clim_colors, guide = F) +
#  scale_y_continuous(labels=fancy_scientific)
dri + labs(title = "", y = "Mean Disturbance Return Interval", color = "Management Zone")

drim <- read.csv("E:/SNPLMA3/ltb_mz_decade_dri.csv")
drim$Zone <- as.factor(drim$Zone)
drim <- subset(drim, Zone_Name != 'Wilderness')
dri <- ggplot(drim, aes(x = Year, color = Zone, fill = Zone)) + 
  geom_line(aes(y = Mean)) +
  geom_ribbon(aes(ymax = Mean + SD, ymin = Mean - SD), alpha = 0.2) +
  facet_wrap(~Scenario, ncol = 5) +
  theme_bw() +
 scale_y_continuous(limits = c(0,200)) 
#  scale_color_manual(values = scen.colors) +
#  scale_fill_manual(values = scen.colors, guide = F) 
#  theme(text= element_text(size = 36), legend.position = 'bottom') +
#  scale_fill_manual(values = clim_colors) +
#  scale_color_manual(values = clim_colors, guide = F) +
#  scale_y_continuous(labels=fancy_scientific)
dri + labs(title = "", y = "Mean Disturbance Return Interval", color = "Management Zone")

perclmh <- read.csv("E:/SNPLMA3/core7_LTB_scen/LTB_perc_lm_versus_h.csv")
perc <- ggplot(perclmh, aes(x = Year, y = Percent, color = Value, fill = Value)) + 
  geom_line() + 
  geom_ribbon(aes(ymax = Percent + SD, ymin = Percent - SD), alpha = 0.2) +
  facet_wrap(~Scenario, ncol = 5) +
  theme_bw() 
#  scale_y_continuous(limits = c(0,1))
plot(perc)


patches <- read.csv("E:/SNPLMA3/HSfire_area_patches_allclim_scenv3_ms2.csv")
patch <- ggplot(patches, aes(x = Year, y = Mean, color = Scenario, fill = Scenario)) + 
  geom_line() + 
  geom_ribbon(aes(ymax = Mean + SD, ymin = Mean - SD2), alpha = 0.5) +
  theme_bw() +
  geom_smooth(alpha = 0.2) +
  scale_fill_manual(values = scen.colors, guide = F) +
  scale_color_manual(values = scen.colors) +
  labs(y = "Area burned in patches greater than 16ha")
#  scale_y_continuous(limits = c(0,1))
plot(patch)

cpool <- read.csv("E:/SNPLMA3/C_bypool_scenv3_bydecade.csv")
cpool <- subset(cpool, Metric != "SOIL")
cpol <- ggplot(cpool, aes(x = Year, y = Mean, color = Metric, fill = Metric)) +
  geom_line() +
  geom_ribbon(aes(ymax = Mean + SD, ymin = Mean - SD), alpha = 0.5) +
  theme_bw() + 
  facet_wrap(~Scenario, ncol = 5)
cpol


##########DRI_by_type#############################
dribt <- read.csv("E:/SNPLMA3/DRI_bytype_ggplot.csv")
dri <- ggplot(dribt, aes(x = Year, y = Mean, color = Dist)) + 
  geom_line() + 
  geom_ribbon(aes(ymax = Mean + SD, ymin = Mean - SD), alpha = 0.5) + 
  theme_bw() + 
  facet_wrap(~Scenario, ncol = 5)
plot(dri)

dri <- ggplot(dribt, aes(x = Year, y = Mean, fill = Dist)) + 
  geom_col() + 
  theme_bw() + 
  facet_wrap(~Scenario, ncol = 5) +
  labs(title = "Area impacted by disturbance type", y = "Area in ha", fill = "Disturbance type")
plot(dri)
