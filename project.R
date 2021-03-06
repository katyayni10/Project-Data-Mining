#rm(list=ls())
#nstall.packages("matrixStats")

library(matrixStats)
library(fitdistrplus) #install.packages('fitdistrplus')
library(nnet)
library('caret')
library("rpart")
library(randomForest)
library(UBL)
MyData<-read.csv('~/Documents/GitHub/Data-Mining-project/kag_risk_factors_cervical_cancer 4.csv')


#### to check null values

sum(is.na(MyData)) ### 0 null values

head(MyData)
colnames(MyData)



##### to check ? character
which(MyData=='?', arr.ind=TRUE)

##### to convert those ? chars to NA
MyData[MyData=="?"]<- NA

######## to  count NA values in each columns
na_count <-sapply(MyData, function(y) sum(length(which(is.na(y)))))
na_count <- data.frame(na_count)


##### to check factor/categorical variables and continuous variables
# f <- sapply(MyData, is.factor)
# which(f)   #### factor/categorical variables index




mat <- as.matrix(MyData)
mode(mat) = "numeric"
str(mat)


##### to give median values to NA entries in continuous variables





#### replace NA with column medians



mat[, "Number.of.sexual.partners"] <- ifelse(is.na(mat[, "Number.of.sexual.partners"]), median(mat[, "Number.of.sexual.partners"], 
                                                                                               na.rm=TRUE), mat[, "Number.of.sexual.partners"])

mat[, "First.sexual.intercourse"] <- ifelse(is.na(mat[, "First.sexual.intercourse"]), median(mat[, "First.sexual.intercourse"], 
                                                                                             na.rm=TRUE), mat[, "First.sexual.intercourse"])

mat[, "Num.of.pregnancies"] <- ifelse(is.na(mat[, "Num.of.pregnancies"]), median(mat[, "Num.of.pregnancies"], 
                                                                                 na.rm=TRUE), mat[, "Num.of.pregnancies"])

#### NA is replace with 0 in "smoke" column as there are 13 NA entries and most of the patients doesn't smoke
mat[, "Smokes"] <- ifelse(is.na(mat[, "Smokes"]), median(mat[, "Smokes"], 
                                                         na.rm=TRUE), mat[, "Smokes"])

######### In "Smokes..years."  NA should be replaced by 0 as the value of "smoke" column(which was NA before) for 
######### that patient , is 0 now as modified in above step
mat[, "Smokes..years."] <- ifelse(is.na(mat[, "Smokes..years."]), 0, mat[, "Smokes..years."])

###### The above argument applies for  "Smokes..packs.year." as well.
mat[, "Smokes..packs.year."] <- ifelse(is.na(mat[, "Smokes..packs.year."]), 0, mat[, "Smokes..packs.year."])

mat[, "Hormonal.Contraceptives"] <- ifelse(is.na(mat[, "Hormonal.Contraceptives"]), median(mat[, "Hormonal.Contraceptives"], 
                                                                                           na.rm=TRUE), mat[, "Hormonal.Contraceptives"])

###### took mean here..check if median is needed by finding accuracy at last
mat[, "Hormonal.Contraceptives..years."] <- ifelse(is.na(mat[, "Hormonal.Contraceptives..years."]), mean(mat[, "Hormonal.Contraceptives..years."], 
                                                                                                         na.rm=TRUE), mat[, "Hormonal.Contraceptives..years."])


mat[, "IUD"] <- ifelse(is.na(mat[, "IUD"]), median(mat[, "IUD"], na.rm=TRUE), mat[, "IUD"])

mat[, "IUD..years."] <- ifelse(is.na(mat[, "IUD..years."]), median(mat[, "IUD..years."], na.rm=TRUE), mat[, "IUD..years."])


mat[, "STDs"] <- ifelse(is.na(mat[, "STDs"]), median(mat[, "STDs"], na.rm=TRUE), mat[, "STDs"])

#### since median value   of STD is 0 and we filled 0 in place of NA in column "STDs",
####  We can replace NA in next 13 columns with 0 as it's the type of STD the person is having.

