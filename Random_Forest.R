#Loading the dataset

human_pose_data <- read.csv("mpii_human_pose.csv")
View(human_pose_data)

#exploring the data

head(human_pose_data)
str(human_pose_data)
summary(human_pose_data)

#factorizing the "Activity" variable

human_pose_data$Activity1 = as.numeric(factor(human_pose_data$Activity))
summary(human_pose_data)
View(human_pose_data)

#factorizing the "Category" variable

human_pose_data$Category1 = as.numeric(factor(human_pose_data$Category))
summary(human_pose_data)
View(human_pose_data)

#identifying missing values in the dataset

is.na(human_pose_data)
sum(is.na(human_pose_data))   ##  number  of  missing  values  
mean(is.na(human_pose_data))   ##  %  of  missing  values 
na.omit(human_pose_data)    ##  delete incomplete  observations
complete.cases(human_pose_data)
clean_dataset = na.omit(human_pose_data)
View(clean_dataset)

#split into training and validation sets
#Training Set : Validation Set : Testing Set = 60:20:20

set.seed(100)
train <- sample(nrow(clean_dataset), 0.7*nrow(clean_dataset), replace = FALSE)
training_set <- clean_dataset[train,]
validation_testing_set <- clean_dataset[-train,]

summary(training_set)
summary(validation_testing_set)

#split into validation and testing sets

set.seed(100)
validation <- sample(nrow(validation_testing_set), 0.5*nrow(validation_testing_set), replace = FALSE)
validation_set <- validation_testing_set[validation,]
testing_set <- validation_testing_set[-validation,]

summary(validation_set)
summary(testing_set)

#installing "randomforest" package and using them

##install.packages("randomForest")
library("randomForest")

#creating a random forest tree model with default parameters

model_1 <- randomForest(as.factor(Category) ~ ., data = training_set, importance = TRUE)
model_1

#model_2 <- randomForest(as.factor(Category) ~ ., data = training_set, ntree = 500, mtry = 37, importance = TRUE)
#model_2

mtry <- tuneRF(validation_set[-1],validation_set$Category1, ntreeTry=500,
               stepFactor=1.5,improve=0.01, trace=TRUE, plot=TRUE)
best.m <- mtry[mtry[, 2] == min(mtry[, 2]), 1]
mtry
best.m

model_2 <- randomForest(as.factor(Category) ~ ., data = validation_set, ntree = 500, mtry = best.m, importance = TRUE)
model_2

importance(model_2)
varImpPlot(model_2)

#predicting using the validation dataset

validation_prediction <- predict(model_2, validation_set)
table(validation_prediction, validation_set$Category1)

#predicting using the testing dataset

testing_prediction <- predict(model_2, testing_set)
table(testing_prediction, testing_set$Category1)

#predicting values for each row and storing it in the testing dataset

library(dplyr)
library(tidyr)

testing_set <- testing_set %>%
  modelr::add_predictions(model_2)
View(testing_set)
