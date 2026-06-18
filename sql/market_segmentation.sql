-- ============================================================
-- MARKET SEGMENTATION  |  Vehicle Price Prediction Project
-- ============================================================

-- 1. Classify all vehicles into market segments
SELECT car_name, year, fuel_type, transmission, selling_price, present_price,
    CASE WHEN present_price>=20 THEN 'Luxury'
         WHEN present_price>=10 THEN 'Premium'
         WHEN present_price>=5  THEN 'Mid-Range'
         ELSE 'Economy' END                                           AS market_segment,
    CASE WHEN owner=0 AND (2024-year)<=5 THEN 'Premium Used'
         WHEN driven_kms<30000           THEN 'Low Mileage'
         WHEN selling_type='Dealer'      THEN 'Certified'
         ELSE 'Standard' END                                          AS buyer_tier
FROM vehicle_prices ORDER BY selling_price DESC;

-- 2. Segment performance summary
WITH cls AS (
    SELECT *,
        CASE WHEN present_price>=20 THEN 'Luxury'
             WHEN present_price>=10 THEN 'Premium'
             WHEN present_price>=5  THEN 'Mid-Range'
             ELSE 'Economy' END AS segment
    FROM vehicle_prices
)
SELECT segment, COUNT(*) AS vehicles,
    ROUND(AVG(selling_price),2)                                       AS avg_resale,
    ROUND(AVG((present_price-selling_price)/present_price*100),1)     AS avg_dep_pct,
    ROUND(MIN(selling_price),2)                                       AS floor_price,
    ROUND(MAX(selling_price),2)                                       AS ceiling_price,
    DENSE_RANK() OVER (ORDER BY AVG(selling_price) DESC)              AS segment_rank
FROM cls GROUP BY segment ORDER BY avg_resale DESC;

-- 3. Dealer vs Individual by segment
WITH cls AS (
    SELECT *,
        CASE WHEN present_price>=10 THEN 'Premium+' WHEN present_price>=5 THEN 'Mid-Range' ELSE 'Economy' END AS seg
    FROM vehicle_prices
)
SELECT seg, selling_type, COUNT(*) AS listings,
    ROUND(AVG(selling_price),2)                                       AS avg_price,
    ROUND(AVG(selling_price)-AVG(AVG(selling_price)) OVER (PARTITION BY seg),2) AS vs_segment_avg
FROM cls GROUP BY seg, selling_type ORDER BY seg, avg_price DESC;
