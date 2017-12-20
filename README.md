# Prudential Life Insurance Assessment

![](images/front_page.png?raw=true)
<br>
The assessment involves predicting the risk factor for the company while giving health insurance for the applicants based on their medical hisory. Five different methods were used to predict the risk: Linear Regression model, Decision Tree, Support Vector Machine, XGBoost and Neuralnetwork.

## Dataset:
[Prudential Life Insurance Assessment](https://www.kaggle.com/c/prudential-life-insurance-assessment) from Kaggle. The dataset is two different CSV files already divided into training and testing. The dataset has various different columns which specify different kinds of data. The columns of the dataset include continious varibles, discrete vriables and categorical variables which is clearly stated in the datasets documentation.

## Data Pre-Processing
* The main step involved in any data science assessment is cleaning the data and making it useful for analysis. The preprocessing started with taking care of columns which have more than 50% of data missing. These columns were removed from further processing as it would interfere with the accuracy of our model.
* The next step was to take care of the remaining missing values in the dataset. These null values can be filled in different ways. That includes filling with mean, median or average values based on plotting the box plot method to determine them.
* After dealing with the missing values, the categorical columns come into the question which follows the same concept of 1-to-C encoding. For this purpose we make use of the ade4 library to deal with the categorical columns. 

* On categorizing all the required columns we get around 890 columns in total but not all the columns are significant. So in order to get the significant columns we need to have asignificancwe level and use different methods like linear regression, PCA or LDA to figure it out. On applying LDA we settled with 52 significant columns 
