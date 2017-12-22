# Prudential Life Insurance Assessment

![](images/front_page.png?raw=true)
<br>
The assessment involves predicting the risk factor for the company while giving health insurance for the applicants based on their medical hisory. Five different methods were used to predict the risk: Linear Regression model, Decision Tree, Support Vector Machine, XGBoost and Neuralnetwork.

## Dataset:
[Prudential Life Insurance Assessment](https://www.kaggle.com/c/prudential-life-insurance-assessment) from Kaggle. The dataset is a CSV files which we divide it into training and testing with a 80:20 split. The dataset has various different columns which specify different kinds of data. The columns of the dataset include continious varibles, discrete vriables and categorical variables which is clearly stated in the datasets documentation.

## Data Pre-Processing
* The main step involved in any data science assessment is cleaning the data and making it useful for analysis. The preprocessing started with taking care of columns which have more than 50% of data missing. These columns were removed from further processing as it would interfere with the accuracy of our model.
* The next step was to take care of the remaining missing values in the dataset. These null values can be filled in different ways. That includes filling with mean, median or average values based on plotting the box plot method to determine them.
* After dealing with the missing values, the categorical columns come into the question which follows the same concept of 1-to-C encoding. For this purpose we make use of the ade4 library to deal with the categorical columns. 

* On categorizing all the required columns we get around 890 columns in total but not all the columns are significant. So in order to get the significant columns we need to have asignificancwe level and use different methods like linear regression, PCA or LDA to figure it out. On applying LDA we settled with 52 significant columns. 

## Building models to predict

**1. Linear Model:**

After getting the significant columns, linear regression was applied to the new processed dataset to predict the risk factor for the test data. The predicted results are below:
<br>
![](images/linear.PNG?raw=true)
<br>

**2. Decision Tree:**

Built a decision tree model to predict the risk values in the test data.
<br>
![](images/tree.PNG?raw=true)
<br>

**3. Support Vector Machines:**

The third model built was a support vector machine model to do the predictions. For SVM all four different kernels (Radial, Linear, Sigmoid and Polynomial) were tried to get the predictions. 

**4. XGBoost:**

The XGBoost model was used to calculate the following predictions.
<br>
![](images/xgboost.PNG?raw=true)
<br>
<br>
![](images/xgboost1.PNG?raw=true)
<br>
<br>
![](images/xgboost2.PNG?raw=true)
<br>

## Conclusions

After bulding four different models for the predictions. The XGBoost model performed the best with the least RMSE value. All four models have its unique characteristics which makes them useful in different situations. 

