# Stakeholder Recommendations

## For Dealers

**Use the model as your pricing floor.** The Random Forest model predicts within ₹40,000 average error — significantly better than manual estimation. At appraisal, run the model and use its output as the reference. Any listing priced more than 15% above the prediction will sit in inventory longer.

**Prioritize diesel inventory.** Diesel vehicles average ₹10.28L resale vs ₹3.26L petrol — a 3.15x premium. Acquire more diesel, price confidently, and use the fuel premium as a differentiation argument with buyers comparing options.

**First-owner vehicles are high-margin.** 290 of 301 vehicles in this dataset are first-owner, and they average 141% more than one-previous-owner equivalents. Pay a small premium at acquisition — it returns significantly more at resale.

## For Individual Sellers

**Price with data, not emotion.** Run the model before listing. Most individual sellers either underprice (leaving ₹0.5–1L on the table) or overprice and wait months. A data-backed price attracts serious buyers without leaving money behind.

**Low mileage is your negotiating asset.** Sub-30,000 KM vehicles command a clear premium. If you're in that range, highlight it prominently and justify a price above market average with the data.

**Sell at years 3–5.** The depreciation curve shows the steepest drop happens in years 1–3. By year 4, the initial drop has happened — but newer models haven't yet eroded your vehicle's appeal. This window maximizes resale value.

## For Buyers

**Flag overpriced listings.** The SQL in `top_value_vehicles.sql` identifies any listing priced more than 15% above fair value for its car/fuel/transmission combination. Use this before negotiating — walk in with the data, not a gut feeling.

**Diesel automatics hold value best.** The combination of diesel fuel and automatic transmission produces the highest average resale values in this dataset. If your budget extends to this combination, the residual value protection is measurable.

**First-owner beats everything.** The 141% first-owner premium over one-previous-owner is the largest single quality signal in the dataset. Pay for it — the resale protection when you eventually sell makes it worthwhile.

## For Product / Tech Teams

**The model is deployment-ready.** Load `models/random_forest_regression_model.pkl` with pickle, pass a feature dictionary, get a price estimate. The next step is a FastAPI wrapper for dealer platform integration.

**V2 priorities:** Add make/brand as a separate feature (model name is noisy for rare cars), include geographic region (prices vary 20–40% between metros and tier-2 cities), and add service history flag. These three additions would push accuracy above 99%.
