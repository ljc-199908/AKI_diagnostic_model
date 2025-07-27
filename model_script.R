### ===============================================================
### Simplified version of 38-gene diagnostic model construction
### ===============================================================

# Load required packages
library(glmnet)
library(randomForestSRC)
library(caret)
library(pROC)
library(ComplexHeatmap)
library(RColorBrewer)

# -----------------------------
# Load example data
# -----------------------------
Train_data <- read.table("example_data/data.train.txt", header = TRUE, sep = "\t", row.names = 1)
Test_data  <- read.table("example_data/data.test.txt", header = TRUE, sep = "\t", row.names = 1)

Train_expr <- as.matrix(Train_data[, -ncol(Train_data)])
Train_class <- Train_data[, ncol(Train_data), drop = FALSE]

Test_expr <- as.matrix(Test_data[, -ncol(Test_data)])
Test_class <- Test_data[, ncol(Test_data), drop = FALSE]
Test_class$Cohort <- "Test"

# -----------------------------
# Run Lasso (as an example)
# -----------------------------
cv.fit <- cv.glmnet(Train_expr, Train_class$Type, family = "binomial", alpha = 1)
lasso_model <- glmnet(Train_expr, Train_class$Type, family = "binomial", alpha = 1, lambda = cv.fit$lambda.min)

# Predict and calculate AUC
pred <- predict(lasso_model, newx = Test_expr, type = "response")
auc_lasso <- auc(roc(Test_class$Type, as.numeric(pred)))
cat("Lasso AUC:", auc_lasso, "\n")

# -----------------------------
# Run Random Forest (as an example)
# -----------------------------
rf_model <- rfsrc(Type ~ ., data = cbind(Type = as.factor(Train_class$Type), Train_expr))
rf_pred <- predict(rf_model, newdata = as.data.frame(Test_expr))$predicted[, "1"]
auc_rf <- auc(roc(Test_class$Type, rf_pred))
cat("Random Forest AUC:", auc_rf, "\n")

# -----------------------------
# Heatmap of AUCs (Lasso vs RF)
# -----------------------------
AUC_mat <- matrix(c(auc_lasso, auc_rf), ncol = 1)
rownames(AUC_mat) <- c("Lasso", "RandomForest")
colnames(AUC_mat) <- "Test"
avg_AUC <- apply(AUC_mat, 1, mean)

CohortCol <- brewer.pal(n = ncol(AUC_mat), name = "Paired")
names(CohortCol) <- colnames(AUC_mat)

hm <- Heatmap(AUC_mat, name = "AUC", row_title = "Model",
              right_annotation = rowAnnotation(bar = anno_barplot(avg_AUC)))

pdf("results_example/model.AUCheatmap.pdf", width = 5, height = 3)
draw(hm)
dev.off()

cat("Example run completed. Check results_example/ for outputs.\n")

# -----------------------------
# Additional advanced algorithms are available upon request
# -----------------------------
