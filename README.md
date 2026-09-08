# Comparative Study of Random Forest and CART Models in R

[![Language](https://img.shields.io/badge/Language-R-blue.svg)](https://www.r-project.org/)
[![Model](https://img.shields.io/badge/Algorithms-Random_Forest_|_CART-orange.svg)]()
[![Domain](https://img.shields.io/badge/Focus-Predictive_Analytics_|_Consumer_Behavior-green.svg)]()

Empirical implementation, mathematical review, and performance comparison between **Ensemble Learning (Random Forest)** and individual **Classification and Regression Trees (CART)**, evaluated on the *Boston Housing* benchmark dataset and applied to digital marketing behavioral prediction.

> **Academic Origin:** Based on Bachelor's Thesis defended at the University of Trento (B.Sc. in Economics & Management).

---

## 📌 Executive Summary

Individual decision trees (CART) often suffer from high variance and risk of overfitting when applied to complex data structures. Leo Breiman’s **Random Forest** overcomes these limitations by combining:
1. **Bootstrap Aggregating (Bagging):** Resampling with replacement to generate decorrelated base learners.
2. **Random Subspace Selection:** Restricting node splits to a random subset of $m$ features ($m \approx \sqrt{p}$ or tuned via OOB error minimization) to reduce tree correlation.

This project empirically demonstrates how ensembling reduces generalization error and compares predictive accuracy against baseline decision tree architectures.

---

## 📊 Key Results: RF vs. Single Tree

| Metric | Single Regression Tree (CART) | Baseline Random Forest (mtry=4) | Optimized Random Forest (mtry=6) |
| :--- | :---: | :---: | :---: |
| **Number of Trees** | 1 | 500 | 500 |
| **% Variance Explained** | - | 87.27% | **87.64%** |
| **Mean Squared Error (MSE)** | **40.43** | 16.42 | **16.25** |
| **Performance Gain** | Baseline | -59.4% error | **-59.8% error** |

*The optimized Random Forest achieved a **~60% reduction in Mean Squared Error** over the individual decision tree, confirming the theoretical power of variance reduction through ensembling.*

---

## 🔍 Hyperparameter Optimization: $mtry$ Tuning

By iterating across all possible predictor subsets ($mtry \in [1, 13]$) over 400 trees, Out-Of-Bag (OOB) and Test MSE were tracked:
- **OOB Error** decreased sharply and stabilized at $mtry = 5$.
- **Test Error** reached its global minimum at $mtry = 6$ ($MSE = 15.60 - 16.25$).
- Setting $mtry = 6$ yielded the optimal balance between tree diversity and individual tree strength.

### Feature Importance Drivers
Using the `IncNodePurity` (decrease in node impurity / Residual Sum of Squares) metric:
1. **`lstat`** (% lower status population): Most impactful predictor of housing value.
2. **`rm`** (average rooms per dwelling): Second strongest driver.
3. **`crim`** & **`dis`**: Secondary macroeconomic predictors.

---

## 📈 Industry Application: Digital Marketing & Big Data

The project explores the transition of Random Forest algorithms to **sustainable digital marketing and consumer behavioral prediction**:
- **Dataset Scale:** Evaluated 50,000+ consumer records tracking e-commerce interactions (cart engagement, browsing duration, visit frequency).
- **Predictive Target:** Forecasting 7-day purchase probability.
- **Outcome:** The Random Forest ensemble correctly identified high-intent purchasers, outperforming standard Logistic Regression baselines and proving its capacity to segment audiences and optimize advertising budgets.

---

## 🛠️ Tech Stack
- **R Libraries:** `randomForest`, `rpart`, `dplyr`, `ggplot2`, `pdataita`
- **Methodologies:** Cross-validation, OOB error diagnostics, Bagging, Node purity evaluation.

---

## 📂 Repository Structure
```text
├── random_forest_analysis.R    # End-to-end reproducible R script
├── README.md                  # Project documentation & benchmark analysis
└── (optional) figures/        # Diagnostic and error plots
