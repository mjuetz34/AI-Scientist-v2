
# Enhanced CD44/HNSCC Analysis with AI Features
# Adapted from original research with machine learning enhancements

library(survival)
library(ggplot2)
library(dplyr)
library(survminer)
library(randomForest)
library(pROC)

# Load data
daten <- read.csv("medical_data/dissertation_data_for_r.csv")

print(paste("Loaded", nrow(daten), "patients for analysis"))

# =============================================================================
# 1. TRADITIONAL SURVIVAL ANALYSIS (Original Research)
# =============================================================================

print("=== TRADITIONAL SURVIVAL ANALYSIS ===")

# Kaplan-Meier survival curves
fit_loko <- survfit(Surv(Zeit, LokoRegionaleKontrolle) ~ CD44_Expression + HPV16_DNA_Status, data=daten)
fit_fern <- survfit(Surv(Zeit, FernMetastasenFrei) ~ CD44_Expression + HPV16_DNA_Status, data=daten)
fit_gesamt <- survfit(Surv(Zeit, GesamtUeberleben) ~ CD44_Expression + HPV16_DNA_Status, data=daten)

# Plot survival curves
pdf("results/cd44_analysis/kaplan_meier_curves.pdf", width=12, height=8)
par(mfrow=c(2,2))

ggsurvplot(fit_loko, 
           title = "Lokoregionale Kontrolle nach CD44/HPV Status",
           xlab = "Zeit (Monate)",
           ylab = "Überlebenswahrscheinlichkeit",
           pval = TRUE,
           conf.int = TRUE)

ggsurvplot(fit_fern,
           title = "Fernmetastasenfreies Überleben",
           xlab = "Zeit (Monate)", 
           ylab = "Überlebenswahrscheinlichkeit",
           pval = TRUE,
           conf.int = TRUE)

ggsurvplot(fit_gesamt,
           title = "Gesamtüberleben",
           xlab = "Zeit (Monate)",
           ylab = "Überlebenswahrscheinlichkeit", 
           pval = TRUE,
           conf.int = TRUE)

dev.off()

# Cox proportional hazards models
cox_loco <- coxph(Surv(Zeit, LokoRegionaleKontrolle) ~ CD44_Expression + HPV16_DNA_Status + Alter + Geschlecht + TumorStadium, data=daten)
cox_fern <- coxph(Surv(Zeit, FernMetastasenFrei) ~ CD44_Expression + HPV16_DNA_Status + Alter + Geschlecht + TumorStadium, data=daten)
cox_gesamt <- coxph(Surv(Zeit, GesamtUeberleben) ~ CD44_Expression + HPV16_DNA_Status + Alter + Geschlecht + TumorStadium, data=daten)

print("Cox Regression Results:")
print("Lokoregionale Kontrolle:")
print(summary(cox_loco))

print("Fernmetastasenfreies Überleben:")
print(summary(cox_fern))

print("Gesamtüberleben:")
print(summary(cox_gesamt))

# =============================================================================
# 2. AI-ENHANCED MACHINE LEARNING ANALYSIS
# =============================================================================

print("=== AI-ENHANCED ANALYSIS ===")

# Prepare data for machine learning
ml_data <- daten %>%
  select(CD44_Expression, HPV16_DNA_Status, Alter, Geschlecht, TumorStadium, 
         LokoRegionaleKontrolle, Zeit) %>%
  na.omit()

# Random Forest for outcome prediction
set.seed(42)
rf_model <- randomForest(as.factor(LokoRegionaleKontrolle) ~ CD44_Expression + HPV16_DNA_Status + Alter + Geschlecht + TumorStadium,
                        data = ml_data,
                        ntree = 1000,
                        importance = TRUE)

print("Random Forest Model Performance:")
print(rf_model)

# Feature importance
importance_df <- data.frame(
  Variable = rownames(importance(rf_model)),
  Importance = importance(rf_model)[,1]
)
importance_df <- importance_df[order(importance_df$Importance, decreasing = TRUE),]

