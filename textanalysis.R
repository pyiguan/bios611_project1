library(tidyverse);
library(quanteda);
library(quanteda.textmodels);
library(caret);
library(pROC);
source("utils.R")

traindf <- read_csv("derived_data/train.csv")
testdf <- read_csv("derived_data/test.csv")

trainMalOrder <- as.factor(traindf$Malicious)

#How much I decided to trim here is a function of my computer RAM more than anything really
#N-gram size is chosen based on previous testing
trainn3_dfm <- model_prep(traindf$Match, 3, trainMalOrder, 20, 20)

set.seed(1612)

svmn3 <- textmodel_svm(trainn3_dfm, trainMalOrder)
n3confusion <- confusionMatrix(data = predict(svmn3), reference = trainMalOrder)

svmn3predictprob <- as.numeric(predict(svmn3, type = "probability")[,2])

svmn3_roc <- roc(response = trainMalOrder, predictor = svmn3predictprob, levels = c("safe", "malicious"))

###### Now using testing data
testMalOrder <- as.factor(testdf$Malicious)


testn3_dfm <- model_prep(testdf$Match, 3, testMalOrder, 20, 20)
testn3confusion <- confusionMatrix(data = predict(svmn3, testn3_dfm), reference = testMalOrder)

testn3confusionplot <- cmplot(testn3confusion)
ggsave("figures/textconfusion.png", testn3confusionplot, width = 9.02, height = 5.72)

svmn3testpredictprob <- as.numeric(predict(svmn3, testn3_dfm, type = "probability")[,2])

svmn3test_roc <- roc(response = testMalOrder, predictor = svmn3testpredictprob, levels = c("safe", "malicious"))
write_rds(svmn3test_roc, "figures/textn3_roc")

# Plot ROC curves of both models
naiive <- read_rds("figures/glm_test_roc")
text <- read_rds("figures/textn3_roc")
roc_curves <- ggroc(list(naiive, text), aes = "colour") + scale_color_discrete(name  ="Model",
                                                                                        labels=c("Naive GLM", "Text SVM")) +
                                                          guides(colour = guide_legend(reverse = TRUE))
ggsave("figures/roc_curves.png", roc_curves, width = 9.02, height = 5.72)

sprintf("## Text Model

### Approach

Classifying a domain as either malicious or safe can be seen as a classic document classification problem in NLP.
Here, each URL would count as a single document. There are many approaches to document classification, but for this particular
application, using character n-grams or \"shingles\" seems to make the most sense. A character n-gram is a sequence of 
n characters from a particular string or piece of text. For example, the 3-grams of the url covid.com would be 
'cov', 'ovi', 'vid', 'id.', 'd.c', '.co', and 'com'. The approach then is to calculate all the n-grams of the URL's
and create what is known as a \"document-term matrix\", where each row of the matrix is a separate document (here a URL)
and each column is one of the possible n-grams. The cells indicate the number of times a particular n-gram occurs within the document.
Document-term matrices are oftentimes sparse matrices (which pose their own set of unique challenges), and in this project they certainly are. 

This approach combined with the size of the data set creates an absurdly large matrix. Fortunately, the quanteda.textmodels
package includes a fast linear support vector machine that works quite well, although at times there were RAM constraints. After many adjustments, an n-gram length
of 3 was chosen along with the default count weighting. There are alternative weighting schemes such as tf-idf that 
divides the proportion of appearances of a particular n-gram in a document by the number of occurrences of that n-gram
within the entire corpus. This is intended to balance out the fact that certain n-grams are just more common than others,
getting a better estimate of the truly important n-grams. Here, tf-idf weighting does not perform as well, probably due to the 
small length of URL's relative to an actual text document.

The confusion matrix for this linear SVM model on the test data is provided below.

![](figures/textconfusion.png)

The performance of this model is much better than the naive glmnet model, as is probably expected! Such a result is encouraging.
Unfortunately, as is the case with character n-grams approaches, it is difficult to really interpret the results in a meaningful fashion.
Nevertheless, this still shows that there is utility in applying NLP techniques to the domain names themselves.

The following are the ROC curves for the two models, plotted side by side.

![](figures/roc_curves.png)
        
        ") %>% write_wrapped(file = "fragments/text_model.Rmd", append = FALSE)
