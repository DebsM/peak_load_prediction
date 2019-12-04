###################################################
###### CODES FOR PEAK LOAD DATA PRE PROCESSING ####
#### AUTHOR: DEBORA MAIA-SILVA ####################
###################################################


# August 20
# CA Rohini's processed data for the 3 respondents in CA
# October 22 - updating for the different models 



library(dplyr)
library(ggplot2)

options(java.parameters = "-Xmx30000m")
#options(java.parameters = "-Xmx7000m")
library(bartMachine)
set_bart_machine_num_cores(4)


#setwd("C:/Users/dmaiasil/Documents/Purdue Projects/Climate Reboot/Regions/CA/Rohini CA")
#setwd("C:/Users/Debora/Documents/Purdue/Climate Reboot/Regions/CA/Rohini CA")


#### load data ####
# debs' data plus CAISO, Roshini got the datasets together
# ca.5 refers to 5 respondents data, however, we will only use 3 which covers most of CA

# load average data, bias corrected (processed by Rohini)
ca.5.avg <- read.table("C:/Users/dmaiasil/Documents/Purdue Projects/Climate Reboot/Regions/CA/Rohini CA/underlying_data/Energy_Debs+ISO_bias_corrected_California_with_id_daily_avg_load.txt", sep="", header = T)
# max is the peak load
ca.5.max <- read.table("C:/Users/dmaiasil/Documents/Purdue Projects/Climate Reboot/Regions/CA/Rohini CA/underlying_data/Energy_Debs+ISO_bias_corrected_California_with_id_daily_max_load.txt", sep="", header = T)


#ca.5.avg <- read.table("C:/Users/Debora/Documents/Purdue/Climate Reboot/Regions/CA/Rohini CA/underlying_data/Energy_Debs+ISO_bias_corrected_California_with_id_daily_avg_load.txt", sep="", header = T)
#ca.5.max <- read.table("C:/Users/Debora/Documents/Purdue/Climate Reboot/Regions/CA/Rohini CA/underlying_data/Energy_Debs+ISO_bias_corrected_California_with_id_daily_max_load.txt", sep="", header = T)



# climate data average
ca.temp.avg <- read.table("C:/Users/dmaiasil/Documents/Purdue Projects/Climate Reboot/Regions/CA/Rohini CA/underlying_data/Climate_NARR_population_weightage_daily_avg_air_temp_2006_2016.txt", sep="", header = T)
ca.temp.anon <- read.table("C:/Users/dmaiasil/Documents/Purdue Projects/Climate Reboot/Regions/CA/Rohini CA/underlying_data/Climate_NARR_population_weightage_daily_avg_air_temp_anom_2006_2016.txt", sep="", header = T)
ca.wb.avg <- read.table("C:/Users/dmaiasil/Documents/Purdue Projects/Climate Reboot/Regions/CA/Rohini CA/underlying_data/Climate_NARR_population_weightage_daily_avg_sWBGT_2006_2016.txt", sep="", header = T)
ca.wb.anon <- read.table("C:/Users/dmaiasil/Documents/Purdue Projects/Climate Reboot/Regions/CA/Rohini CA/underlying_data/Climate_NARR_population_weightage_daily_avg_sWBGT_anom_2006_2016.txt", sep="", header = T)
ca.di.avg <- read.table("C:/Users/dmaiasil/Documents/Purdue Projects/Climate Reboot/Regions/CA/Rohini CA/underlying_data/population_weightage_daily_avg_DI_2006_2016.txt", sep="", header = T)
ca.di.anon <- read.table("C:/Users/dmaiasil/Documents/Purdue Projects/Climate Reboot/Regions/CA/Rohini CA/underlying_data/population_weightage_daily_avg_DI_anom_2006_2016.txt", sep="", header = T)
ca.hia.avg <- read.table("C:/Users/dmaiasil/Documents/Purdue Projects/Climate Reboot/Regions/CA/Rohini CA/underlying_data/population_weightage_daily_avg_HIA_2006_2016.txt", sep="", header = T)
ca.hia.anon <- read.table("C:/Users/dmaiasil/Documents/Purdue Projects/Climate Reboot/Regions/CA/Rohini CA/underlying_data/population_weightage_daily_avg_HIA_anom_2006_2016.txt", sep="", header = T)
ca.humidex.avg <- read.table("C:/Users/dmaiasil/Documents/Purdue Projects/Climate Reboot/Regions/CA/Rohini CA/underlying_data/population_weightage_daily_avg_HUMIDEX_2006_2016.txt", sep="", header = T)
ca.humidex.anon <- read.table("C:/Users/dmaiasil/Documents/Purdue Projects/Climate Reboot/Regions/CA/Rohini CA/underlying_data/population_weightage_daily_avg_HUMIDEX_anom_2006_2016.txt", sep="", header = T)
ca.wba.avg <- read.table("C:/Users/dmaiasil/Documents/Purdue Projects/Climate Reboot/Regions/CA/Rohini CA/underlying_data/population_weightage_daily_avg_WBA_2006_2016.txt", sep="", header = T)
ca.wba.anon <- read.table("C:/Users/dmaiasil/Documents/Purdue Projects/Climate Reboot/Regions/CA/Rohini CA/underlying_data/population_weightage_daily_avg_WBA_anom_2006_2016.txt", sep="", header = T)



# climate data average
ca.temp.avg <- read.table("C:/Users/Debora/Documents/Purdue/Climate Reboot/Regions/CA/Rohini CA/underlying_data/Climate_NARR_population_weightage_daily_avg_air_temp_2006_2016.txt", sep="", header = T)
#ca.temp.anon <- read.table("C:/Users/Debora/Documents/Purdue/Climate Reboot/Regions/CA/Rohini CA/underlying_data/Climate_NARR_population_weightage_daily_avg_air_temp_anom_2006_2016.txt", sep="", header = T)
ca.wb.avg <- read.table("C:/Users/Debora/Documents/Purdue/Climate Reboot/Regions/CA/Rohini CA/underlying_data/Climate_NARR_population_weightage_daily_avg_sWBGT_2006_2016.txt", sep="", header = T)
#ca.wb.anon <- read.table("C:/Users/Debora/Documents/Purdue/Climate Reboot/Regions/CA/Rohini CA/underlying_data/Climate_NARR_population_weightage_daily_avg_sWBGT_anom_2006_2016.txt", sep="", header = T)
ca.di.avg <- read.table("C:/Users/Debora/Documents/Purdue/Climate Reboot/Regions/CA/Rohini CA/underlying_data/population_weightage_daily_avg_DI_2006_2016.txt", sep="", header = T)
#ca.di.anon <- read.table("C:/Users/Debora/Documents/Purdue/Climate Reboot/Regions/CA/Rohini CA/underlying_data/population_weightage_daily_avg_DI_anom_2006_2016.txt", sep="", header = T)
ca.hia.avg <- read.table("C:/Users/Debora/Documents/Purdue/Climate Reboot/Regions/CA/Rohini CA/underlying_data/population_weightage_daily_avg_HIA_2006_2016.txt", sep="", header = T)
#ca.hia.anon <- read.table("C:/Users/Debora/Documents/Purdue/Climate Reboot/Regions/CA/Rohini CA/underlying_data/population_weightage_daily_avg_HIA_anom_2006_2016.txt", sep="", header = T)
ca.humidex.avg <- read.table("C:/Users/Debora/Documents/Purdue/Climate Reboot/Regions/CA/Rohini CA/underlying_data/population_weightage_daily_avg_HUMIDEX_2006_2016.txt", sep="", header = T)
#ca.humidex.anon <- read.table("C:/Users/Debora/Documents/Purdue/Climate Reboot/Regions/CA/Rohini CA/underlying_data/population_weightage_daily_avg_HUMIDEX_anom_2006_2016.txt", sep="", header = T)
ca.wba.avg <- read.table("C:/Users/Debora/Documents/Purdue/Climate Reboot/Regions/CA/Rohini CA/underlying_data/population_weightage_daily_avg_WBA_2006_2016.txt", sep="", header = T)
#ca.wba.anon <- read.table("C:/Users/Debora/Documents/Purdue/Climate Reboot/Regions/CA/Rohini CA/underlying_data/population_weightage_daily_avg_WBA_anom_2006_2016.txt", sep="", header = T)

##### filter summer months ####

ca.temp.avg <- ca.temp.avg %>%
  filter(MM %in% c(5:8))

filter_summer <- function (ds){
  ds <- ds %>%
    filter(MM %in% c(5:8))

  return(ds)
  
}

ca.5.max <- filter_summer(ca.5.max)
ca.di.avg <- filter_summer(ca.di.avg)
ca.hia.avg <- filter_summer(ca.hia.avg)
ca.humidex.avg <- filter_summer(ca.humidex.avg)
ca.wb.avg <- filter_summer(ca.wb.avg)
ca.wba.avg <- filter_summer(ca.wba.avg)
ca.di.anon <- filter_summer(ca.di.anon)
ca.hia.anon <- filter_summer(ca.hia.anon)
ca.humidex.anon <- filter_summer(ca.humidex.anon)
ca.wb.anon <- filter_summer(ca.wb.anon)
ca.wba.anon <- filter_summer(ca.wba.anon)
ca.temp.anon <- filter_summer(ca.temp.anon)


#### modeling #####
# 6 variables models
# modeling avg climate and anomaly climate agasint peak load
# we cross validate, built models, then use the top parameters to get test results

### ///// THIS IS JUST TO GET BART PARAMETERS ////// ####




# LAWP
# LAWP, 194, avg vs peak load
#building the model and saving

# BART parameters will have to come from normalized data too to compare with SVM

#df <- as.data.frame(cbind(ca.temp.avg[,5], ca.wb.avg[,5], ca.di.avg[,5], ca.hia.avg[,5], ca.humidex.avg[,5], ca.wba.avg[,5]))
#colnames(df) <- c("Air temperature", "Wet bulb temperature", "Discomfort index", "Heat index", "Humidex", "Wet bulb globe temperature")
#lawp.avg.model <- bartMachineCV(df, ca.5.max[,5], serialize = T)
lawp.avg.model.z <- bartMachineCV(peak.lawp.z[,-1], peak.lawp.z[,1], serialize = T)
save(lawp.avg.model.z, file="Models/lawp_avg_z.RData")

