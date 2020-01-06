## ライブラリの呼び出し

library(tidyverse)

## データの読み込み

train <- read_csv("input/train.csv")
test <- read_csv("input/test.csv")

## 基礎集計

table(train$Survived)
table(train$Survived, train$Sex)

## 男性は0、女性は1としてルールベースで予測

ans_1 <- test %>% 
  select(PassengerId, Sex) %>% 
  mutate(Survived = ifelse(Sex == "female", 1, 0)) %>% 
  select(-Sex) 
write_csv(ans_1, "output/ans_1.csv")
  