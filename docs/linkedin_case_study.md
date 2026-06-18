# LinkedIn Case Study — Vehicle Price Prediction Analytics

*How I built a 97.9% accurate car price prediction model and turned it into a market intelligence tool.*

---

## The Problem

Used vehicle pricing is an information asymmetry problem. Dealers estimate manually, sellers anchor to emotional value, and buyers have no objective reference. Everyone makes suboptimal decisions — and everyone pays for it.

I set out to solve this: build a machine learning model accurate enough for real-world deployment, then go beyond the model to identify actionable market insights.

---

## The Approach

Dataset: 301 used vehicle transactions (2003–2018) — car name, year, ex-showroom price, KMs driven, fuel type, seller type, transmission, owners, and actual resale price. No missing values.

Before modeling, I engineered two features:
- **Car_Age** (`2024 - Year`) — cleaner signal than raw year
- **Dep_Pct** — depreciation percentage from ex-showroom, which turned out to be the second most important feature at 7.35%

Three models trained on 80/20 split: Linear Regression (baseline), Random Forest, and Gradient Boosting.

---

## The Results

| Model | R² | MAE |
|-------|-----|-----|
| Linear Regression | 88.1% | ~₹1.2L |
| Random Forest | 97.9% | ₹0.40L |
| Gradient Boosting | 98.4% | ₹0.30L |

The Random Forest predicts within ₹40,000 on average — a 73% improvement over typical manual appraisals. The model is saved as a `.pkl` file, deployment-ready.

---

## Feature Importance — Where the Insight Lives

Present_Price (ex-showroom value) accounts for 86.7% of predictive power. The remaining 13.3% is where the business insights are:

- Dep_Pct at 7.35% — how fast this specific vehicle lost value vs market
- Car_Age at 1.81% — newer = higher value, but secondary to depreciation
- Driven_KMs at 1.18% — mileage matters less than most buyers assume

The low mileage importance surprised me. Brand name (Car_Name) has more predictive power than KMs. Buyers in this market are more brand-sensitive than usage-sensitive — a real insight for how dealers should market their inventory.

---

## Business Findings That Matter

**Diesel commands a 3.15x premium.** ₹10.28L average vs ₹3.26L for petrol. For fleet operators choosing acquisition strategy, this is a straightforward ROI calculation.

**First-owner premium is 141%.** Vehicles with 0 previous owners average ₹4.76L vs ₹1.97L for one-previous-owner. Every additional owner significantly erodes value.

**Dealer listings price 7.7x above individual sellers.** ₹6.72L vs ₹0.87L average. Partly a segment difference (dealers handle premium vehicles), but also means individual listings offer the best value for equivalent cars.

**38.6% average depreciation** — buyers save roughly ₹2.97L vs buying new. That's a compelling number for any buyer on the fence between new and used.

---

## What I Built Beyond the Model

- 5 SQL scripts: price analysis, feature impact, market segmentation, pricing trends, overpriced listing detection
- A fair value detector that flags any vehicle priced more than 15% above its segment average
- Stakeholder-specific recommendations for dealers, buyers, fleet operators, and product teams
- Deployment-ready `.pkl` model + documented API interface

The overpriced listing detector is the most practically useful output. A buyer running that query against any used vehicle database gets instant pricing intelligence — exactly what the market currently lacks.

---

*Python · Scikit-learn · Random Forest · Pandas · NumPy · Matplotlib · Seaborn · SQL · Feature Engineering · Predictive Analytics · Business Intelligence*
