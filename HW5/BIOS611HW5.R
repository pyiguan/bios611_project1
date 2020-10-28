library(tidyverse)
library(gbm)
library(ggfortify)
library(caret)

##Q1
set.seed(1612)
df <- read_csv("datasets_26073_33239_weight-height.csv") %>%
  mutate(gender_binary = if_else(Gender == "Male", 1, 0))

gbmmodel <- gbm(gender_binary ~ Height + Weight, data = df)

df$gbm_prob <- predict(gbmmodel, df, type = "response")

df <- df %>% mutate(gbmmodel_pred = if_else(gbm_prob > 0.5, 1, 0)) %>% 
  mutate(gbmaccurate = 1*(gbmmodel_pred == gender_binary))

gbmaccuracy <- sum(df$gbmaccurate / nrow(df)) # new accuracy is 0.9165, much better

##Q2
chars <- read_csv("datasets_38396_60978_charcters_stats.csv")
view(chars)

##seem to be a lot of rows with 1's in all stats except power

chars_fixed <- chars %>% filter(!(Total == 5))

pcs <- prcomp(chars_fixed %>% select(-Name, -Alignment))
summary(pcs) ## Only need 1 component to capture 0.8635 percent of the variance

## I think should normalize, especially Total

scalepcs <- prcomp(chars_fixed %>% select(-Name, -Alignment), scale = TRUE)
summary(scalepcs) ## Now need first 4 principal components for at least 85% variance captured


chars_fixed <- chars_fixed %>% mutate(Sum = Intelligence + Strength + Speed + Durability + Power + Combat)
all.equal(chars_fixed$Total, chars_fixed$Sum) ##True, so seems good?

##Q5 probably should not have included, total is already a combination of the other variables, most of the variability
## in the dataset probably gets absorbed into Total

autoplot(scalepcs, x = 1, y = 2)
autoplot(pcs, x = 1, y = 2)
##IDK hard to tell what's going on 

tc <- trainControl(method = "repeatedcv", number = 10, repeats = 10)

chars_nonmiss <- chars_fixed %>% drop_na()

gbmcaret <- train(Alignment ~ Intelligence + Strength + Speed + Durability + Power + Combat, data = chars_nonmiss,
                  method = "gbm", trControl = tc, verbose = FALSE)

## The final values used for the model were n.trees = 50, interaction.depth = 1, shrinkage = 0.1 and n.minobsinnode = 10.

write_csv(chars_fixed %>% select(-Name, -Alignment, -Sum), "HW5/charpowersnumerical.csv")


tsne <- read.table("tsne.txt")
tsne$V3 <- as.factor(chars_fixed$Alignment)

write_csv(tsne, "tsnealign.csv")
plotted_tsne <- ggplot(tsne) + geom_point(aes(x = V1, y = V2, color = V3))
ggsave("r_tsne.png", plotted_tsne)
