-- ============================================================
-- PRICING TRENDS  |  Vehicle Price Prediction Project
-- ============================================================

-- 1. Year-over-year average resale price with LAG
WITH yr AS (
    SELECT year, COUNT(*) AS vehicles,
        ROUND(AVG(selling_price),2) AS avg_price,
        ROUND(AVG(driven_kms),0) AS avg_kms
    FROM vehicle_prices GROUP BY year
)
SELECT year, vehicles, avg_price, avg_kms,
    LAG(avg_price) OVER (ORDER BY year)                               AS prev_yr_avg,
    ROUND(avg_price - LAG(avg_price) OVER (ORDER BY year),2)          AS yoy_change,
    ROUND(100.0*(avg_price-LAG(avg_price) OVER (ORDER BY year))
          /NULLIF(LAG(avg_price) OVER (ORDER BY year),0),1)           AS yoy_pct
FROM yr ORDER BY year;

-- 2. Depreciation curve by vehicle age
SELECT (2024-year) AS age_years, COUNT(*) AS vehicles,
    ROUND(AVG(selling_price),2)                                       AS avg_resale,
    ROUND(AVG(present_price),2)                                       AS avg_present,
    ROUND(AVG((present_price-selling_price)/present_price*100),1)     AS avg_dep_pct
FROM vehicle_prices WHERE year<2024
GROUP BY age_years ORDER BY age_years;

-- 3. Rolling 3-year average price trend
WITH yr AS (
    SELECT year, ROUND(AVG(selling_price),2) AS avg_price
    FROM vehicle_prices GROUP BY year
)
SELECT year, avg_price,
    ROUND(AVG(avg_price) OVER (ORDER BY year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_3yr,
    ROUND(avg_price-AVG(avg_price) OVER (),2)                         AS vs_overall_avg
FROM yr ORDER BY year;

-- 4. Price quartile tiers for dealer guidance
SELECT
    NTILE(4) OVER (ORDER BY selling_price)                            AS quartile,
    ROUND(MIN(selling_price),2)                                       AS floor,
    ROUND(MAX(selling_price),2)                                       AS ceiling,
    ROUND(AVG(selling_price),2)                                       AS avg_price,
    COUNT(*)                                                          AS vehicles,
    CASE NTILE(4) OVER (ORDER BY selling_price)
        WHEN 1 THEN 'Budget' WHEN 2 THEN 'Value'
        WHEN 3 THEN 'Mid-Premium' ELSE 'Premium' END                  AS tier
FROM vehicle_prices
GROUP BY quartile ORDER BY quartile;