print("Feature Importance:")
print(importance_df)

# ROC curve analysis
ml_data$rf_pred <- predict(rf_model, type="prob")[,2]
roc_curve <- roc(ml_data$LokoRegionaleKontrolle, ml_data$rf_pred)

pdf("results/cd44_analysis/ai_analysis_results.pdf", width=12, height=8)
par(mfrow=c(2,2))

# Plot feature importance
barplot(importance_df$Importance, 
        names.arg = importance_df$Variable,
        main = "Feature Importance (Random Forest)",
        xlab = "Variables",
        ylab = "Importance",
        las = 2)

# ROC curve
plot(roc_curve, 
     main = paste("ROC Curve (AUC =", round(auc(roc_curve), 3), ")"),
     col = "blue",
     lwd = 2)

# CD44 effect stratified by HPV status
cd44_hpv_table <- table(daten$CD44_Expression, daten$HPV16_DNA_Status, daten$LokoRegionaleKontrolle)
print("CD44 x HPV x Outcome Crosstab:")
print(cd44_hpv_table)

dev.off()

# =============================================================================
# 3. SUBGROUP ANALYSIS (HPV-STRATIFIED)
# =============================================================================

print("=== HPV-STRATIFIED SUBGROUP ANALYSIS ===")

# HPV-negative subgroup (your main finding)
hpv_neg <- subset(daten, HPV16_DNA_Status == 0)
fit_hpv_neg <- survfit(Surv(Zeit, LokoRegionaleKontrolle) ~ CD44_Expression, data=hpv_neg)

# HPV-positive subgroup  
hpv_pos <- subset(daten, HPV16_DNA_Status == 1)
fit_hpv_pos <- survfit(Surv(Zeit, LokoRegionaleKontrolle) ~ CD44_Expression, data=hpv_pos)

pdf("results/cd44_analysis/hpv_stratified_analysis.pdf", width=10, height=6)
par(mfrow=c(1,2))

ggsurvplot(fit_hpv_neg,
           title = "HPV-negative: CD44 Effect on LRC",
           xlab = "Zeit (Monate)",
           ylab = "Lokoregionale Kontrolle",
           pval = TRUE)

ggsurvplot(fit_hpv_pos, 
           title = "HPV-positive: CD44 Effect on LRC",
           xlab = "Zeit (Monate)",
           ylab = "Lokoregionale Kontrolle", 
           pval = TRUE)

dev.off()

# Statistical tests for subgroups
survdiff_hpv_neg <- survdiff(Surv(Zeit, LokoRegionaleKontrolle) ~ CD44_Expression, data=hpv_neg)
survdiff_hpv_pos <- survdiff(Surv(Zeit, LokoRegionaleKontrolle) ~ CD44_Expression, data=hpv_pos)

print("Log-rank test results:")
print("HPV-negative subgroup:")
print(survdiff_hpv_neg)
print("HPV-positive subgroup:")
print(survdiff_hpv_pos)

# =============================================================================
# 4. RESULTS SUMMARY
# =============================================================================

results_summary <- list(
  total_patients = nrow(daten),
  cd44_positive_rate = mean(daten$CD44_Expression),
  hpv_positive_rate = mean(daten$HPV16_DNA_Status),
  overall_recurrence_rate = mean(daten$LokoRegionaleKontrolle),
  cox_cd44_hr = exp(coef(cox_loco)["CD44_Expression"]),
  cox_hpv_hr = exp(coef(cox_loco)["HPV16_DNA_Status"]),
  rf_auc = auc(roc_curve),
  median_followup = median(daten$Zeit)
)

print("=== FINAL RESULTS SUMMARY ===")
print(results_summary)

# Save results
write.csv(importance_df, "results/cd44_analysis/feature_importance.csv", row.names=FALSE)
write.csv(daten, "results/cd44_analysis/processed_data.csv", row.names=FALSE)

print("Analysis completed successfully!")
print("Results saved in: results/cd44_analysis/")