var.sel.lawp <- var_selection_by_permute_cv(lawp.avg.model.z, num_permute_samples = 100)

# getting test results with the tunning above
#lawp.avg.model.test <- k_fold_cv(as.data.frame(cbind(ca.temp.avg[,5], ca.wb.avg[,5], ca.di.avg[,5], ca.hia.avg[,5], ca.humidex.avg[,5], ca.wba.avg[,5]), 
                                               #col.names = c("Air temperature", "Wet bulb temperature", "Discomfort index", "Heat index", "Humidex", "Wet bulb globe temperature")), ca.5.max[,5], num_trees=lawp.avg.model$num_trees, q=lawp.avg.model$q, nu=lawp.avg.model$nu, k=lawp.avg.model$k, k_folds = 10, serialize = T)

# LAWP, 194, anon vs peak load
#df <- as.data.frame(cbind(ca.temp.anon[,5], ca.wb.anon[,5], ca.di.anon[,5], ca.hia.anon[,5], ca.humidex.anon[,5], ca.wba.anon[,5]))
#colnames(df) <- c("Air temperature", "Wet bulb temperature", "Discomfort index", "Heat index", "Humidex", "Wet bulb globe temperature")
#lawp.anon.model <- bartMachineCV(df, ca.5.max[,5], serialize = T)
#lawp.avg.wb.model.test <- k_fold_cv(as.data.frame(cbind(ca.temp.anon[,5], ca.wb.anon[,5], ca.di.anon[,5], ca.hia.anon[,5], ca.humidex.anon[,5], ca.wba.anon[,5]),
#                                                  col.names = c("Air temperature", "Wet bulb temperature", "Discomfort index", "Heat index", "Humidex", "Wet bulb globe temperature")), ca.5.max[,5], num_trees=lawp.anon.model$num_trees, q=lawp.anon.model$q, nu=lawp.anon.model$nu, k=lawp.anon.model$k, k_folds = 10, serialize = T)


# PGE
# PGE, 227, avg vs peak load
#building the model and saving

# missing data for PGE 
#ca.5.max$ID_227[ca.5.max$ID_227 == -9999] <- NA
#peak.pge <- na.omit(ca.5.max$ID_227)
#idx <- complete.cases(ca.5.max$ID_227)


#df <- as.data.frame(cbind(ca.temp.avg[idx,6], ca.wb.avg[idx,6], ca.di.avg[idx,6], ca.hia.avg[idx,6], ca.humidex.avg[idx,6], ca.wba.avg[idx,6]))
#colnames(df) <- c("Air temperature", "Wet bulb temperature", "Discomfort index", "Heat index", "Humidex", "Wet bulb globe temperature")
#pge.avg.model <- bartMachineCV(df, peak.pge, serialize = T)
pge.avg.model.z <- bartMachineCV(peak.pge.z[,-1], peak.pge.z[,1], serialize = T)
save(pge.avg.model.z, file="Models/pge_avg_z.RData")

var.sel.pge <- var_selection_by_permute_cv(pge.avg.model.z, num_permute_samples = 100)
# getting test results with the tunning above
#pge.avg.model.test <- k_fold_cv(as.data.frame(cbind(ca.temp.avg[idx,6], ca.wb.avg[idx,6], ca.di.avg[idx,6], ca.hia.avg[idx,6], ca.humidex.avg[idx,6], ca.wba.avg[idx,6]),
#                                              col.names = c("Air temperature", "Wet bulb temperature", "Discomfort index", "Heat index", "Humidex", "Wet bulb globe temperature")), peak.pge, num_trees=pge.avg.model$num_trees, q=pge.avg.model$q, nu=pge.avg.model$nu, k=pge.avg.model$k, k_folds = 10, serialize = T)


# PGE, 227, anon vs peak load
#df <- as.data.frame(cbind(ca.temp.anon[idx,6], ca.wb.anon[idx,6], ca.di.anon[idx,6], ca.hia.anon[idx,6], ca.humidex.anon[idx,6], ca.wba.anon[idx,6]))
#colnames(df) <- c("Air temperature", "Wet bulb temperature", "Discomfort index", "Heat index", "Humidex", "Wet bulb globe temperature")
#pge.anon.model <- bartMachineCV(df, peak.pge, serialize = T)
#pge.avg.wb.model.test <- k_fold_cv(as.data.frame(cbind(ca.temp.anon[idx,6], ca.wb.anon[idx,6], ca.di.anon[idx,6], ca.hia.anon[idx,6], ca.humidex.anon[idx,6], ca.wba.anon[idx,6]),
#                                                 col.names = c("Air temperature", "Wet bulb temperature", "Discomfort index", "Heat index", "Humidex", "Wet bulb globe temperature")), peak.pge, num_trees=pge.anon.model$num_trees, q=pge.anon.model$q, nu=pge.anon.model$nu, k=pge.anon.model$k, k_folds = 10, serialize = T)


# SDGE
# SDGE, 246, avg vs peak load
#df <- as.data.frame(cbind(ca.temp.avg[,7], ca.wb.avg[,7], ca.di.avg[,7], ca.hia.avg[,7], ca.humidex.avg[,7], ca.wba.avg[,7]))
#colnames(df) <- c("Air temperature", "Wet bulb temperature", "Discomfort index", "Heat index", "Humidex", "Wet bulb globe temperature")
sdge.avg.model.z <- bartMachineCV(peak.sdge.z[,-1], peak.sdge.z[,1], serialize = T)
save(sdge.avg.model.z, file="Models/sdge_avg_z.RData")

var.sel.sdge <- var_selection_by_permute_cv(sdge.avg.model.z, num_permute_samples = 100)
#sdge.avg.model.test <- k_fold_cv(as.data.frame(cbind(ca.temp.avg[,7], ca.wb.avg[,7], ca.di.avg[,7], ca.hia.avg[,7], ca.humidex.avg[,7], ca.wba.avg[,7]),
#                                               col.names = c("Air temperature", "Wet bulb temperature", "Discomfort index", "Heat index", "Humidex", "Wet bulb globe temperature")), ca.5.max[,7], num_trees=sdge.avg.model$num_trees, q=sdge.avg.model$q, nu=sdge.avg.model$nu, k=sdge.avg.model$k, k_folds = 10, serialize = T)


# sdge, 246, anon vs peak load
#df <- as.data.frame(cbind(ca.temp.anon[,7], ca.wb.anon[,7], ca.di.anon[,7], ca.hia.anon[,7], ca.humidex.anon[,7], ca.wba.anon[,7]))
#colnames(df) <- c("Air temperature", "Wet bulb temperature", "Discomfort index", "Heat index", "Humidex", "Wet bulb globe temperature")
#sdge.anon.model <- bartMachineCV(df, ca.5.max[,7], serialize = T)
#save(sdge.anon.model, file=paste0("sdge.anon", ".RData"))
#sdge.avg.wb.model.test <- k_fold_cv(as.data.frame(cbind(ca.temp.anon[,7], ca.wb.anon[,7], ca.di.anon[,7], ca.hia.anon[,7], ca.humidex.anon[,7], ca.wba.anon[,7]),
#                                                  col.names = c("Air temperature", "Wet bulb temperature", "Discomfort index", "Heat index", "Humidex", "Wet bulb globe temperature")), ca.5.max[,7], num_trees=sdge.anon.model$num_trees, q=sdge.anon.model$q, nu=sdge.anon.model$nu, k=sdge.anon.model$k, k_folds = 10, serialize = T)


# loading the models in new session
#file_names <- c('lawp.anon.RData', 'lawp.avg.RData', 'pge.anon.RData', 'pge.avg.RData', 'sdge.anon.RData', 'sdge.avg.RData')
#lapply(file_names, load, environment())

# Final parameters for BART Machine: parameters from the .z models
# best variable: air temperature for all 3 respondents
# checking the investigate_var_importance plot, I will choose 2 variables for each model
# LAWP: air temperature and wet bulb globe temperature
# PGE: air temperature and heat index
# SDGE: air temperature and heat index

##### BART RMSE ####
# just initial plot with BART -> there will be a final comparison with other models! 
# first we need the y_hat (predictions for the test set) for every model (.test df variables)
# for every y_hat, I need the observation (real response) -> each respondent has 1 observed y (peak load)

# time columns to check plots
time <- as.Date(paste(ca.5.max$YYYY, ca.5.max$MM, ca.5.max$DD, sep='-'))

# LAWP 
bart.pred.lawp <- as.data.frame(cbind(ca.5.max[,5], lawp.avg.model.test$y_hat, lawp.avg.wb.model.test$y_hat))
colnames(bart.pred.lawp) <- c('obs_peak_load', 'pred_from_avg', 'pred_from_anom')


quantile(ca.5.max[,5])

bart.pred.lawp$error_avg <- bart.pred.lawp$obs_peak_load - bart.pred.lawp$pred_from_avg
bart.pred.lawp$error_anom <- bart.pred.lawp$obs_peak_load - bart.pred.lawp$pred_from_anom 

# ordering by observed data to get rmse by quantile
bart.pred.lawp <- bart.pred.lawp[order(bart.pred.lawp$obs_peak_load),]

# RMSE by quantile
rmse_lawp <- data.frame(character(10), numeric(10), numeric(10))
rmse_lawp[,1] <- c('10th', '20th', '30th', '40th', '50th', '60th_last', '70th_last', '80th_last', '90th_last', 'All')
colnames(rmse_lawp) <- c('quantile', 'rmse_avg', 'rmse_anom')


qt.lawp <- quantile(ca.5.max[,5], c(.1,.2,.3,.4,.5,.6,.7,.8,.9))
# which(ca.5.max[order(ca.5.max[,5]),5] < qt.lawp[1])


