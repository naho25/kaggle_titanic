## ライブラリ呼び出し（共通）
library(tidyverse)

## データの読み込み
train <- read_csv("input/train.csv")
test <- read_csv("input/test.csv")

## 基礎集計
table(train$Survived)
table(train$Survived, train$Sex)
train %>% 
  sapply(function(y) sum(is.na(y))) %>% View
train %>% 
  sapply(class) %>% View

## 男性は0、女性は1としてルールベースで予測
# MAIN
ans_1 <- test %>% 
  select(PassengerId, Sex) %>% 
  mutate(Survived = ifelse(Sex == "female", 1, 0)) %>% 
  select(PassengerId, Survived) 
# 出力
write_csv(ans_1, "output/ans_1.csv")
  
## 決定木を使用して、性別/年齢/階級で分類
# ライブラリ呼び出し
library(rpart)
library(rpart.plot)
# データ解析
train_rpart <- train %>% 
  rpart(Survived ~ Sex + Age + Pclass, .)
rpart.plot(train_rpart, type = 2, extra = 101)
# MAIN
ans_2 <- predict(train_rpart, test, method = "class")
# 0.5を閾値として予測する
ans_2b <- test %>% 
  select(PassengerId) %>% 
  cbind(ans_2) %>% 
  mutate(Survived = ifelse(ans_2 >= 0.5, 1, 0)) %>% 
  select(PassengerId, Survived)
write_csv(ans_2b, "output/ans_2b.csv")
