# SVM Model
#Importing caret and e1071 libraries

library(caret)
library(e1071)


#reading the training dataset from the csv
prudentialData_Train <- read.csv(file="Raw_Data/finaltrainingdata300.csv", header=TRUE, sep= ',')
# reading the test dataset from the csv
prudentialData_Test <- read.csv(file="Raw_Data/Final_Test_Data.csv", header=TRUE, sep= ',')

#identify the structure of the train dataset
str(prudentialData_Train)
str(prudentialData_Test)
#identify the structure of the test dataset
dim(prudentialData_Train)
dim(prudentialData_Test)

#####################################################

#Tuning the svm models. 
#We will get optimal cost and gamma parameter which we will use in next section for creating svm model.
#We are using Linear, Polynomial, Sigmoid and Radial kernels to create svm model, later we will check the accuracy of all the kernels whichever is best in terms of accuracy we will pick it.

#tuning the dataset using "linear kernel"
svm_tune_lin <- tune(svm, response ~ .,
                     data = prudentialData_Train,
                     kernel="linear",
                     ranges=list(cost=10^(-1:2),
                                 gamma=c(.5,1,2),
                                 scale=F
                     ))
#summary of the tuning
sumry_lin <- summary(svm_tune_lin)
#printing the summary
print(sumry_lin$best.parameters)

#tuning the dataset using "sigmoid kernel"
svm_tune_sigm <- tune(svm, response~ .,
                      data = prudentialData_Train,
                      kernel="sigmoid",
                      ranges=list(cost=10^(-1:2),
                                  gamma=c(.5,1,2),
                                  scale=F
                      ))
#summary of the tuning
sumry_sigm <- summary(svm_tune_sigm)
#printing the summary
print(sumry_sigm$best.parameters)


#tuning the dataset using "radial kernel"
svm_tune_rad <- tune(svm, response ~ .,
                     data = prudentialData_Train,
                     kernel="radial",
                     ranges=list(cost=10^(-1:2),
                                 gamma=c(.5,1,2),
                                 scale=F
                     ))
#summary of the tuning
sumry_rad <- summary(svm_tune_rad)
#printing the summary
print(sumry_rad$best.parameters)


#tuning the dataset using "polynomial kernel"
svm_tune_poly <- tune(svm, response ~ .,
                      data = prudentialData_Train,
                      kernel="polynomial",
                      ranges=list(cost=10^(-1:2),
                                  gamma=c(.5,1,2),
                                  scale=F
                      ))
#summary of the tuning
sumry_ploy <- summary(svm_tune_poly)
#printing the summary
print(sumry_ploy$best.parameters)

###################################################

#Fitting the models with different kernels
svm_fit_linear <- svm(response ~ ., kernel="linear", cost = 0.1,scale = FALSE, data = prudentialData_Train)
print(svm_fit_linear)

svm_fit_sigmoid <- svm(response ~ ., kernel="sigmoid", cost = 0.1, gamma=0.5, scale = FALSE, data = prudentialData_Train)
print(svm_fit_sigmoid)

svm_fit_radial <- svm(response ~ ., kernel="radial", cost = 100, scale=FALSE, gamma=0.5,data = prudentialData_Train)
print(svm_fit_radial)

svm_fit_polynomial <- svm(response ~ ., kernel="polynomial", cost = 10, gamma=0.5,scale= FALSE, data = prudentialData_Train)
print(svm_fit_polynomial)


#Now we will predict the Credit Worthiness (response) feature for all the svm models with diffrent kernels and later in next section we will check for the accuracy of the prediction.

###########Predicting the values####################

#####Linear Kernel########
linearpredictions <-  predict(svm_fit_linear, prudentialData_Test[-52])
linearvalues<-prudentialData_Train[,52]

#rounding off the predicted values
roundpred<-round(linearpredictions, digits = 0)

#creating the confusion matrix
table(roundpred,linearvalues)

#######Sigmoid Kernel########
sigmoidpredictions <-  predict(svm_fit_sigmoid, prudentialData_Test[-52])
sigmoidvalues<-prudentialData_Train[,52]

#rounding off the predicted values
roundpred<-round(sigmoidpredictions, digits = 0)

#creating the confusion matrix
table(roundpred,sigmoidvalues)

########Radial Kernel###########
radialpredictions <-  predict(svm_fit_radial, prudentialData_Test[-52])
radialvalues<-prudentialData_Train[,52]

#rounding off the predicted values
roundpred<-round(radialpredictions, digits = 0)

#creating the confusion matrix
table(roundpred,radialvalues)

##########Polynomial Kernel############
polypredictions <-  predict(svm_fit_polynomial, prudentialData_Test[-52])
polyvalues<-prudentialData_Train[,52]

#rounding off the predicted values
roundpred<-round(polypredictions, digits = 0)

#creating the confusion matrix
table(roundpred,polyvalues)