rmse_lawp[1,2] <- sqrt(sum(bart.pred.lawp$error_avg[1:136]^2)/length(bart.pred.lawp$error_avg[1:136]))
rmse_lawp[2,2] <- sqrt(sum(bart.pred.lawp$error_avg[1:271]^2)/length(bart.pred.lawp$error_avg[1:271]))
rmse_lawp[3,2] <- sqrt(sum(bart.pred.lawp$error_avg[1:406]^2)/length(bart.pred.lawp$error_avg[1:406]))
rmse_lawp[4,2] <- sqrt(sum(bart.pred.lawp$error_avg[1:541]^2)/length(bart.pred.lawp$error_avg[1:541]))
rmse_lawp[5,2] <- sqrt(sum(bart.pred.lawp$error_avg[1:676]^2)/length(bart.pred.lawp$error_avg[1:676]))
# above the treshold now
rmse_lawp[6,2] <- sqrt(sum(bart.pred.lawp$error_avg[813:1353]^2)/length(bart.pred.lawp$error_avg[813:1353]))
rmse_lawp[7,2] <- sqrt(sum(bart.pred.lawp$error_avg[948:1353]^2)/length(bart.pred.lawp$error_avg[948:1353]))
rmse_lawp[8,2] <- sqrt(sum(bart.pred.lawp$error_avg[1083:1353]^2)/length(bart.pred.lawp$error_avg[1083:1353]))
rmse_lawp[9,2] <- sqrt(sum(bart.pred.lawp$error_avg[1218:1353]^2)/length(bart.pred.lawp$error_avg[1218:1353]))
rmse_lawp[10,2] <- sqrt(sum(bart.pred.lawp$error_avg[1:1353]^2)/length(bart.pred.lawp$error_avg[1:1353]))


rmse_lawp[1,3] <- sqrt(sum(bart.pred.lawp$error_anom[1:136]^2)/length(bart.pred.lawp$error_anom[1:136]))
rmse_lawp[2,3] <- sqrt(sum(bart.pred.lawp$error_anom[1:271]^2)/length(bart.pred.lawp$error_anom[1:271]))
rmse_lawp[3,3] <- sqrt(sum(bart.pred.lawp$error_anom[1:406]^2)/length(bart.pred.lawp$error_anom[1:406]))
rmse_lawp[4,3] <- sqrt(sum(bart.pred.lawp$error_anom[1:541]^2)/length(bart.pred.lawp$error_anom[1:541]))
rmse_lawp[5,3] <- sqrt(sum(bart.pred.lawp$error_anom[1:676]^2)/length(bart.pred.lawp$error_anom[1:676]))
# above the treshold now
rmse_lawp[6,3] <- sqrt(sum(bart.pred.lawp$error_anom[813:1353]^2)/length(bart.pred.lawp$error_anom[813:1353]))
rmse_lawp[7,3] <- sqrt(sum(bart.pred.lawp$error_anom[948:1353]^2)/length(bart.pred.lawp$error_anom[948:1353]))
rmse_lawp[8,3] <- sqrt(sum(bart.pred.lawp$error_anom[1083:1353]^2)/length(bart.pred.lawp$error_anom[1083:1353]))
rmse_lawp[9,3] <- sqrt(sum(bart.pred.lawp$error_anom[1218:1353]^2)/length(bart.pred.lawp$error_anom[1218:1353]))
rmse_lawp[10,3] <- sqrt(sum(bart.pred.lawp$error_anom[1:1353]^2)/length(bart.pred.lawp$error_anom[1:1353]))

ggplot(rmse_lawp[1:9,], aes(x=quantile[1:9], y=rmse_avg[1:9])) + geom_point(size = 2)

#### checking the data - make some plots ####

plot.lawp <- as.data.frame(cbind(time, bart.pred.lawp))
ggplot(plot.lawp, aes(x=time, y=obs_peak_load)) + geom_point() + coord_cartesian(ylim = c(2500, 7000))
ggplot(plot.lawp, aes(x=time, y=pred_from_avg)) + geom_point() + coord_cartesian(ylim = c(2500, 7000))
ggplot(plot.lawp, aes(x=time, y=pred_from_anom)) + geom_point() + coord_cartesian(ylim = c(2500, 7000))
# ordering the time
plot.lawp.ord <- plot.lawp[order(plot.lawp$time),]
ggplot(plot.lawp.ord, aes(x=time, y=obs_peak_load)) + geom_point()


# PGE

bart.pred.pge <- as.data.frame(cbind(peak.pge, pge.avg.model.test$y_hat, pge.avg.wb.model.test$y_hat))
colnames(bart.pred.pge) <- c('obs_peak_load', 'pred_from_avg', 'pred_from_anom')

time <- as.Date(paste(ca.5.max$YYYY[idx], ca.5.max$MM[idx], ca.5.max$DD[idx], sep='-'))

# similar underestimation as lawp
plot.pge <- as.data.frame(cbind(time, bart.pred.pge))
ggplot(plot.pge, aes(x=time, y=obs_peak_load)) + geom_point() + coord_cartesian(ylim = c(10000, 21000))
ggplot(plot.pge, aes(x=time, y=pred_from_avg)) + geom_point() + coord_cartesian(ylim = c(10000, 21000))
ggplot(plot.pge, aes(x=time, y=pred_from_anom)) + geom_point() + coord_cartesian(ylim = c(10000, 21000))

bart.pred.pge$error_avg <- bart.pred.pge$obs_peak_load - bart.pred.pge$pred_from_avg
bart.pred.pge$error_anom <- bart.pred.pge$obs_peak_load - bart.pred.pge$pred_from_anom 

# ordering by observed data to get rmse by quantile
bart.pred.pge <- bart.pred.pge[order(bart.pred.pge$obs_peak_load),]

# RMSE by quantile
rmse_pge <- data.frame(character(10), numeric(10), numeric(10))
rmse_pge[,1] <- c('10th', '20th', '30th', '40th', '50th', '60th_last', '70th_last', '80th_last', '90th_last', 'All')
colnames(rmse_pge) <- c('quantile', 'rmse_avg', 'rmse_anom')


qt.pge <- quantile(peak.pge, c(.1,.2,.3,.4,.5,.6,.7,.8,.9))
#which(peak.pge[order(peak.pge)] > qt.pge[9])


rmse_pge[1,2] <- sqrt(sum(bart.pred.pge$error_avg[1:98]^2)/length(bart.pred.pge$error_avg[1:98]))
rmse_pge[2,2] <- sqrt(sum(bart.pred.pge$error_avg[1:197]^2)/length(bart.pred.pge$error_avg[1:197]))
rmse_pge[3,2] <- sqrt(sum(bart.pred.pge$error_avg[1:294]^2)/length(bart.pred.pge$error_avg[1:294]))
rmse_pge[4,2] <- sqrt(sum(bart.pred.pge$error_avg[1:394]^2)/length(bart.pred.pge$error_avg[1:394]))
rmse_pge[5,2] <- sqrt(sum(bart.pred.pge$error_avg[1:492]^2)/length(bart.pred.pge$error_avg[1:492]))
# above the treshold now
rmse_pge[6,2] <- sqrt(sum(bart.pred.pge$error_avg[591:984]^2)/length(bart.pred.pge$error_avg[591:984]))
rmse_pge[7,2] <- sqrt(sum(bart.pred.pge$error_avg[690:984]^2)/length(bart.pred.pge$error_avg[690:984]))
rmse_pge[8,2] <- sqrt(sum(bart.pred.pge$error_avg[788:984]^2)/length(bart.pred.pge$error_avg[788:984]))
rmse_pge[9,2] <- sqrt(sum(bart.pred.pge$error_avg[886:984]^2)/length(bart.pred.pge$error_avg[886:984]))
rmse_pge[10,2] <- sqrt(sum(bart.pred.pge$error_avg[1:984]^2)/length(bart.pred.pge$error_avg[1:984]))


rmse_pge[1,3] <- sqrt(sum(bart.pred.pge$error_anom[1:98]^2)/length(bart.pred.pge$error_anom[1:98]))
rmse_pge[2,3] <- sqrt(sum(bart.pred.pge$error_anom[1:197]^2)/length(bart.pred.pge$error_anom[1:197]))
rmse_pge[3,3] <- sqrt(sum(bart.pred.pge$error_anom[1:294]^2)/length(bart.pred.pge$error_anom[1:294]))
rmse_pge[4,3] <- sqrt(sum(bart.pred.pge$error_anom[1:394]^2)/length(bart.pred.pge$error_anom[1:394]))
rmse_pge[5,3] <- sqrt(sum(bart.pred.pge$error_anom[1:492]^2)/length(bart.pred.pge$error_anom[1:492]))
# above the treshold now
rmse_pge[6,3] <- sqrt(sum(bart.pred.pge$error_anom[591:984]^2)/length(bart.pred.pge$error_anom[591:984]))
rmse_pge[7,3] <- sqrt(sum(bart.pred.pge$error_anom[690:984]^2)/length(bart.pred.pge$error_anom[690:984]))
rmse_pge[8,3] <- sqrt(sum(bart.pred.pge$error_anom[788:984]^2)/length(bart.pred.pge$error_anom[788:984]))
rmse_pge[9,3] <- sqrt(sum(bart.pred.pge$error_anom[886:984]^2)/length(bart.pred.pge$error_anom[886:984]))
rmse_pge[10,3] <- sqrt(sum(bart.pred.pge$error_anom[1:984]^2)/length(bart.pred.pge$error_anom[1:984]))

ggplot(rmse_pge[1:9,], aes(x=quantile[1:9], y=rmse_avg[1:9])) + geom_point(size = 2)


# SDGE

# sum(is.na(ca.5.max[,7])), no missing values
bart.pred.sdge <- as.data.frame(cbind(ca.5.max[,7], sdge.avg.model.test$y_hat, sdge.avg.wb.model.test$y_hat))
colnames(bart.pred.sdge) <- c('obs_peak_load', 'pred_from_avg', 'pred_from_anom')

time <- as.Date(paste(ca.5.max$YYYY, ca.5.max$MM, ca.5.max$DD, sep='-'))

