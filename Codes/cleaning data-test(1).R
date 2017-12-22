install.packages("gam")
install.packages('ade4')
library(caret)
library(gam)
library(ade4)

#read data from local file
rawtraindata <-  read.csv(file="/Users/lucyy/Documents/AdvanceDataSci/MidTermProject/Data/train.csv", header=TRUE, sep=",")
head(rawtraindata, n=5)

##########Remove noise###############################
na <- colSums(is.na(rawtraindata))
nafreq <- na/nrow(rawtraindata)
colnames(rawtraindata[, which(nafreq > 0.5)])
colToDel <- which(nafreq > 0.5)
new_train <- rawtraindata[-colToDel]

########Selecting the categoical columns############
#using c() to return a vector and paste() to print the names again everytime instead of just displaying the number and using
# sep="" without which the column numbers will be displayed with a spcae causing error.
categoricalcolumns <- c(paste("Product_Info_", c(1:3,5:7),sep=""), paste("Employment_Info_", c(2,3,5), sep=""), 
                        paste("InsuredInfo_", 1:7, sep=""), paste("Insurance_History_", c(1:4,7:9), sep=""), paste("Family_Hist_1"),
                        paste("Medical_History_", c(2:9, 11:14, 16:23, 25:31, 33:41),sep=""),"Response")

#Selecting the discrete columns
discretecolumns <- c("Id","Medical_History_1", 
                     paste("Medical_Keyword_", 1:48, sep=""))

#Selecting the continious columns
continiouscolumns <- c("Product_Info_4", "Ins_Age", "Ht", "Wt", "BMI", "Employment_Info_1", "Employment_Info_4", 
                       "Employment_Info_6", "Insurance_History_5", "Family_Hist_2", "Family_Hist_3", "Family_Hist_4", 
                       "Family_Hist_5")

#Displaying the columns
categoricalcolumns
discretecolumns
continiouscolumns

#Combining the data with the column names
rawdatacategorical <- rawtraindata[, categoricalcolumns]
rawdatadiscrete <- rawtraindata[, discretecolumns]
rawadatacontinious <- rawtraindata[, continiouscolumns]

str(rawdatacategorical)

#Finding the columns with missing values from categorical data
sum(is.na(rawdatacategorical))

#installing the ade4 libarary to use acm.disjonctif() because our dataframe only contains factors
#acm.disjonctif an utility giving the complete disjunctive table of a factor table.
df_categorical <-acm.disjonctif(rawdatacategorical[c(1:60)]) #selecting first 60 columns except the response column
head(df_categorical, n=2)

# selecting the response value seperately so that we don't categorize it
responsevalue <-rawdatacategorical[, c(61)]

#Combining the categorized values with the response value into one dataframe
df_categoricalbinded <- cbind(df_categorical,responsevalue)
head(df_categoricalbinded, n=2)
str(df_categoricalbinded)

#Binding everything together
newrawtraindata <- cbind(rawadatacontinious,rawdatadiscrete,df_categoricalbinded)
ncol(newrawtraindata)
summary(newrawtraindata)

#make processing for independent variables
train_data <- newrawtraindata[,-893]
head(train_data)
target_data <- newrawtraindata[, 893]
head(target_data)

#Delete the variables that approximate the constant
zerovar <- nearZeroVar(train_data)
mydata <- train_data[,-zerovar]
str(mydata)

#Data preprocessing (normalization, missing value processing)
#Process <- preProcess(newdata1)
#newdata2 <- predict(Process, newdata1)
###########################Filiing missing value######################################
mydata$Employment_Info_4[is.na(mydata$Employment_Info_4)] <- median(mydata$Employment_Info_4, na.rm = TRUE)
#Filling missing values with mean value for Employment_Info_6
mydata$Employment_Info_6[is.na(mydata$Employment_Info_6)] <- median(mydata$Employment_Info_6, na.rm = TRUE)
#Filling missing values with max value for Insurance_History_5
mydata$Insurance_History_5[is.na(mydata$Insurance_History_5)] <- median(mydata$Insurance_History_5, na.rm = TRUE)
#Filling missing values with min value for Family_Hist_2
mydata$Family_Hist_2[is.na(mydata$Family_Hist_2)] <- median(mydata$Family_Hist_2, na.rm = TRUE)
#Filling missing values with mean value for Family_Hist_3
mydata$Family_Hist_3[is.na(mydata$Family_Hist_3)] <- median(mydata$Family_Hist_3, na.rm = TRUE)
#Filling missing values with mean value for Family_Hist_4
mydata$Family_Hist_4[is.na(mydata$Family_Hist_4)] <- median(mydata$Family_Hist_4, na.rm = TRUE)
#Filling missing values with min value for Family_Hist_5
mydata$Family_Hist_5[is.na(mydata$Family_Hist_5)] <- median(mydata$Family_Hist_5, na.rm = TRUE)
#Filling missing values with mean value for Medical_History_1
mydata$Medical_History_1[is.na(mydata$Medical_History_1)] <- median(mydata$Medical_History_1, na.rm = TRUE)
#Filling missing values with median value for Medical_History_10
mydata$Medical_History_10[is.na(mydata$Medical_History_10)] <- median(mydata$Medical_History_10, na.rm = TRUE)
#Filling missing values with median value for Medical_History_15
mydata$Medical_History_15[is.na(mydata$Medical_History_15)] <- median(mydata$Medical_History_15, na.rm = TRUE)
#Filling missing values with mean value for Medical_History_24
mydata$Medical_History_24[is.na(mydata$Medical_History_24)] <- median(mydata$Medical_History_24, na.rm = TRUE)
#Filling missing values with mean value for Medical_History_32
mydata$Medical_History_32[is.na(mydata$Medical_History_32)] <- median(mydata$Medical_History_32, na.rm = TRUE)
str(mydata)

#store id in memory
id <- mydata[,13]
myData <- mydata[, -13]

nn <- ncol(myData)
colmean <- colMeans(myData, na.rm = T)
colsd <- apply(myData, 2, function(x) sd(x, na.rm = T))
for(i in 1:nn)
{
  outlier <- which(abs((myData[,i] - colmean[i]) / colsd[i]) >3)
  myData <- myData[-outlier]
}

train_dataF <- data.frame(target_data, myData)

#####################Use linear regression calculate p-value#########################
newdatafinal <- lm(train_dataF$target_data~., data = train_dataF)
summary(newdatafinal)
index <- summary(newdatafinal)$coefficients[,4] <= 0.05
str(index[index == TRUE])
indexname <- names(index[index == TRUE])[2:40]
str(indexname)
#df <- data.frame(newdatafinal)
#testDelete <- step(data.filter, direction = "backward")

cleanData <- train_dataF[indexname]
str(cleanData)
cleanDataFrame <- data.frame(id, target_data, cleanData)
str(cleanDataFrame)

write.csv(cleanDataFrame, file = "/Users/lucyy/Documents/AdvanceDataSci/MidTermProject/DataCleaning_R/cleaningData.csv")
