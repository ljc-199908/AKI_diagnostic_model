# AKI_diagnostic_model
This repository provides a **simplified version** of the R scripts used to construct and evaluate the 38-gene diagnostic model for air pollution–induced acute kidney injury (AKI), as described in our manuscript:

**“Integrated Multi-Omics and Causal Inference Framework with Experimental Validation Reveals Key Drivers of Air Pollution–Induced Acute Kidney Injury”**

---

## 📌 Contents

- **simplified_model_script.R**: Main R script for running a simplified version of the diagnostic model (Lasso and Random Forest examples).
- **example_data/**: Example training and testing datasets (for demonstration purposes only).
- **results_example/**: Example output, including AUC matrices and heatmaps.

---

## 🔧 Requirements

This script was tested in **R (≥4.2.0)** with the following packages:

```R
install.packages(c("caret", "glmnet", "randomForestSRC", "pROC", "ComplexHeatmap", "RColorBrewer"))