# similar underestimation as lawp
plot.sdge <- as.data.frame(cbind(time, bart.pred.sdge))
ggplot(plot.sdge, aes(x=time, y=obs_peak_load)) + geom_point() + coord_cartesian(ylim = c(2300, 4600))
ggplot(plot.sdge, aes(x=time, y=pred_from_avg)) + geom_point() + coord_cartesian(ylim = c(2300, 4600))
ggplot(plot.sdge, aes(x=time, y=pred_from_anom)) + geom_point() + coord_cartesian(ylim = c(2300, 4600))


bart.pred.sdge$error_avg <- bart.pred.sdge$obs_peak_load - bart.pred.sdge$pred_from_avg
bart.pred.sdge$error_anom <- bart.pred.sdge$obs_peak_load - bart.pred.sdge$pred_from_anom 

# ordering by observed data to get rmse by quantile
bart.pred.sdge <- bart.pred.sdge[order(bart.pred.sdge$obs_peak_load),]

# RMSE by quantile
rmse_sdge <- data.frame(character(10), numeric(10), numeric(10))
rmse_sdge[,1] <- c('10th', '20th', '30th', '40th', '50th', '60th_last', '70th_last', '80th_last', '90th_last', 'All')
colnames(rmse_sdge) <- c('quantile', 'rmse_avg', 'rmse_anom')


qt.sdge <- quantile(ca.5.max[,7], c(.1,.2,.3,.4,.5,.6,.7,.8,.9))
which(ca.5.max[order(ca.5.max[,7]),7] < qt.sdge[1])


rmse_sdge[1,2] <- sqrt(sum(bart.pred.sdge$error_avg[1:136]^2)/length(bart.pred.sdge$error_avg[1:136]))
rmse_sdge[2,2] <- sqrt(sum(bart.pred.sdge$error_avg[1:271]^2)/length(bart.pred.sdge$error_avg[1:271]))
rmse_sdge[3,2] <- sqrt(sum(bart.pred.sdge$error_avg[1:406]^2)/length(bart.pred.sdge$error_avg[1:406]))
rmse_sdge[4,2] <- sqrt(sum(bart.pred.sdge$error_avg[1:541]^2)/length(bart.pred.sdge$error_avg[1:541]))
rmse_sdge[5,2] <- sqrt(sum(bart.pred.sdge$error_avg[1:676]^2)/length(bart.pred.sdge$error_avg[1:676]))
# above the treshold now
rmse_sdge[6,2] <- sqrt(sum(bart.pred.sdge$error_avg[813:1353]^2)/length(bart.pred.sdge$error_avg[813:1353]))
rmse_sdge[7,2] <- sqrt(sum(bart.pred.sdge$error_avg[948:1353]^2)/length(bart.pred.sdge$error_avg[948:1353]))
rmse_sdge[8,2] <- sqrt(sum(bart.pred.sdge$error_avg[1083:1353]^2)/length(bart.pred.sdge$error_avg[1083:1353]))
rmse_sdge[9,2] <- sqrt(sum(bart.pred.sdge$error_avg[1218:1353]^2)/length(bart.pred.sdge$error_avg[1218:1353]))
rmse_sdge[10,2] <- sqrt(sum(bart.pred.sdge$error_avg[1:1353]^2)/length(bart.pred.sdge$error_avg[1:1353]))


rmse_sdge[1,3] <- sqrt(sum(bart.pred.sdge$error_anom[1:136]^2)/length(bart.pred.sdge$error_anom[1:136]))
rmse_sdge[2,3] <- sqrt(sum(bart.pred.sdge$error_anom[1:271]^2)/length(bart.pred.sdge$error_anom[1:271]))
rmse_sdge[3,3] <- sqrt(sum(bart.pred.sdge$error_anom[1:406]^2)/length(bart.pred.sdge$error_anom[1:406]))
rmse_sdge[4,3] <- sqrt(sum(bart.pred.sdge$error_anom[1:541]^2)/length(bart.pred.sdge$error_anom[1:541]))
rmse_sdge[5,3] <- sqrt(sum(bart.pred.sdge$error_anom[1:676]^2)/length(bart.pred.sdge$error_anom[1:676]))
# above the treshold now
rmse_sdge[6,3] <- sqrt(sum(bart.pred.sdge$error_anom[813:1353]^2)/length(bart.pred.sdge$error_anom[813:1353]))
rmse_sdge[7,3] <- sqrt(sum(bart.pred.sdge$error_anom[948:1353]^2)/length(bart.pred.sdge$error_anom[948:1353]))
rmse_sdge[8,3] <- sqrt(sum(bart.pred.sdge$error_anom[1083:1353]^2)/length(bart.pred.sdge$error_anom[1083:1353]))
rmse_sdge[9,3] <- sqrt(sum(bart.pred.sdge$error_anom[1218:1353]^2)/length(bart.pred.sdge$error_anom[1218:1353]))
rmse_sdge[10,3] <- sqrt(sum(bart.pred.sdge$error_anom[1:1353]^2)/length(bart.pred.sdge$error_anom[1:1353]))

ggplot(rmse_sdge[1:9,], aes(x=quantile[1:9], y=rmse_avg[1:9])) + geom_point(size = 2)





#### SVM tuning ####
library(e1071)
library(BBmisc)
library(ModelMetrics)
library(caret)
set.seed(1234)

#### creating the dataframes ####
# I'm not even considering the anom datasets due to their poor performance with BART

lawp.df <- as.data.frame(cbind(ca.5.max[,5], ca.temp.avg[,5], ca.wb.avg[,5], ca.di.avg[,5], ca.hia.avg[,5], ca.humidex.avg[,5], ca.wba.avg[,5]))
colnames(lawp.df) = c("peak_load", "Air temperature", "Wet bulb temperature", "Discomfort index", "Heat index", "Humidex", "Wet bulb globe temperature")
pge.df <- as.data.frame(cbind(peak.pge, ca.temp.avg[idx,6], ca.wb.avg[idx,6], ca.di.avg[idx,6], ca.hia.avg[idx,6], ca.humidex.avg[idx,6], ca.wba.avg[idx,6]))
colnames(pge.df) <- c("peak_load","Air temperature", "Wet bulb temperature", "Discomfort index", "Heat index", "Humidex", "Wet bulb globe temperature")
sdge.df <- as.data.frame(cbind(ca.5.max[,7], ca.temp.avg[,7], ca.wb.avg[,7], ca.di.avg[,7], ca.hia.avg[,7], ca.humidex.avg[,7], ca.wba.avg[,7]))
colnames(sdge.df) = c("peak_load", "Air temperature", "Wet bulb temperature", "Discomfort index", "Heat index", "Humidex", "Wet bulb globe temperature")

# normalize data for SVM - using “standardize”: Center and scale
peak.lawp.z <- normalize(lawp.df, method = 'standardize')
peak.pge.z <- normalize(pge.df, method = 'standardize')
peak.sdge.z <- normalize(sdge.df, method = 'standardize')

folds.lawp <- cut(seq(1,nrow(peak.lawp.z)),breaks=10,labels=FALSE)
train.svm.lawp <- vector("numeric", 10)
test.svm.lawp <- vector("numeric", 10)

folds.pge <- cut(seq(1,nrow(peak.pge.z)),breaks=10,labels=FALSE)
train.svm.pge <- vector("numeric", 10)
test.svm.pge <- vector("numeric", 10)

folds.sdge <- cut(seq(1,nrow(peak.sdge.z)),breaks=10,labels=FALSE)
train.svm.sdge <- vector("numeric", 10)
test.svm.sdge <- vector("numeric", 10)

kernel.train.lawp <- vector("numeric", 3)
kernel.test.lawp <- vector("numeric", 3)

kernel.train.pge <- vector("numeric", 3)
kernel.test.pge <- vector("numeric", 3)

kernel.train.sdge <- vector("numeric", 3)
kernel.test.sdge <- vector("numeric", 3)

##### choosing kernel, variables and parameters ####
kernel <- c("linear","radial","polynomial")

# lawp = radial
for(j in 1:3){
  
  for(i in 1:10){
    
    testIndexes <- which(folds.lawp==i,arr.ind=TRUE)
    train <- peak.lawp.z[-testIndexes, ]
    test <- peak.lawp.z[testIndexes, ]
    
    model.svm <- svm(peak_load ~., data = train, kernel = kernel[j])
    
    model.pred.svm <- predict(model.svm, train)
    model.pred.OOS.svm <- predict(model.svm, test)
    
    train.svm.lawp[i] <- rmse(actual = train$peak_load, predicted = model.pred.svm)
    test.svm.lawp[i] <- rmse(actual = test$peak_load, predicted = model.pred.OOS.svm)
    
    
  }
  
  kernel.train.lawp[j] <- mean(train.svm.lawp)
  kernel.test.lawp[j] <- mean(test.svm.lawp)
  
}

# pge = linear
for(j in 1:3){
  
  for(i in 1:10){
    
    testIndexes <- which(folds.pge==i,arr.ind=TRUE)
    train <- peak.pge.z[-testIndexes, ]
    test <- peak.pge.z[testIndexes, ]
    
    model.svm <- svm(peak_load ~., data = train, kernel = kernel[j])
    
    model.pred.svm <- predict(model.svm, train)
    model.pred.OOS.svm <- predict(model.svm, test)
    
    train.svm.pge[i] <- rmse(actual = train$peak_load, predicted = model.pred.svm)
    test.svm.pge[i] <- rmse(actual = test$peak_load, predicted = model.pred.OOS.svm)
    
    
  }
  
  kernel.train.pge[j] <- mean(train.svm.pge)
  kernel.test.pge[j] <- mean(test.svm.pge)
  
}

# sdge = radial
for(j in 1:3){
  
  for(i in 1:10){
    
    testIndexes <- which(folds.sdge==i,arr.ind=TRUE)
    train <- peak.sdge.z[-testIndexes, ]
    test <- peak.sdge.z[testIndexes, ]
    
    model.svm <- svm(peak_load ~., data = train, kernel = kernel[j])
    
    model.pred.svm <- predict(model.svm, train)
    model.pred.OOS.svm <- predict(model.svm, test)
    
    train.svm.sdge[i] <- rmse(actual = train$peak_load, predicted = model.pred.svm)
    test.svm.sdge[i] <- rmse(actual = test$peak_load, predicted = model.pred.OOS.svm)
    
    
  }
  
  kernel.train.sdge[j] <- mean(train.svm.sdge)
  kernel.test.sdge[j] <- mean(test.svm.sdge)
  
}




