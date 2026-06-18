# Data Dictionary — Vehicle Price Dataset

**File:** `data/old_car_data.csv` · **Records:** 301 · **Columns:** 9 raw + 2 engineered · **Target:** `Selling_Price` (₹ Lakh)

---

## Columns

| Column | Type | Range / Values | Description |
|--------|------|----------------|-------------|
| Car_Name | String | 30+ models | Vehicle model (lowercase) |
| Year | Integer | 2003–2018 | Year of manufacture |
| Present_Price | Float | ₹0.32L–₹92.6L | Current ex-showroom price (new vehicle value) |
| Driven_kms | Integer | 500–500,000 | Total KMs driven |
| Fuel_Type | Categorical | Petrol, Diesel, CNG | Fuel type |
| Selling_type | Categorical | Dealer, Individual | Who is selling |
| Transmission | Categorical | Manual, Automatic | Gearbox type |
| Owner | Integer | 0, 1, 3 | Previous owners (0 = first owner) |
| **Selling_Price** | **Float** | **₹0.1L–₹35L** | **Target: actual resale price** |

## Engineered Features

| Feature | Formula | Purpose |
|---------|---------|---------|
| Car_Age | `2024 - Year` | Age in years — cleaner signal than raw year |
| Dep_Pct | `(Present_Price - Selling_Price) / Present_Price × 100` | Value erosion % — 7.35% feature importance |

## Summary Statistics

| Metric | Value |
|--------|-------|
| Total records | 301 |
| Price range | ₹0.10L – ₹35.00L |
| Avg resale price | ₹4.66L |
| Avg present price | ₹7.63L |
| Avg depreciation | 36.6% |
| Petrol | 239 (79.4%) |
| Diesel | 60 (19.9%) |
| Manual transmission | 261 (86.7%) |
| Dealer listings | 195 (64.8%) |
| First-owner vehicles | 290 (96.3%) |

**No missing values.** Columns `Year` replaced by `Car_Age` in modeling to avoid data leakage.