mat[, "STDs..number."] <- ifelse(is.na(mat[, "STDs..number."]), 0, mat[, "STDs..number."])
mat[, "STDs.condylomatosis"] <- ifelse(is.na(mat[, "STDs.condylomatosis"]), 0, mat[, "STDs.condylomatosis"])
mat[, "STDs.cervical.condylomatosis"] <- ifelse(is.na(mat[, "STDs.cervical.condylomatosis"]), 0, mat[, "STDs.cervical.condylomatosis"])
mat[, "STDs.vaginal.condylomatosis"] <- ifelse(is.na(mat[, "STDs.vaginal.condylomatosis"]), 0, mat[, "STDs.vaginal.condylomatosis"])
mat[, "STDs.vulvo.perineal.condylomatosis"] <- ifelse(is.na(mat[, "STDs.vulvo.perineal.condylomatosis"]), 0, mat[, "STDs.vulvo.perineal.condylomatosis"])
mat[, "STDs.syphilis"] <- ifelse(is.na(mat[, "STDs.syphilis"]), 0, mat[, "STDs.syphilis"])
mat[, "STDs.pelvic.inflammatory.disease"] <- ifelse(is.na(mat[, "STDs.pelvic.inflammatory.disease"]), 0, mat[, "STDs.pelvic.inflammatory.disease"])
mat[, "STDs.genital.herpes"] <- ifelse(is.na(mat[, "STDs.genital.herpes"]), 0, mat[, "STDs.genital.herpes"])
mat[, "STDs.molluscum.contagiosum"] <- ifelse(is.na(mat[, "STDs.molluscum.contagiosum"]), 0, mat[, "STDs.molluscum.contagiosum"])
mat[, "STDs.AIDS"] <- ifelse(is.na(mat[, "STDs.AIDS"]), 0, mat[, "STDs.AIDS"])
mat[, "STDs.HIV"] <- ifelse(is.na(mat[, "STDs.HIV"]), 0, mat[, "STDs.HIV"])
mat[, "STDs.Hepatitis.B"] <- ifelse(is.na(mat[, "STDs.Hepatitis.B"]), 0, mat[, "STDs.Hepatitis.B"])
mat[, "STDs.HPV"] <- ifelse(is.na(mat[, "STDs.HPV"]), 0, mat[, "STDs.HPV"])


##### "STDs..Time.since.first.diagnosis" column and "STDs..Time.since.last.diagnosis" have NA values
##### only where "STDs..Number.of.diagnosis" column has entries as 0. Hence we can replace NA
##### with 0 for the above two columns
mat[, "STDs..Time.since.first.diagnosis"] <- ifelse(is.na(mat[, "STDs..Time.since.first.diagnosis"]), 0, mat[, "STDs..Time.since.first.diagnosis"])
mat[, "STDs..Time.since.last.diagnosis"] <- ifelse(is.na(mat[, "STDs..Time.since.last.diagnosis"]), 0, mat[, "STDs..Time.since.last.diagnosis"])

##### All NA entries has been replaced. Below code verifies the same
any(is.na(mat))

## code to create last column

data <- as.data.frame(mat)

data$CancerRisk = data$Hinselmann + data$Schiller + data$Citology + data$Biopsy
data$Risk[data$CancerRisk < 1] <- 0   ##### "No risk"
data$Risk[data$CancerRisk >=1  & data$CancerRisk<= 2] <- 1  #####"medium risk"
data$Risk[data$CancerRisk >= 3 & data$CancerRisk<= 4] <- 2  ##### "high risk"







#data$CancerRisk = factor(data$CancerRisk, levels=c("0","1","2","3","4"))

#### removing the colums 
dat <- data[ -c(33,34,35,36,37) ]
#### to write updated data set to new csv
write.csv(dat, "Updated_file.csv")

#### round is rounding the output of prop.table to 2 digits
round(prop.table(table(dat$Risk)),2)





hist(dat$Risk, col = 2)

###########################################

##### check if the data is balanced

descdist(dat$Risk, discrete = FALSE)

normal_dist <- fitdist(dat$Risk, "norm")
plot(normal_dist) 

###Standardize the data
# head(dat)
# class(dat)
# Standandardize_train <- scale(dat[,-33])
# 
# var(dat[,2])
# var(dat[,3])
# 
# var(Standandardize_train[,2])
# var(Standandardize_train[,3])
# 
# var(dat[,10])
# var(Standandardize_train[,10])

