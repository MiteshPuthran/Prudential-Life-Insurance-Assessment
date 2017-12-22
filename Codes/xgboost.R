#install.packages("xgboost")
#install.packages("forecast")
library("xgboost")
library("caret")
library("forecast")

#read data from loal file
train <- read.csv(file="/Users/lucyy/Documents/AdvanceDataSci/MidTermProject/DataCleaning_R/cleaningData.csv", header=TRUE, sep=",")
str(train)

#get train and test data
dim(train) 
#Sample Indexes
set.seed(66)
indexes = sample(1:nrow(train), size=0.75*nrow(train))
# Split data
train_data = train[indexes,]
dim(train_data)  
test_data = train[-indexes,]
dim(test_data) 

#reshape data
id_train <- train_data[, 2]
x_train <- as.matrix(train_data[, c(-1, -2, -3)])
nameT <- names(train_data[, c(-1, -2, -3)])
str(x_train)
y_train <- train_data[, 3]

id_test <- test_data[, 2]
x_test <- as.matrix(test_data[, c(-1, -2, -3)])
str(test_data)
y_test <- test_data[, 3]

######################################Original Model#######################################
#find best paramter
modelLookup("xgbLinear")
# set up the cross-validated hyper-parameter search
xgb_grid = expand.grid(
  nrounds = 50, 
  lambda = c(0, 0.01, 0.02, 0.04, 0.08, 0.1, 1),
  alpha = c(0, 0.01, 0.02, 0.04, 0.08, 0.1, 1),
  eta = 0.1
)

# pack the training control parameters
xgb_trcontrol = trainControl(
  method = "cv",
  number = 10,  
  allowParallel = TRUE
)

# train the model for each parameter combination in the grid
# using CV to evaluate
xgb_train <- train(
  x = x_train,
  y = y_train,
  trControl = xgb_trcontrol,
  tuneGrid = xgb_grid,
  method = "xgbLinear"
)
print(xgb_train$bestTune)

#using linear regression
dtrain <- xgb.DMatrix(x_train, label = y_train)
dtest <- xgb.DMatrix(x_test, label = y_test)
watchlist <- list(eval = dtest, train = dtrain)
param <- list(booster = "gblinear", max_depth = 10, silent = 1, nthread = 2, objective = "reg:linear", lambda = 1, alpha = 0.08)
#calculate the best nrounds
xgbcv <- xgb.cv( params = param, data = dtrain, nrounds = 3000, nfold = 5, showsd = T, stratified = T, early.stop.round = 20, maximize = F)
print(xgbcv)
xgboost <- xgb.train(param, dtrain, nrounds = 486, watchlist)
#see the performance of this model
label = getinfo(dtest, "label")
pred <- predict(xgboost, dtest)
pResult <- round(pred, digits = 0)
pResult[pResult<1] <- 1
pResult[pResult>8] <- 8
confusionMatrix (pResult, label)
accuracy(pResult, label)

#find the importance of factors
impParameter <- xgb.importance (feature_names = nameT, model = xgboost)
xgb.plot.importance (importance_matrix = impParameter[1:39]) 

#################################Construct better model####################################
#reshape data
bx_train <- as.matrix(train_data[, c(-1, -2, -3,-7, -8, -14, -23, -38)])
bnameT <- names(train_data[, c(-1, -2, -3,-7, -8, -14, -23, -38)])

bx_test <- as.matrix(test_data[, c(-1, -2, -3, -14, -23, -38)])
str(train_data)

#find best paramter
modelLookup("xgbLinear")
# set up the cross-validated hyper-parameter search
xgb_grid = expand.grid(
  nrounds = 50, 
  lambda = c(0, 0.01, 0.02, 0.04, 0.08, 0.1, 1),
  alpha = c(0, 0.01, 0.02, 0.04, 0.08, 0.1, 1),
  eta = 0.1
)

# pack the training control parameters
xgb_trcontrol = trainControl(
  method = "cv",
  number = 10,  
  allowParallel = TRUE
)

# train the model for each parameter combination in the grid
# using CV to evaluate
xgb_train <- train(
  x = bx_train,
  y = y_train,
  trControl = xgb_trcontrol,
  tuneGrid = xgb_grid,
  method = "xgbLinear",
  metric = "rmse"
)
print(xgb_train$bestTune)

#using linear regression
bdtrain <- xgb.DMatrix(bx_train, label = y_train)
bdtest <- xgb.DMatrix(bx_test, label = y_test)
watchlist <- list(eval = bdtest, train = bdtrain)
#calculate the best depth of the tree
for(i in 3 : 10){
  param <- list(booster = "gblinear", max_depth = i, silent = 1, nthread = 2, objective = "reg:linear", lambda = 1, alpha = 1)
  xgbcv <- xgb.cv( params = param, data = bdtrain, nrounds = 10, nfold = 5, showsd = T, stratified = T, early.stop.round = 20, maximize = F, metric = "rmse")
  print("****************************************************")
  print(i)
  print(xgbcv)
}
#calculate the best nrounds
param <- list(booster = "gblinear", max_depth = 4, silent = 1, nthread = 2, objective = "reg:linear", lambda = 1, alpha = 0.01)
xgbcv <- xgb.cv( params = param, data = bdtrain, nrounds = 1000, nfold = 5, showsd = T, stratified = T, maximize = F, early.stop.round = 20)
print(xgbcv)
#run the model
xgboost <- xgb.train(param, bdtrain, nrounds = 467, watchlist)
#see the performance of this model
label = getinfo(bdtest, "label")
pred <- predict(xgboost, bdtest)
pResult <- round(pred, digits = 0)
pResult[pResult<1] <- 1
pResult[pResult>8] <- 8
confusionMatrix (pResult, label)
accuracy(pResult, label)





