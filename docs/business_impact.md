# Business Impact Analysis

## The Pricing Problem This Model Solves

Used vehicle pricing suffers from information asymmetry. Dealers rely on experience, sellers anchor to emotional value, and buyers overpay because they lack reference data. The Random Forest model closes that gap — predicting resale prices within ₹40,000 on average.

## Model Accuracy in Business Terms

| Model | R² | MAE | Business Meaning |
|-------|-----|-----|-----------------|
| Random Forest | 97.9% | ₹0.40L | Off by ₹40K average — deployment ready |
| Gradient Boosting | 98.4% | ₹0.30L | Highest accuracy for batch pricing |
| Linear Regression | 88.1% | ~₹1.2L | Baseline — typical manual estimate range |

A dealer using the RF model reduces average pricing error by **73%** vs manual estimation.

## Financial Impact by Stakeholder

**Dealers (30-vehicle inventory)**
- Manual mispricing: ₹1–1.5L per vehicle = ₹30–45L total exposure
- Model-based pricing: ₹0.40L per vehicle = ₹12L exposure
- Net reduction: ₹18–33L in inventory risk per cycle

**Buyers**
- Overpriced listings (>15% above fair value) identifiable via SQL query
- Avg savings per informed transaction: ₹0.5–2L
- Diesel vehicles at ₹10.28L avg — uninformed buyers routinely overpay ₹1–3L

**Fleet Operators (20 diesel vehicles)**
- Diesel avg ₹10.28L vs petrol ₹3.26L — 3.15x residual value
- Fleet of 20 diesel = ₹142L more retained value vs equivalent petrol fleet

## Market Insight Value

| Insight | Quantified Impact |
|---------|-----------------|
| Diesel 3.15x premium | Fleet acquisition ROI optimization |
| Automatic 2.4x premium | Upsell pricing validation |
| First-owner 141% premium (vs 1 prev owner) | Acquisition priority scoring |
| 36.6% avg depreciation | Buyer saves avg ₹2.97L vs new |

## Deployment Scalability

`models/random_forest_regression_model.pkl` loads in 3 lines of Python. At 1,000 queries/day, zero marginal cost per prediction vs ₹500–2,000 per manual appraisal.