# train <- sample(1:nrow(dat), nrow(dat)*.80)
# df_train <- dat[train, ]
# df_test <- dat[-train, ]
# 
# msat <- multinom(CancerRisk ~ ., data=df_train)

# library(UBL)
# 
# #sorting based in Response column
# attach(data)
# 
# # sort by response
# 
# data <-data[order(Risk),] 



dat <- within(dat, Risk[Risk == 0] <- "low")
dat <- within(dat, Risk[Risk == 1] <- "med")
dat <- within(dat, Risk[Risk == 2] <-  "high")
count<- table(dat$Risk)


# library(UBL)
# # Example with an imbalanced multi-class problem
# data(data)
# dat <- data[-c(45:75),]
# # checking the class distribution of this artificial data set
# table(data$Risk)
# #newdata <- AdasynClassif(Risk~., data, beta=1)
# 


#Oversampling
library(DMwR)
data(dat)
unbalanced<- dat
# 3 class oversampling

#BALANCED OVERSAMPLE with weight for each weak classifier
C.perc = list(high = 19, med = 12 ) 
mybalanced <- RandOverClassif(Risk~., unbalanced, C.perc)
table(mybalanced$Risk)
# 
# #BALANCED UNBALACED OVER SAMPLE weight for each weak classifier
# C.perc = list(high = 7, med = 5 ) 
# myunbalanced <- RandOverClassif(Risk~., balanced, C.perc)
# table(myunbalanced$Risk)
# 
# #BALANCED INVERTED OVERSAMPLE
# myinverted <- RandOverClassif(Risk~., data, "extreme")
# table(myinverted$Risk)

# 5 class oversampling
# 
# 

# balanced<-dat
# #BALANCED OVERSAMPLE with weight for each weak classifier
# C.perc = list('1' = 17, '2' = 33, '3'= 21,'4'=124 )
# mybalanced_class_5 <- RandOverClassif(CancerRisk~., balanced, C.perc)
# table(mybalanced_class_5$CancerRisk)
# 
# #BALANCED UNBALACED OVER SAMPLE weight for each weak classifier
# C.perc = list('1' = 9, '2' = 20, '3'= 10,'4'=100 )
# myunbalanced_class <- RandOverClassif(CancerRisk~., balanced, C.perc)
# table(myunbalanced_class$CancerRisk)
# 
# #BALANCED INVERTED OVERSAMPLE
# myinverted_class <- RandOverClassif(CancerRisk~., data, "extreme")
# table(myinverted_class$CancerRisk)


###########################
# Random Forest
###########################


set.seed(1234)

#balanced
mybalanced <- within(mybalanced, Risk[Risk == "low"] <- as.double(0) )
mybalanced <- within(mybalanced, Risk[Risk == "med"] <- as.double(1))
mybalanced <- within(mybalanced, Risk[Risk == "high"] <-  as.double(2))
mybalanced$Risk<- as.numeric(mybalanced$Risk)
count<- table(mybalanced$Risk)
#percentage split
train<- sample(1:nrow(mybalanced), .75*nrow(mybalanced))
tr <- mybalanced[train,]
te <- mybalanced[-train,]

#Numerical response data
risk_Tru_train <- as.numeric(tr$Risk)
risk_Tru_test <- as.numeric(te$Risk)

rf.fit<- randomForest(tr$Risk~. , data = tr, n.trees= 10000)
quartz()
varImpPlot(rf.fit)
importance(rf.fit)

y_hat<- predict(rf.fit, newdata= te, type= "class")
y_hat<-round(y_hat)
# y_hat<- as.numeric(y_hat)-1
misclass_rf<- sum(abs(risk_Tru_test- y_hat))/length(y_hat)
misclass_rf

print("THIS OF FOR Over Sample Balanced")
confusionMatrix(as.factor(y_hat), as.factor(risk_Tru_test))

set.seed(1234)

#unbalanced
unbalanced <- within(unbalanced, Risk[Risk == "low"] <- as.double(0) )
unbalanced <- within(unbalanced, Risk[Risk == "med"] <- as.double(1))
unbalanced <- within(unbalanced, Risk[Risk == "high"] <-  as.double(2))
unbalanced$Risk<- as.numeric(unbalanced$Risk)
count1<- table(unbalanced$Risk)
#percentage split
trainun<- sample(1:nrow(unbalanced), .75*nrow(unbalanced))
trun <- unbalanced[trainun,]
teun <- unbalanced[-trainun,]