# cross validation grid search 
tuneCrt <- tune.control(random = FALSE, nrepeat = 1, repeat.aggregate = mean,
             sampling = c("cross"), sampling.aggregate = mean,
             sampling.dispersion = sd,
             cross = 10, best.model = TRUE,
             performances = TRUE)


svm.tune.lawp <- tune(svm, peak_load~., data = peak.lawp.z, kernel="radial", ranges=list(cost=2^(-10:10), gamma=2^(-10:10)), tunecontrol = tuneCrt)
svm.tune.pge <- tune(svm, peak_load~., data = peak.pge.z, kernel="linear", ranges=list(cost=2^(-10:10), gamma=2^(-10:10)), tunecontrol = tuneCrt)
svm.tune.sdge <- tune(svm, peak_load~., data = peak.sdge.z, kernel="radial", ranges=list(cost=2^(-10:10), gamma=2^(-10:10)), tunecontrol = tuneCrt)
# I did this blindly and the number of support vectors chosen is ridiculously high! 
# I will perform feature selection, but for consistency, I will record the RMSE results for this
# full features models

train.svm.lawp.full <- vector("numeric", 10)
test.svm.lawp.full <- vector("numeric", 10)

train.svm.pge.full <- vector("numeric", 10)
test.svm.pge.full <- vector("numeric", 10)

train.svm.sdge.full <- vector("numeric", 10)
test.svm.sdge.full <- vector("numeric", 10)

for(i in 1:10){
  
  testIndexes <- which(folds.lawp==i,arr.ind=TRUE)
  train <- peak.lawp.z[-testIndexes, ]
  test <- peak.lawp.z[testIndexes, ]
  
  
  model.pred.svm <- predict(svm.tune.lawp$best.model, train)
  model.pred.OOS.svm <- predict(svm.tune.lawp$best.model, test)
  
  train.svm.lawp.full[i] <- rmse(actual = train$peak_load, predicted = model.pred.svm)
  test.svm.lawp.full[i] <- rmse(actual = test$peak_load, predicted = model.pred.OOS.svm)
  
  
}

for(i in 1:10){
  
  testIndexes <- which(folds.pge==i,arr.ind=TRUE)
  train <- peak.pge.z[-testIndexes, ]
  test <- peak.pge.z[testIndexes, ]
  
  
  model.pred.svm <- predict(svm.tune.pge$best.model, train)
  model.pred.OOS.svm <- predict(svm.tune.pge$best.model, test)
  
  train.svm.pge.full[i] <- rmse(actual = train$peak_load, predicted = model.pred.svm)
  test.svm.pge.full[i] <- rmse(actual = test$peak_load, predicted = model.pred.OOS.svm)
  
  
}

for(i in 1:10){
  
  testIndexes <- which(folds.sdge==i,arr.ind=TRUE)
  train <- peak.sdge.z[-testIndexes, ]
  test <- peak.sdge.z[testIndexes, ]
  
  model.svm <- svm(peak_load ~., data = train, kernel = kernel[j])
  
  model.pred.svm <- predict(svm.tune.sdge$best.model, train)
  model.pred.OOS.svm <- predict(svm.tune.sdge$best.model, test)
  
  train.svm.sdge.full[i] <- rmse(actual = train$peak_load, predicted = model.pred.svm)
  test.svm.sdge.full[i] <- rmse(actual = test$peak_load, predicted = model.pred.OOS.svm)
  
  
}

# variable selection for SVM

# LAWP: Air temperature and heat index
svmProfile <- rfe(peak.lawp.z[,2:7], peak.lawp.z$peak_load,
                  sizes = c(2, 5, 10, 20),
                  rfeControl = rfeControl(functions = caretFuncs,
                                          number = 200),
                  method = "svmRadial")


# PGE: all variables
svmProfile.pge <- rfe(peak.pge.z[,2:7], peak.pge.z$peak_load,
                  sizes = c(2, 5, 10, 20),
                  rfeControl = rfeControl(functions = caretFuncs,
                                          number = 200),
                  method = "svmLinear")

# SDGE: Air temperature and heat index 
svmProfile.sdge <- rfe(peak.sdge.z[,2:7], peak.sdge.z$peak_load,
                      sizes = c(2, 5, 10, 20),
                      rfeControl = rfeControl(functions = caretFuncs,
                                              number = 200),
                      method = "svmRadial")

# tuning LAWP and SDGE with the 2 variables

svm.tune.lawp <- tune(svm, peak_load~., data = peak.lawp.z[,c(1,2,5)], kernel="radial", ranges=list(cost=2^(-10:10), gamma=2^(-10:10)), tunecontrol = tuneCrt)
svm.tune.sdge <- tune(svm, peak_load~., data = peak.sdge.z[,c(1,2,5)], kernel="radial", ranges=list(cost=2^(-10:10), gamma=2^(-10:10)), tunecontrol = tuneCrt)

# Final parameters for SVM:
# LAWP: Radial kernel; air temperature and heat index; C = 64; gamma = 1;
# PGE: Linear kernel; all variables; C = 128; gamma = 0.0009765625; svm.tune.pge
# SDGE: Radial kernel; air temperature and heat index; C = 32; Gamma = 0.03125;

# even after tuning, I'm getting SVMs with a very high number of support vectors.
# gonna trust that RMSE, but this is an important comment to add to the report. 

##### NNET tuning #### 
library(nnet)
# random sampling of train and test

peak.lawp.z <- normalize(lawp.df, method = 'standardize')
peak.pge.z <- normalize(pge.df, method = 'standardize')
peak.sdge.z <- normalize(sdge.df, method = 'standardize')
colnames(peak.lawp.z) <- c('peak_load', 'air_temp', 'wb_temp', 'discomfort_idx', 'heat_idx', 'humidex', 'wbg_temp')
colnames(peak.pge.z) <- c('peak_load', 'air_temp', 'wb_temp', 'discomfort_idx', 'heat_idx', 'humidex', 'wbg_temp')
colnames(peak.sdge.z) <- c('peak_load', 'air_temp', 'wb_temp', 'discomfort_idx', 'heat_idx', 'humidex', 'wbg_temp')


# LAWP
train_index <- sample(1:nrow(peak.lawp.z), 0.7 * nrow(peak.lawp.z))

train <- peak.lawp.z[train_index,]
test <- peak.lawp.z[-train_index,]

#regression type control
ctrl <- trainControl(method="cv",     # cross-validation set approach to use
                     number=10,       # k number of times to do k-fold
                     classProbs = F,  
                     summaryFunction = defaultSummary,
                     allowParallel= T
)


nnet1 <-  train(peak_load ~ .,       
                   data = train,     
                   method = "nnet",     
                   tuneLength = 1,
                   linout = 1)

nnet2 <- train(peak_load ~ .,       
                  data = train,     
                  method = "nnet",     
                  trControl = ctrl,    
                  tuneLength = c(1:3),
                  maxit = 100,
                  linout = 1
)  


grid <-  expand.grid(size = c(3, 5, 10, 20)    
                       , decay = c(0.5, 0.1, 1e-2, 1e-3, 1e-4, 1e-5, 1e-6, 1e-7)) 


nnet3 <- train(peak_load ~ .,       
                  data = train,     
                  method = "nnet",     
                  trControl = ctrl,    
                  tuneGrid = grid,
                  linout = 1
)

grid <-  expand.grid(size = seq(from = 1, to = 10, by = 1)     
                       , decay = c(0.5, 0.1, 1e-2, 1e-3, 1e-4, 1e-5, 1e-6, 1e-7))  

nnet4 <- train(peak_load ~ .,       
                  data = train,     
                  method = "nnet",     
                  trControl = ctrl,    
                  tuneGrid = grid,
                  maxit = 500,
                  linout = 1
)

# testing out the nnet models on our random, 30% test set

model.pred.1 <- predict(nnet1, train)
model.pred.OOS.1 <- predict(nnet1, test)


rmse.train.1 <- rmse(actual = train$peak_load, predicted = model.pred.1)
rmse.test.1 <- rmse(actual = test$peak_load, predicted = model.pred.OOS.1)

model.pred.2 <- predict(nnet2, train)
model.pred.OOS.2 <- predict(nnet2, test)

rmse.train.2 <- rmse(actual = train$peak_load, predicted = model.pred.2)
rmse.test.2 <- rmse(actual = test$peak_load, predicted = model.pred.OOS.2)


model.pred.3 <- predict(nnet3, train)
model.pred.OOS.3 <- predict(nnet3, test)


rmse.train.3 <- rmse(actual = train$peak_load, predicted = model.pred.3)
rmse.test.3 <- rmse(actual = test$peak_load, predicted = model.pred.OOS.3)


model.pred.4 <- predict(nnet4, train)
model.pred.OOS.4 <- predict(nnet4, test)

rmse.train.4 <- rmse(actual = train$peak_load, predicted = model.pred.4)
rmse.test.4 <- rmse(actual = test$peak_load, predicted = model.pred.OOS.4)

data.frame(rmse.train.1,rmse.train.2,rmse.train.3,rmse.train.4)
data.frame(rmse.test.1, rmse.test.2, rmse.test.3, rmse.test.4)

nnet4$bestTune

# PGE

train_index <- sample(1:nrow(peak.pge.z), 0.7 * nrow(peak.pge.z))

train <- peak.pge.z[train_index,]
test <- peak.pge.z[-train_index,]

#regression type control
ctrl <- trainControl(method="cv",     # cross-validation set approach to use
                     number=10,       # k number of times to do k-fold
                     classProbs = F,  
                     summaryFunction = defaultSummary,
                     allowParallel= T
)


nnet1 <-  train(peak_load ~ .,       
                data = train,     
                method = "nnet",     
                tuneLength = 1,
                linout = 1)

nnet2 <- train(peak_load ~ .,       
               data = train,     
               method = "nnet",     
               trControl = ctrl,    
               tuneLength = c(1:3),
               maxit = 100,
               linout = 1
)  


