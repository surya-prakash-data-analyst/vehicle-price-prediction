-- ============================================================
-- VEHICLE PRICE ANALYSIS  |  Vehicle Price Prediction Project
-- ============================================================

-- 1. Market KPI summary
SELECT
    COUNT(*)                                                          AS total_vehicles,
    ROUND(AVG(selling_price),2)                                       AS avg_resale_lakh,
    ROUND(AVG(present_price),2)                                       AS avg_ex_showroom,
    ROUND(AVG((present_price-selling_price)/present_price*100),1)     AS avg_depreciation_pct,
    ROUND(MIN(selling_price),2)                                       AS min_price,
    ROUND(MAX(selling_price),2)                                       AS max_price,
    MIN(year)                                                         AS oldest_year,
    MAX(year)                                                         AS newest_year
FROM vehicle_prices;

-- 2. Price by fuel type with window rank
SELECT
    fuel_type,
    COUNT(*)                                                          AS vehicles,
    ROUND(AVG(selling_price),2)                                       AS avg_resale,
    ROUND(AVG(present_price),2)                                       AS avg_ex_showroom,
    ROUND(AVG(present_price-selling_price),2)                         AS avg_value_loss,
    RANK() OVER (ORDER BY AVG(selling_price) DESC)                    AS price_rank
FROM vehicle_prices
GROUP BY fuel_type
ORDER BY avg_resale DESC;

-- 3. Seller type premium analysis
SELECT
    selling_type,
    COUNT(*)                                                          AS listings,
    ROUND(AVG(selling_price),2)                                       AS avg_price,
    ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (),1)                     AS market_share_pct,
    ROUND(AVG(selling_price)-AVG(AVG(selling_price)) OVER (),2)       AS vs_market_avg
FROM vehicle_prices
GROUP BY selling_type;

-- 4. Transmission premium
SELECT
    transmission,
    COUNT(*)                                                          AS vehicles,
    ROUND(AVG(selling_price),2)                                       AS avg_price,
    ROUND(AVG(driven_kms),0)                                          AS avg_kms,
    DENSE_RANK() OVER (ORDER BY AVG(selling_price) DESC)              AS value_rank
FROM vehicle_prices
GROUP BY transmission;

-- 5. Owner history price impact with LAG
SELECT
    owner,
    COUNT(*)                                                          AS vehicles,
    ROUND(AVG(selling_price),2)                                       AS avg_price,
    LAG(ROUND(AVG(selling_price),2)) OVER (ORDER BY owner)            AS prev_owner_avg,
    ROUND(100.0*(AVG(selling_price)-LAG(AVG(selling_price)) OVER (ORDER BY owner))
          /NULLIF(LAG(AVG(selling_price)) OVER (ORDER BY owner),0),1) AS pct_change
FROM vehicle_prices
GROUP BY owner
ORDER BY owner;

-- 6. Price by vehicle age band
SELECT
    CASE
        WHEN (2024-year)<=3  THEN '0-3 Years'
        WHEN (2024-year)<=6  THEN '4-6 Years'
        WHEN (2024-year)<=10 THEN '7-10 Years'
        ELSE '10+ Years'
    END                                                               AS age_band,
    COUNT(*)                                                          AS vehicles,
    ROUND(AVG(selling_price),2)                                       AS avg_price,
    ROUND(AVG(driven_kms),0)                                          AS avg_kms,
    RANK() OVER (ORDER BY AVG(selling_price) DESC)                    AS value_rank
FROM vehicle_prices
GROUP BY age_band
ORDER BY avg_price DESC;
