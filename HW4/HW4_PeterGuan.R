library(tidyverse)
library(gbm)
library(MLmetrics)
library(ROCit)
library(factoextra)
library(cluster)

df <- read_csv("../HW4/500_Person_Gender_Height_Weight_Index.csv") %>%
  mutate(gender_binary = if_else(Gender == "Male", 1, 0))

glmmodel <- glm(gender_binary ~ Height + Weight, family=binomial(link='logit'),
             data = df)

df$glmmodel_prob <- predict(glmmodel, df, type = "response")
df <- df %>% mutate(glmmodel_pred = if_else(glmmodel_prob > 0.5, 1, 0)) %>% 
  mutate(glmaccurate = 1*(glmmodel_pred == gender_binary))


glmaccuracy <- sum(df$glmaccurate / nrow(df))




gbmmodel <- gbm(gender_binary ~ Height + Weight, data = df)

df$gbm_prob <- predict(gbmmodel, df, type = "response")

df <- df %>% mutate(gbmmodel_pred = if_else(gbm_prob > 0.5, 1, 0)) %>% 
  mutate(gbmaccurate = 1*(gbmmodel_pred == gender_binary))

gbmaccuracy <- sum(df$gbmaccurate / nrow(df))

fiftysamp <- df %>% group_by(gender_binary) %>% slice_sample(n = 50) %>% filter(gender_binary == 1)

fiftyglm <- glm(gender_binary ~ Height + Weight, family=binomial(link='logit'),
                data = df)
fiftyglmpred <- if_else(fiftyglm$fitted.values < 0.5, 0, 1)

fiftyglmf1 <- F1_Score(y_pred = fiftyglmpred, y_true = df$gender_binary) 

fiftyROC <- rocit(score = fiftyglmpred, class = df$gender_binary)

plot(fiftyROC)


clusterprep <- df %>% select(Height, Weight)

results <- clusGap(clusterprep, kmeans, K.max = 10, B = 200);

ggplot(results$Tab %>% as_tibble() %>% mutate(k=seq(nrow(.))), aes(k,gap)) + geom_line();

cc <- kmeans(clusterprep, 4, nstart = 25)
fviz_cluster(cc, data = clusterprep, geom = "point")
table(df$Index)
cc$centers