grid <-  expand.grid(size = c(3, 5, 10, 20)    
                     , decay = c(0.5, 0.1, 1e-2, 1e-3, 1e-4, 1e-5, 1e-6, 1e-7)) 


nnet3 <- train(peak_load ~ .,       
               data = train,     
               method = "nnet",     
               trControl = ctrl,    
               tuneGrid = grid,
               linout = 1
)

grid <-  expand.grid(size = seq(from = 1, to = 10, by = 1)     
                     , decay = c(0.5, 0.1, 1e-2, 1e-3, 1e-4, 1e-5, 1e-6, 1e-7))  

nnet4 <- train(peak_load ~ .,       
               data = train,     
               method = "nnet",     
               trControl = ctrl,    
               tuneGrid = grid,
               maxit = 500,
               linout = 1
)

# testing out the nnet models on our random, 30% test set

model.pred.1 <- predict(nnet1, train)
model.pred.OOS.1 <- predict(nnet1, test)


rmse.train.1 <- rmse(actual = train$peak_load, predicted = model.pred.1)
rmse.test.1 <- rmse(actual = test$peak_load, predicted = model.pred.OOS.1)

model.pred.2 <- predict(nnet2, train)
model.pred.OOS.2 <- predict(nnet2, test)

rmse.train.2 <- rmse(actual = train$peak_load, predicted = model.pred.2)
rmse.test.2 <- rmse(actual = test$peak_load, predicted = model.pred.OOS.2)


model.pred.3 <- predict(nnet3, train)
model.pred.OOS.3 <- predict(nnet3, test)


rmse.train.3 <- rmse(actual = train$peak_load, predicted = model.pred.3)
rmse.test.3 <- rmse(actual = test$peak_load, predicted = model.pred.OOS.3)


model.pred.4 <- predict(nnet4, train)
model.pred.OOS.4 <- predict(nnet4, test)

rmse.train.4 <- rmse(actual = train$peak_load, predicted = model.pred.4)
rmse.test.4 <- rmse(actual = test$peak_load, predicted = model.pred.OOS.4)

rmse.nnet.tun.pge <- data.frame(rmse.train.1,rmse.train.2,rmse.train.3,rmse.train.4)
rmse.nnet.tun.pge.test <- data.frame(rmse.test.1, rmse.test.2, rmse.test.3, rmse.test.4)

nnet2$bestTune

# SDGE

train_index <- sample(1:nrow(peak.sdge.z), 0.7 * nrow(peak.sdge.z))

train <- peak.sdge.z[train_index,]
test <- peak.sdge.z[-train_index,]

#regression type control
ctrl <- trainControl(method="cv",     # cross-validation set approach to use
                     number=10,       # k number of times to do k-fold
                     classProbs = F,  
                     summaryFunction = defaultSummary,
                     allowParallel= T
)


nnet1 <-  train(peak_load ~ .,       
                data = train,     
                method = "nnet",     
                tuneLength = 1,
                linout = 1)

nnet2 <- train(peak_load ~ .,       
               data = train,     
               method = "nnet",     
               trControl = ctrl,    
               tuneLength = c(1:3),
               maxit = 100,
               linout = 1
)  


grid <-  expand.grid(size = c(3, 5, 10, 20)    
                     , decay = c(0.5, 0.1, 1e-2, 1e-3, 1e-4, 1e-5, 1e-6, 1e-7)) 


nnet3 <- train(peak_load ~ .,       
               data = train,     
               method = "nnet",     
               trControl = ctrl,    
               tuneGrid = grid,
               linout = 1
)

grid <-  expand.grid(size = seq(from = 1, to = 10, by = 1)     
                     , decay = c(0.5, 0.1, 1e-2, 1e-3, 1e-4, 1e-5, 1e-6, 1e-7))  

nnet4 <- train(peak_load ~ .,       
               data = train,     
               method = "nnet",     
               trControl = ctrl,    
               tuneGrid = grid,
               maxit = 500,
               linout = 1
)

# testing out the nnet models on our random, 30% test set

model.pred.1 <- predict(nnet1, train)
model.pred.OOS.1 <- predict(nnet1, test)


rmse.train.1 <- rmse(actual = train$peak_load, predicted = model.pred.1)
rmse.test.1 <- rmse(actual = test$peak_load, predicted = model.pred.OOS.1)

model.pred.2 <- predict(nnet2, train)
model.pred.OOS.2 <- predict(nnet2, test)

rmse.train.2 <- rmse(actual = train$peak_load, predicted = model.pred.2)
rmse.test.2 <- rmse(actual = test$peak_load, predicted = model.pred.OOS.2)


model.pred.3 <- predict(nnet3, train)
model.pred.OOS.3 <- predict(nnet3, test)


rmse.train.3 <- rmse(actual = train$peak_load, predicted = model.pred.3)
rmse.test.3 <- rmse(actual = test$peak_load, predicted = model.pred.OOS.3)


model.pred.4 <- predict(nnet4, train)
model.pred.OOS.4 <- predict(nnet4, test)

rmse.train.4 <- rmse(actual = train$peak_load, predicted = model.pred.4)
rmse.test.4 <- rmse(actual = test$peak_load, predicted = model.pred.OOS.4)

rmse.nnet.tun.sdge <- data.frame(rmse.train.1,rmse.train.2,rmse.train.3,rmse.train.4)
rmse.nnet.tun.sdge.test <- data.frame(rmse.test.1, rmse.test.2, rmse.test.3, rmse.test.4)

nnet4$bestTune


###### fitting and comparing the RMSE of all models separated by quantile #####
# randomly getting train and test, but keep them marked for ordering and getting quantile results later

obs.data.lawp <- as.data.frame(cbind(peak.lawp.z[,1], seq(1:nrow(peak.lawp.z))))
colnames(obs.data.lawp) <- c('obs_peak_load', 'original_key')
obs.data.lawp.ord <- as.data.frame(obs.data.lawp[order(obs.data.lawp$obs_peak_load),])
obs.data.lawp.ord <- cbind(obs.data.lawp.ord, seq(1:nrow(obs.data.lawp.ord)))
colnames(obs.data.lawp.ord) <- c('obs_peak_load', 'original_key', 'ord_idx')
obs.data.lawp <- inner_join(obs.data.lawp, obs.data.lawp.ord, by = 'original_key')
obs.data.lawp <- obs.data.lawp[,3:4]
colnames(obs.data.lawp) <- c('obs_peak_load', 'ord_idx')

obs.data.pge <- as.data.frame(cbind(peak.pge.z[,1], seq(1:nrow(peak.pge.z))))
colnames(obs.data.pge) <- c('obs_peak_load', 'original_key')
obs.data.pge.ord <- as.data.frame(obs.data.pge[order(obs.data.pge$obs_peak_load),])
obs.data.pge.ord <- cbind(obs.data.pge.ord, seq(1:nrow(obs.data.pge.ord)))
colnames(obs.data.pge.ord) <- c('obs_peak_load', 'original_key', 'ord_idx')
obs.data.pge <- inner_join(obs.data.pge, obs.data.pge.ord, by = 'original_key')
obs.data.pge <- obs.data.pge[,3:4]
colnames(obs.data.pge) <- c('obs_peak_load', 'ord_idx')

obs.data.sdge <- as.data.frame(cbind(peak.sdge.z[,1], seq(1:nrow(peak.sdge.z))))
colnames(obs.data.sdge) <- c('obs_peak_load', 'original_key')
obs.data.sdge.ord <- as.data.frame(obs.data.sdge[order(obs.data.sdge$obs_peak_load),])
obs.data.sdge.ord <- cbind(obs.data.sdge.ord, seq(1:nrow(obs.data.sdge.ord)))
colnames(obs.data.sdge.ord) <- c('obs_peak_load', 'original_key', 'ord_idx')
obs.data.sdge <- inner_join(obs.data.sdge, obs.data.sdge.ord, by = 'original_key')
obs.data.sdge <- obs.data.sdge[,3:4]
colnames(obs.data.sdge) <- c('obs_peak_load', 'ord_idx')


# folds and vectors to store rmse values
folds.lawp <- cut(seq(1,nrow(obs.data.lawp)),breaks=10,labels=FALSE)
train.bart.lawp <- vector("numeric", 10)
test.bart.lawp <- vector("numeric", 10)
train.svm.lawp <- vector("numeric", 10)
test.svm.lawp <- vector("numeric", 10)
train.nnet.lawp <- vector("numeric", 10)
test.nnet.lawp <- vector("numeric", 10)

folds.pge <- cut(seq(1,nrow(obs.data.pge)),breaks=10,labels=FALSE)
train.bart.pge <- vector("numeric", 10)
test.bart.pge <- vector("numeric", 10)
train.svm.pge <- vector("numeric", 10)
test.svm.pge <- vector("numeric", 10)
train.nnet.pge <- vector("numeric", 10)
test.nnet.pge <- vector("numeric", 10)

folds.sdge <- cut(seq(1,nrow(obs.data.sdge)),breaks=10,labels=FALSE)
train.bart.sdge <- vector("numeric", 10)
test.bart.sdge <- vector("numeric", 10)
train.svm.sdge <- vector("numeric", 10)
test.svm.sdge <- vector("numeric", 10)
train.nnet.sdge <- vector("numeric", 10)
test.nnet.sdge <- vector("numeric", 10)

peak.lawp.z$ord_idx <- obs.data.lawp$ord_idx
peak.pge.z$ord_idx <- obs.data.pge$ord_idx
peak.sdge.z$ord_idx <- obs.data.sdge$ord_idx

yhat.list.lawp <- list()
yhat.list.pge <- list()
yhat.list.sdge <- list()

