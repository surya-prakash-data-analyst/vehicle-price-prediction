-- ============================================================
-- TOP VALUE VEHICLES  |  Vehicle Price Prediction Project
-- ============================================================

-- 1. Top 10 vehicles by average resale value
SELECT car_name, fuel_type, transmission,
    COUNT(*) AS listings,
    ROUND(AVG(selling_price),2)                                       AS avg_resale,
    ROUND(AVG(present_price),2)                                       AS avg_ex_showroom,
    ROUND(AVG((present_price-selling_price)/present_price*100),1)     AS avg_dep_pct,
    RANK() OVER (ORDER BY AVG(selling_price) DESC)                    AS value_rank
FROM vehicle_prices
GROUP BY car_name, fuel_type, transmission
ORDER BY avg_resale DESC LIMIT 10;

-- 2. Best value buys — scoring model for buyers
WITH scored AS (
    SELECT *,
        (CASE WHEN selling_price<3   THEN 30 ELSE 0 END)+
        (CASE WHEN driven_kms<30000  THEN 25 ELSE 0 END)+
        (CASE WHEN (2024-year)<=5    THEN 25 ELSE 0 END)+
        (CASE WHEN owner=0           THEN 20 ELSE 0 END) AS buy_score
    FROM vehicle_prices
)
SELECT car_name, year, fuel_type, transmission, selling_price, driven_kms, owner, buy_score,
    DENSE_RANK() OVER (ORDER BY buy_score DESC)                       AS buyer_rank
FROM scored WHERE selling_price<=5
ORDER BY buy_score DESC, selling_price ASC LIMIT 20;

-- 3. Best retention vehicles — lowest depreciation
SELECT car_name,
    ROUND(AVG(selling_price),2)                                       AS avg_resale,
    ROUND(AVG(present_price),2)                                       AS avg_ex_showroom,
    ROUND(AVG((present_price-selling_price)/present_price*100),1)     AS avg_dep_pct,
    COUNT(*) AS data_points,
    RANK() OVER (ORDER BY AVG((present_price-selling_price)/present_price*100) ASC) AS retention_rank
FROM vehicle_prices GROUP BY car_name HAVING COUNT(*)>=2
ORDER BY avg_dep_pct LIMIT 10;

-- 4. Overpriced vs fair value detection using JOIN
WITH model_avg AS (
    SELECT car_name, fuel_type, transmission,
        AVG(selling_price) AS fair_value
    FROM vehicle_prices GROUP BY car_name, fuel_type, transmission
)
SELECT v.car_name, v.year, v.fuel_type, v.transmission, v.selling_type,
    v.selling_price,
    ROUND(m.fair_value,2)                                             AS fair_value,
    ROUND(v.selling_price-m.fair_value,2)                             AS premium,
    CASE WHEN v.selling_price > m.fair_value*1.15 THEN 'Overpriced'
         WHEN v.selling_price < m.fair_value*0.85 THEN 'Underpriced'
         ELSE 'Fair Value' END                                        AS verdict
FROM vehicle_prices v
JOIN model_avg m ON v.car_name=m.car_name AND v.fuel_type=m.fuel_type AND v.transmission=m.transmission
ORDER BY ABS(v.selling_price-m.fair_value) DESC;
