# ==============================================================================
# Random Forest vs Regression Tree: Predictive Performance Analysis
# Author: Beatrice Fruni
# Bachelor's Thesis - University of Trento
# ==============================================================================

# 1. Load Libraries
library(pdataita)
library(dplyr)
library(randomForest)
library(rpart)
library(ggplot2)

# 2. Data Preparation
data(bostonhousing)
set.seed(100)

bostonhousing$chas <- factor(bostonhousing$chas, levels = 0:1, labels = c("no", "yes"))
bostonhousing$rad <- factor(bostonhousing$rad, ordered = TRUE)

bostonhousing <- bostonhousing %>%
  select(medv, age, lstat, rm, zn, indus, chas, nox, dis, rad, tax, crim, b, ptratio)

# Train/Test Split (400 train, 106 test)
train_indices <- sample(nrow(bostonhousing), 400)
bh_train <- bostonhousing[train_indices, ]
bh_test  <- bostonhousing[-train_indices, ]

# ==============================================================================
# 3. Benchmark: Single Regression Tree (CART)
# ==============================================================================
tree_model <- rpart(medv ~ ., data = bh_train)
tree_preds <- predict(tree_model, bh_test)
tree_mse   <- mean((bh_test$medv - tree_preds)^2)
cat("CART Regression Tree Test MSE:", round(tree_mse, 2), "\n")

# ==============================================================================
# 4. Hyperparameter Tuning: mtry Optimization (from 1 to 13)
# ==============================================================================
oob_err  <- double(13)
test_err <- double(13)

for (m in 1:13) {
  rf_tune <- randomForest(medv ~ ., data = bh_train, mtry = m, ntree = 400)
  oob_err[m]  <- rf_tune$mse[400]
  pred_test   <- predict(rf_tune, bh_test)
  test_err[m] <- mean((bh_test$medv - pred_test)^2)
}

# ==============================================================================
# 5. Final Optimized Random Forest (mtry = 6, ntree = 500)
# ==============================================================================
set.seed(100)
rf_final <- randomForest(medv ~ ., data = bh_train, mtry = 6, ntree = 500)

# Evaluate on Test Set
data_eval <- bh_train %>%
  mutate(set = "train", fit = predict(rf_final, bh_train)) %>%
  bind_rows(
    bh_test %>% mutate(set = "test", fit = predict(rf_final, bh_test))
  )

rf_mse <- data_eval %>%
  filter(set == "test") %>%
  summarise(mse = mean((fit - medv)^2)) %>%
  pull()

cat("Optimized Random Forest Test MSE:", round(rf_mse, 2), "\n")
cat("MSE Reduction vs Single Tree:", round((1 - (rf_mse / tree_mse)) * 100, 1), "%\n")

# Feature Importance
importance_df <- as.data.frame(importance(rf_final))
importance_df$Variable <- rownames(importance_df)

# Plot Variable Importance
p_importance <- ggplot(importance_df, aes(x = reorder(Variable, IncNodePurity), y = IncNodePurity)) +
  geom_bar(stat = "identity", fill = "#2C3E50") +
  coord_flip() +
  labs(title = "Feature Importance (IncNodePurity)", x = "Predictors", y = "Node Purity Increase") +
  theme_minimal()

print(p_importance)