#Numerical response data
risk_Tru_train_un <- as.numeric(trun$Risk)
risk_Tru_test_un <- as.numeric(teun$Risk)

rf.fitun<- randomForest(Risk~. , data = trun)
quartz()
varImpPlot(rf.fitun)
importance(rf.fitun)

y_hatun<- predict(rf.fitun, newdata= teun, type= "class")
y_hatun<-round(y_hatun)
# y_hat<- as.numeric(y_hat)-1
misclass_rfun<- sum(abs(risk_Tru_test_un- y_hatun))/length(y_hatun)
misclass_rfun

print("THIS OF FOR Over Sample Balanced")
confusionMatrix(as.factor(y_hatun), as.factor(risk_Tru_test_un))

##############################################
##
##convert data into binary classifaction
##
##
##############################################

set.seed(14)
data2<-dat
#balanced
data2 <- within(data2, Risk[Risk == "low"] <- as.double(0) )
data2 <- within(data2, Risk[Risk == "med"] <- as.double(1))
data2 <- within(data2, Risk[Risk == "high"] <-  as.double(2))
data2$Risk<- as.numeric(data2$Risk)
data2 <- within(data2, Risk[Risk == 0] <- "No")
data2 <- within(data2, Risk[Risk == 1] <- "Risk")
data2 <- within(data2, Risk[Risk == 2] <- "Risk")
data2 <- within(data2, Risk[Risk == "No"] <- as.double(0))
data2 <- within(data2, Risk[Risk == "Risk"] <- as.double(1))
data2 <- within(data2, Risk[Risk == "Risk"] <- as.double(1))
table(data2$Risk)
err_store<-c()
set.seed(1245)
for( i in 3:9){
C.perc = list('1'=i, '0'= 1 )
mybalanced2 <- RandOverClassif(data2$Risk~., data2, C.perc)
table(mybalanced2$Risk)
#percentage split
sampSize <- floor(0.75 * nrow(mybalanced2))
set.seed(1245)
train_ind <- sample(seq_len(nrow(mybalanced2)), size = sampSize)
train <-mybalanced2[train_ind, ]
test <-mybalanced2[-train_ind, ]

#Numerical response data
train.y <- as.numeric(train$Risk)
test.y <- as.numeric(test$Risk)

rf2.fit<- randomForest(as.numeric(train$Risk)~. , data = train, n.trees= 10000)
quartz()
varImpPlot(rf2.fit)
importance(rf2.fit)

y_hat<- predict(rf2.fit, newdata= test, type= "class")
y_hat<-round(y_hat)
# y_hat<- as.numeric(y_hat)-1
misclass_rf2<- sum(abs(test.y- y_hat))/length(y_hat)
misclass_rf2

print("THIS OF FOR Over Sample Balanced")
confusion<-confusionMatrix(as.factor(y_hat), as.factor(test.y))
err_store[i-2]<-confusion$byClass[2]
}
set.seed(1234)
index<-c(300,400,500,600,700,800,900)
plot(err_store,type='o',x=index,xlab='RISK sample Size',ylab='Specificity')


##############unbalanced2#################################################


data2$Risk<- as.numeric(data2$Risk)
count1<- table(data2$Risk)
#percentage split
sampSize <- floor(0.75 * nrow(data2))
set.seed(12345)
train_ind <- sample(seq_len(nrow(data2)), size = sampSize)
train2 <-data2[train_ind, ]
test2 <-data2[-train_ind, ]

#Numerical response data
train2.y <- as.numeric(train2$Risk)
test2.y <- as.numeric(test2$Risk)

rf2.fitun<- randomForest(Risk~. , data = train2)
quartz()
varImpPlot(rf2.fitun)
importance(rf2.fitun)

y_hatun2<- predict(rf2.fitun, newdata= test2, type= "class")
y_hatun2<-round(y_hatun)
# y_hat<- as.numeric(y_hat)-1
misclass_rfun2<- sum(abs(test2.y- y_hatun2))/length(y_hatun2)
misclass_rfun2

print("THIS OF FOR Over Sample Balanced")
confusionMatrix(as.factor(y_hatun2), as.factor(test2.y))


