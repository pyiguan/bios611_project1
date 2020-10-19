library(tidyverse);
library(glmnet);
library(pROC);
library(glmnetUtils);
library(caret);
source("utils.R");

traindf <- read_csv("derived_data/train.csv")
testdf <- read_csv("derived_data/test.csv")

traindf_enriched <- add_parameters(traindf, traindf$Match, traindf$Malicious)

summarystat <- traindf_enriched %>% group_by(Malicious) %>% summarize(MeanLength = mean(Length), 
                                                  MeanHyphen = mean(hyphen),
                                                  MeanDigits = mean(number))

set.seed(1612)
#Setting up for repeated 10-fold cross-validation
glmnet_enriched <- cv.glmnet(Malicious ~ Length + hyphen + number, data = traindf_enriched, 
                             family = 'binomial', alpha = 0)

glmnetpredict <- as.factor(predict(glmnet_enriched, traindf_enriched, s = "lambda.min", type = "class"))
glmnetpredictprob <- as.numeric(predict(glmnet_enriched, traindf_enriched, s = "lambda.min"))

#Useful metrics such as sensitivity/specificity
trainconfusion <- confusionMatrix(data = glmnetpredict, reference = traindf_enriched$Malicious)
print(trainconfusion)

glm_train_roc <- roc(response = traindf_enriched$Malicious, predictor = glmnetpredictprob, levels = c("safe", "malicious"))

#Use testing data now

testdf_enriched <- add_parameters(testdf, testdf$Match, testdf$Malicious)

testpredict <- as.factor(predict(glmnet_enriched, testdf_enriched, s = "lambda.min", type = "class"))

testconfusion <- confusionMatrix(data = testpredict, reference = testdf_enriched$Malicious)

glmnettestpredictprob <- as.numeric(predict(glmnet_enriched, testdf_enriched, s = "lambda.min"))

glm_test_roc <- roc(response = testdf_enriched$Malicious, predictor = glmnettestpredictprob, levels = c("safe", "malicious"))

#For use to create a combined ROC curve plot later
write_rds(glm_test_roc, "figures/glm_test_roc")

testconfusionMatrix <- cmplot(testconfusion)

ggsave("figures/naiveconfusion.png", testconfusionMatrix, width = 9.02, height = 5.72)

sprintf("## A Naive Model

Given our list of domains, what features can we derive from them? Based on a preliminary inspection of the domains,
as well as by previous work on phishing websites, we have chosen to include the length of the URL, the number of hyphens,
and the number of digits. As the following table demonstrates, there may be a difference in the distribution of these
features between malicious and safe websites.

```{r echo = FALSE, warning = FALSE, message = FALSE, results = 'asis'}

library(knitr)

library(tidyverse)

source(\"../utils.R\")

traindf <- read_csv(\"../derived_data/train.csv\")

traindf_enriched <- add_parameters(traindf, traindf$Match, traindf$Malicious)

summarystat <- traindf_enriched %%>%% group_by(Malicious) %%>%% summarize(MeanLength = mean(Length), 
                                                  MeanHyphen = mean(hyphen),
                                                  MeanDigits = mean(number))

kable(summarystat)

```

In order to classify a particular domain as malicious or safe, we fit a LASSO regularized logistic regression model.
The following is a confusion matrix for the model on the test data. 

![](figures/naiveconfusion.png)

The performance is better than simply labeling every website as malicious, but it does a leave a bit to be desired.
This, however, is not too surprising. After all, the features that we chose do strip out a lot of information about
the URLs themselves! For example, ---999fjfjllllllllllll.com and get-covid19-virus-h3re.com have the exact same length, number of hyphens, and number of digits, but most people would say that the two are
quite different. A more reasonable model then would probably analyze the strings themselves.") %>% 
write_wrapped(file = "fragments/naive_model.Rmd", append = FALSE)
