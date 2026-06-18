-- ============================================================
-- FEATURE ANALYSIS  |  Vehicle Price Prediction Project
-- ============================================================

-- 1. Price segment breakdown using CASE WHEN
WITH segs AS (
    SELECT *,
        CASE WHEN present_price<5  THEN 'Economy (<5L)'
             WHEN present_price<10 THEN 'Mid-Range (5-10L)'
             WHEN present_price<20 THEN 'Premium (10-20L)'
             ELSE 'Luxury (20L+)' END AS segment
    FROM vehicle_prices
)
SELECT segment, COUNT(*) AS vehicles,
    ROUND(AVG(present_price),2)                                       AS avg_ex_showroom,
    ROUND(AVG(selling_price),2)                                       AS avg_resale,
    ROUND(AVG((present_price-selling_price)/present_price*100),1)     AS avg_depreciation_pct,
    DENSE_RANK() OVER (ORDER BY AVG(selling_price) DESC)              AS rank
FROM segs GROUP BY segment ORDER BY avg_ex_showroom;

-- 2. Driven KMs impact on price
SELECT
    CASE WHEN driven_kms<20000  THEN '<20K KMs'
         WHEN driven_kms<50000  THEN '20K-50K KMs'
         WHEN driven_kms<100000 THEN '50K-100K KMs'
         ELSE '100K+ KMs' END                                         AS mileage_band,
    COUNT(*) AS vehicles,
    ROUND(AVG(selling_price),2)                                       AS avg_price,
    ROUND(AVG(present_price-selling_price),2)                         AS avg_value_loss
FROM vehicle_prices
GROUP BY mileage_band ORDER BY avg_price DESC;

-- 3. Multi-factor: fuel + transmission + seller combo
SELECT fuel_type, transmission, selling_type,
    COUNT(*) AS vehicles,
    ROUND(AVG(selling_price),2)                                       AS avg_price,
    RANK() OVER (ORDER BY AVG(selling_price) DESC)                    AS combo_rank
FROM vehicle_prices
GROUP BY fuel_type, transmission, selling_type
HAVING COUNT(*)>=3
ORDER BY avg_price DESC LIMIT 15;

-- 4. Depreciation by fuel type and age
WITH aged AS (
    SELECT *, (2024-year) AS car_age,
        ROUND((present_price-selling_price)/present_price*100,1) AS dep_pct
    FROM vehicle_prices
)
SELECT fuel_type,
    CASE WHEN car_age<=5 THEN '1-5 Yrs' WHEN car_age<=10 THEN '6-10 Yrs' ELSE '10+ Yrs' END AS age_grp,
    COUNT(*) AS vehicles,
    ROUND(AVG(dep_pct),1) AS avg_dep_pct,
    ROUND(AVG(selling_price),2) AS avg_price
FROM aged GROUP BY fuel_type, age_grp ORDER BY fuel_type, avg_dep_pct;

-- 5. Value efficiency: price per 10K KMs
SELECT car_name, fuel_type, transmission,
    ROUND(AVG(selling_price),2)                                       AS avg_price,
    ROUND(AVG(driven_kms),0)                                          AS avg_kms,
    ROUND(AVG(selling_price)/NULLIF(AVG(driven_kms),0)*10000,4)       AS price_per_10k_kms,
    NTILE(4) OVER (ORDER BY AVG(selling_price)/NULLIF(AVG(driven_kms),0) DESC) AS value_quartile
FROM vehicle_prices
GROUP BY car_name, fuel_type, transmission
HAVING COUNT(*)>=2
ORDER BY price_per_10k_kms DESC LIMIT 20;