for(i in 1:10){
  
  testIndexes <- which(folds.lawp==i,arr.ind=TRUE)
  train.lawp <- peak.lawp.z[-testIndexes, ]
  test.lawp <- peak.lawp.z[testIndexes, ]
  
  testIndexes <- which(folds.pge==i,arr.ind=TRUE)
  train.pge <- peak.pge.z[-testIndexes, ]
  test.pge <- peak.pge.z[testIndexes, ]
  
  testIndexes <- which(folds.sdge==i,arr.ind=TRUE)
  train.sdge <- peak.sdge.z[-testIndexes, ]
  test.sdge <- peak.sdge.z[testIndexes, ]
  
  # BART
  
  bart.lawp <- bartMachine(train.lawp[,c(2,7)], train.lawp$peak_load, k=lawp.avg.model.z$k, q=lawp.avg.model.z$q, num_trees = lawp.avg.model.z$num_trees, serialize = T)
  bart.pge <- bartMachine(train.pge[,c(2,5)], train.pge$peak_load, k=pge.avg.model.z$k, q=pge.avg.model.z$q, num_trees = pge.avg.model.z$num_trees, serialize = T) 
  bart.sdge <- bartMachine(train.sdge[,c(2,5)], train.sdge$peak_load, k=sdge.avg.model.z$k, q=sdge.avg.model.z$q, num_trees = sdge.avg.model.z$num_trees, serialize = T) 
  
  bart.pred.train.lawp <- predict(bart.lawp, train.lawp[,c(2,7)])
  bart.pred.test.lawp <- predict(bart.lawp, test.lawp[,c(2,7)])
  train.bart.lawp[i] <- rmse(actual = train.lawp$peak_load, predicted = bart.pred.train.lawp)
  test.bart.lawp[i] <- rmse(actual = test.lawp$peak_load, predicted = bart.pred.test.lawp)
  
  bart.pred.train.pge <- predict(bart.pge, train.pge[,c(2,5)])
  bart.pred.test.pge <- predict(bart.pge, test.pge[,c(2,5)])
  train.bart.pge[i] <- rmse(actual = train.pge$peak_load, predicted = bart.pred.train.pge)
  test.bart.pge[i] <- rmse(actual = test.pge$peak_load, predicted = bart.pred.test.pge)
  
  bart.pred.train.sdge <- predict(bart.sdge, train.sdge[,c(2,5)])
  bart.pred.test.sdge <- predict(bart.sdge, test.sdge[,c(2,5)])
  train.bart.sdge[i] <- rmse(actual = train.sdge$peak_load, predicted = bart.pred.train.sdge)
  test.bart.sdge[i] <- rmse(actual = test.sdge$peak_load, predicted = bart.pred.test.sdge)
  
  
  # SVM
  
  svm.lawp <- svm(peak_load ~., data = train.lawp[,c(1,2,5)], kernel = 'radial', cost = 64, gamma = 1)
  svm.pge <- svm(peak_load ~., data = train.pge[,c(-8)], kernel = 'linear', cost = 128) # don't need a gamma for linear kernel 
  svm.sdge <- svm(peak_load ~., data = train.sdge[,c(1,2,5)], kernel = 'radial', cost = 32, gamma = 0.03125)
  
  svm.pred.train.lawp <- predict(svm.lawp, train.lawp[,c(2,5)])
  svm.pred.test.lawp <- predict(svm.lawp, test.lawp[,c(2,5)])
  train.svm.lawp[i] <- rmse(actual = train.lawp$peak_load, predicted = svm.pred.train.lawp)
  test.svm.lawp[i] <- rmse(actual = test.lawp$peak_load, predicted = svm.pred.test.lawp)
  
  svm.pred.train.pge <- predict(svm.pge, train.pge[,c(-1,-8)])
  svm.pred.test.pge <- predict(svm.pge, test.pge[,c(-1,-8)])
  train.svm.pge[i] <- rmse(actual = train.pge$peak_load, predicted = svm.pred.train.pge)
  test.svm.pge[i] <- rmse(actual = test.pge$peak_load, predicted = svm.pred.test.pge)
  
  svm.pred.train.sdge <- predict(svm.sdge, train.sdge[,c(2,5)])
  svm.pred.test.sdge <- predict(svm.sdge, test.sdge[,c(2,5)])
  train.svm.sdge[i] <- rmse(actual = train.sdge$peak_load, predicted = svm.pred.train.sdge)
  test.svm.sdge[i] <- rmse(actual = test.sdge$peak_load, predicted = svm.pred.test.sdge)
  
  # NNET
  
  nnet.lawp <- nnet(peak_load~., data= train.lawp[-8], size = 7, decay = 0.001)
  nnet.pge <- nnet(peak_load~., data = train.pge[,-8], size = 1, decay = 0.001)
  nnet.sdge <- nnet(peak_load~.,data = train.sdge[,-8], size = 9, decay = 0.01)
  
  nnet.pred.train.lawp <- predict(nnet.lawp, train.lawp[,c(-1,-8)])
  nnet.pred.test.lawp <- predict(nnet.lawp, test.lawp[,c(-1,-8)])
  train.nnet.lawp[i] <- rmse(actual = train.lawp$peak_load, predicted = nnet.pred.train.lawp)
  test.nnet.lawp[i] <- rmse(actual = test.lawp$peak_load, predicted = nnet.pred.test.lawp)
  
  nnet.pred.train.pge <- predict(nnet.pge, train.pge[,c(-1,-8)])
  nnet.pred.test.pge <- predict(nnet.pge, test.pge[,c(-1,-8)])
  train.nnet.pge[i] <- rmse(actual = train.pge$peak_load, predicted = nnet.pred.train.pge)
  test.nnet.pge[i] <- rmse(actual = test.pge$peak_load, predicted = nnet.pred.test.pge)
  
  nnet.pred.train.sdge <- predict(nnet.sdge, train.sdge[,c(-1,-8)])
  nnet.pred.test.sdge <- predict(nnet.sdge, test.sdge[,c(-1,-8)])
  train.nnet.sdge[i] <- rmse(actual = train.sdge$peak_load, predicted = nnet.pred.train.sdge)
  test.nnet.sdge[i] <- rmse(actual = test.sdge$peak_load, predicted = nnet.pred.test.sdge)
  
  lawp.yhat <- as.data.frame(cbind(test.lawp$peak_load, bart.pred.test.lawp, svm.pred.test.lawp, nnet.pred.test.lawp, test.lawp$ord_idx))
  colnames(lawp.yhat) <- c('obs_value', 'bart_yhat', 'svm_yhat', 'nnet_yhat', 'ord_idx')
  yhat.list.lawp[[i]] <- lawp.yhat
  
  svm.yhat <- as.data.frame(cbind(test.pge$peak_load, bart.pred.test.pge, svm.pred.test.pge, nnet.pred.test.pge, test.pge$ord_idx))
  colnames(svm.yhat) <- c('obs_value', 'bart_yhat', 'svm_yhat', 'nnet_yhat', 'ord_idx')
  yhat.list.pge[[i]] <- svm.yhat
  
  nnet.yhat <- as.data.frame(cbind(test.sdge$peak_load, bart.pred.test.pge, svm.pred.test.sdge, nnet.pred.test.sdge, test.sdge$ord_idx))
  colnames(nnet.yhat) <- c('obs_value','bart_yhat', 'svm_yhat', 'nnet_yhat', 'ord_idx')
  yhat.list.sdge[[i]] <- nnet.yhat
  
  
  
}

##### Results by quantile for tuning outside the final CV loop #####
# neural networks is not working well
# for this part, I will ignore the nnet results (it's contantly prediction a lot of zeroes, even though the model was tuned)
# check nnet again when you run the models with the constant tuning inside the CV loop -> different models for each training fold
# however, that might not be as interesting; send the results for SVM and BART only for now and see what Roshi and Rohini think
# then, on BART and SVM start doing the sample training tests -> first look for umbalanced class in regression type of articles

yhat.lawp <- do.call("rbind", yhat.list.lawp)
yhat.pge <- do.call("rbind", yhat.list.pge)
yhat.sdge <- do.call("rbind", yhat.list.sdge)

yhat.lawp <- as.data.frame(yhat.lawp[order(yhat.lawp$ord_idx),])
yhat.pge <- as.data.frame(yhat.pge[order(yhat.pge$ord_idx),])
yhat.sdge <- as.data.frame(yhat.sdge[order(yhat.sdge$ord_idx),])

# dropping nnet bad results
#yhat.lawp <- yhat.lawp[,-4]
#yhat.pge <- yhat.pge[,-4]
#yhat.sdge <- yhat.sdge[,-4]

rmse.lawp <- data.frame(character(10), numeric(10), numeric(10))
rmse.lawp[,1] <- c('10th', '20th', '30th', '40th', '50th', '60th_last', '70th_last', '80th_last', '90th_last', 'All')
colnames(rmse.lawp) <- c('quantile', 'rmse_bart', 'rmse_svm')

qt.lawp <- quantile(yhat.lawp$obs_value, c(.1,.2,.3,.4,.5,.6,.7,.8,.9))
which(yhat.lawp$obs_value < qt.lawp[1])

rmse.lawp[1,2] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value < qt.lawp[1])], predicted = yhat.lawp$bart_yhat[which(yhat.lawp$obs_value < qt.lawp[1])])
rmse.lawp[2,2] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value < qt.lawp[2])], predicted = yhat.lawp$bart_yhat[which(yhat.lawp$obs_value < qt.lawp[2])])
rmse.lawp[3,2] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value < qt.lawp[3])], predicted = yhat.lawp$bart_yhat[which(yhat.lawp$obs_value < qt.lawp[3])])
rmse.lawp[4,2] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value < qt.lawp[4])], predicted = yhat.lawp$bart_yhat[which(yhat.lawp$obs_value < qt.lawp[4])])
rmse.lawp[5,2] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value < qt.lawp[5])], predicted = yhat.lawp$bart_yhat[which(yhat.lawp$obs_value < qt.lawp[5])])
rmse.lawp[6,2] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value > qt.lawp[6])], predicted = yhat.lawp$bart_yhat[which(yhat.lawp$obs_value > qt.lawp[6])])
rmse.lawp[7,2] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value > qt.lawp[7])], predicted = yhat.lawp$bart_yhat[which(yhat.lawp$obs_value > qt.lawp[7])])
rmse.lawp[8,2] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value > qt.lawp[8])], predicted = yhat.lawp$bart_yhat[which(yhat.lawp$obs_value > qt.lawp[8])])
rmse.lawp[9,2] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value > qt.lawp[9])], predicted = yhat.lawp$bart_yhat[which(yhat.lawp$obs_value > qt.lawp[9])])
rmse.lawp[10,2] <- rmse(actual = yhat.lawp$obs_value, predicted = yhat.lawp$bart_yhat)

rmse.lawp[1,3] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value < qt.lawp[1])], predicted = yhat.lawp$svm_yhat[which(yhat.lawp$obs_value < qt.lawp[1])])
rmse.lawp[2,3] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value < qt.lawp[2])], predicted = yhat.lawp$svm_yhat[which(yhat.lawp$obs_value < qt.lawp[2])])
rmse.lawp[3,3] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value < qt.lawp[3])], predicted = yhat.lawp$svm_yhat[which(yhat.lawp$obs_value < qt.lawp[3])])
rmse.lawp[4,3] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value < qt.lawp[4])], predicted = yhat.lawp$svm_yhat[which(yhat.lawp$obs_value < qt.lawp[4])])
rmse.lawp[5,3] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value < qt.lawp[5])], predicted = yhat.lawp$svm_yhat[which(yhat.lawp$obs_value < qt.lawp[5])])
rmse.lawp[6,3] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value > qt.lawp[6])], predicted = yhat.lawp$svm_yhat[which(yhat.lawp$obs_value > qt.lawp[6])])
rmse.lawp[7,3] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value > qt.lawp[7])], predicted = yhat.lawp$svm_yhat[which(yhat.lawp$obs_value > qt.lawp[7])])
rmse.lawp[8,3] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value > qt.lawp[8])], predicted = yhat.lawp$svm_yhat[which(yhat.lawp$obs_value > qt.lawp[8])])
rmse.lawp[9,3] <- rmse(actual = yhat.lawp$obs_value[which(yhat.lawp$obs_value > qt.lawp[9])], predicted = yhat.lawp$svm_yhat[which(yhat.lawp$obs_value > qt.lawp[9])])
rmse.lawp[10,3] <- rmse(actual = yhat.lawp$obs_value, predicted = yhat.lawp$svm_yhat)

write.csv(rmse.lawp, file = "rmse_lawp.csv", row.names = F)


rmse.pge <- data.frame(character(10), numeric(10), numeric(10))
rmse.pge[,1] <- c('10th', '20th', '30th', '40th', '50th', '60th_last', '70th_last', '80th_last', '90th_last', 'All')
colnames(rmse.pge) <- c('quantile', 'rmse_bart', 'rmse_svm')

qt.pge <- quantile(yhat.pge$obs_value, c(.1,.2,.3,.4,.5,.6,.7,.8,.9))
which(yhat.pge$obs_value < qt.pge[1])

rmse.pge[1,2] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value < qt.pge[1])], predicted = yhat.pge$bart_yhat[which(yhat.pge$obs_value < qt.pge[1])])
rmse.pge[2,2] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value < qt.pge[2])], predicted = yhat.pge$bart_yhat[which(yhat.pge$obs_value < qt.pge[2])])
rmse.pge[3,2] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value < qt.pge[3])], predicted = yhat.pge$bart_yhat[which(yhat.pge$obs_value < qt.pge[3])])
rmse.pge[4,2] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value < qt.pge[4])], predicted = yhat.pge$bart_yhat[which(yhat.pge$obs_value < qt.pge[4])])
rmse.pge[5,2] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value < qt.pge[5])], predicted = yhat.pge$bart_yhat[which(yhat.pge$obs_value < qt.pge[5])])
rmse.pge[6,2] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value > qt.pge[6])], predicted = yhat.pge$bart_yhat[which(yhat.pge$obs_value > qt.pge[6])])
rmse.pge[7,2] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value > qt.pge[7])], predicted = yhat.pge$bart_yhat[which(yhat.pge$obs_value > qt.pge[7])])
rmse.pge[8,2] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value > qt.pge[8])], predicted = yhat.pge$bart_yhat[which(yhat.pge$obs_value > qt.pge[8])])
rmse.pge[9,2] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value > qt.pge[9])], predicted = yhat.pge$bart_yhat[which(yhat.pge$obs_value > qt.pge[9])])
rmse.pge[10,2] <- rmse(actual = yhat.pge$obs_value, predicted = yhat.pge$bart_yhat)

rmse.pge[1,3] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value < qt.pge[1])], predicted = yhat.pge$svm_yhat[which(yhat.pge$obs_value < qt.pge[1])])
rmse.pge[2,3] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value < qt.pge[2])], predicted = yhat.pge$svm_yhat[which(yhat.pge$obs_value < qt.pge[2])])
rmse.pge[3,3] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value < qt.pge[3])], predicted = yhat.pge$svm_yhat[which(yhat.pge$obs_value < qt.pge[3])])
rmse.pge[4,3] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value < qt.pge[4])], predicted = yhat.pge$svm_yhat[which(yhat.pge$obs_value < qt.pge[4])])
rmse.pge[5,3] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value < qt.pge[5])], predicted = yhat.pge$svm_yhat[which(yhat.pge$obs_value < qt.pge[5])])
rmse.pge[6,3] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value > qt.pge[6])], predicted = yhat.pge$svm_yhat[which(yhat.pge$obs_value > qt.pge[6])])
rmse.pge[7,3] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value > qt.pge[7])], predicted = yhat.pge$svm_yhat[which(yhat.pge$obs_value > qt.pge[7])])
rmse.pge[8,3] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value > qt.pge[8])], predicted = yhat.pge$svm_yhat[which(yhat.pge$obs_value > qt.pge[8])])
rmse.pge[9,3] <- rmse(actual = yhat.pge$obs_value[which(yhat.pge$obs_value > qt.pge[9])], predicted = yhat.pge$svm_yhat[which(yhat.pge$obs_value > qt.pge[9])])
rmse.pge[10,3] <- rmse(actual = yhat.pge$obs_value, predicted = yhat.pge$svm_yhat)

write.csv(rmse.pge, file = "rmse_pge.csv", row.names = F)


rmse.sdge <- data.frame(character(10), numeric(10), numeric(10))
rmse.sdge[,1] <- c('10th', '20th', '30th', '40th', '50th', '60th_last', '70th_last', '80th_last', '90th_last', 'All')
colnames(rmse.sdge) <- c('quantile', 'rmse_bart', 'rmse_svm')

qt.sdge <- quantile(yhat.sdge$obs_value, c(.1,.2,.3,.4,.5,.6,.7,.8,.9))
which(yhat.sdge$obs_value < qt.sdge[1])

rmse.sdge[1,2] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value < qt.sdge[1])], predicted = yhat.sdge$bart_yhat[which(yhat.sdge$obs_value < qt.sdge[1])])
rmse.sdge[2,2] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value < qt.sdge[2])], predicted = yhat.sdge$bart_yhat[which(yhat.sdge$obs_value < qt.sdge[2])])
rmse.sdge[3,2] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value < qt.sdge[3])], predicted = yhat.sdge$bart_yhat[which(yhat.sdge$obs_value < qt.sdge[3])])
rmse.sdge[4,2] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value < qt.sdge[4])], predicted = yhat.sdge$bart_yhat[which(yhat.sdge$obs_value < qt.sdge[4])])
rmse.sdge[5,2] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value < qt.sdge[5])], predicted = yhat.sdge$bart_yhat[which(yhat.sdge$obs_value < qt.sdge[5])])
rmse.sdge[6,2] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value > qt.sdge[6])], predicted = yhat.sdge$bart_yhat[which(yhat.sdge$obs_value > qt.sdge[6])])
rmse.sdge[7,2] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value > qt.sdge[7])], predicted = yhat.sdge$bart_yhat[which(yhat.sdge$obs_value > qt.sdge[7])])
rmse.sdge[8,2] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value > qt.sdge[8])], predicted = yhat.sdge$bart_yhat[which(yhat.sdge$obs_value > qt.sdge[8])])
rmse.sdge[9,2] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value > qt.sdge[9])], predicted = yhat.sdge$bart_yhat[which(yhat.sdge$obs_value > qt.sdge[9])])
rmse.sdge[10,2] <- rmse(actual = yhat.sdge$obs_value, predicted = yhat.sdge$bart_yhat)

rmse.sdge[1,3] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value < qt.sdge[1])], predicted = yhat.sdge$svm_yhat[which(yhat.sdge$obs_value < qt.sdge[1])])
rmse.sdge[2,3] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value < qt.sdge[2])], predicted = yhat.sdge$svm_yhat[which(yhat.sdge$obs_value < qt.sdge[2])])
rmse.sdge[3,3] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value < qt.sdge[3])], predicted = yhat.sdge$svm_yhat[which(yhat.sdge$obs_value < qt.sdge[3])])
rmse.sdge[4,3] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value < qt.sdge[4])], predicted = yhat.sdge$svm_yhat[which(yhat.sdge$obs_value < qt.sdge[4])])
rmse.sdge[5,3] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value < qt.sdge[5])], predicted = yhat.sdge$svm_yhat[which(yhat.sdge$obs_value < qt.sdge[5])])
rmse.sdge[6,3] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value > qt.sdge[6])], predicted = yhat.sdge$svm_yhat[which(yhat.sdge$obs_value > qt.sdge[6])])
rmse.sdge[7,3] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value > qt.sdge[7])], predicted = yhat.sdge$svm_yhat[which(yhat.sdge$obs_value > qt.sdge[7])])
rmse.sdge[8,3] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value > qt.sdge[8])], predicted = yhat.sdge$svm_yhat[which(yhat.sdge$obs_value > qt.sdge[8])])
rmse.sdge[9,3] <- rmse(actual = yhat.sdge$obs_value[which(yhat.sdge$obs_value > qt.sdge[9])], predicted = yhat.sdge$svm_yhat[which(yhat.sdge$obs_value > qt.sdge[9])])
rmse.sdge[10,3] <- rmse(actual = yhat.sdge$obs_value, predicted = yhat.sdge$svm_yhat)

write.csv(rmse.sdge, file = "rmse_sdge.csv", row.names = F)





