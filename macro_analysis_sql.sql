
## select perod
SELECT
    CASE 
        WHEN "Month" BETWEEN '2022-01-01' AND '2022-12-31' THEN '1.Crisis 2022'
        WHEN "Month" BETWEEN '2023-01-01' AND '2024-02-29' THEN '2.Recovery 2023-24'
    END as period,
    ROUND(AVG("USD_LKR_Exchange_Rate")::numeric,2) AS avg_exchange_price,
    ROUND(AVG("Avg_Weighted_Lending_Rate")::numeric,2) AS avg_interest_price,
    ROUND(AVG("JKH_avg_close")::numeric,2) AS avg_jkh_price,
    ROUND(AVG("COMB_avg_close")::numeric,2) AS avg_comb_price,
    ROUND(AVG("DIAL_avg_close")::numeric,2) AS avg_dial_price,
    ROUND(AVG("LOLC_avg_close")::numeric,2) AS avg_lolc_price
FROM master_data
GROUP BY period
ORDER BY period;

## LOLC monthly trend 

SELECT "Month",
    "LOLC_avg_close",
    "Avg_Weighted_Lending_Rate",
    "USD_LKR_Exchange_Rate"
FROM master_data
ORDER BY "Month";

## correlation

SELECT 
    CORR("LOLC_avg_close","Avg_Weighted_Lending_Rate") AS lolc_vs_insterest,
    CORR("LOLC_avg_close","USD_LKR_Exchange_Rate") AS lolc_vs_exchange,
    CORR("COMB_avg_close","Avg_Weighted_Lending_Rate") AS comb_vs_insterest,
    CORR("COMB_avg_close","USD_LKR_Exchange_Rate") AS comb_vs_exchange
FROM master_data;

SELECT 'JKH' AS company,
       ROUND(CORR("JKH_avg_close", "Avg_Weighted_Lending_Rate")::numeric, 3) AS corr_interest,
       ROUND(CORR("JKH_avg_close", "USD_LKR_Exchange_Rate")::numeric, 3) AS corr_exchange
FROM master_data
UNION ALL
SELECT 'COMB',
       ROUND(CORR("COMB_avg_close", "Avg_Weighted_Lending_Rate")::numeric, 3),
       ROUND(CORR("COMB_avg_close", "USD_LKR_Exchange_Rate")::numeric, 3)
FROM master_data
UNION ALL
SELECT 'LOLC',
       ROUND(CORR("LOLC_avg_close", "Avg_Weighted_Lending_Rate")::numeric, 3),
       ROUND(CORR("LOLC_avg_close", "USD_LKR_Exchange_Rate")::numeric, 3)
FROM master_data
UNION ALL
SELECT 'DIAL',
       ROUND(CORR("DIAL_avg_close", "Avg_Weighted_Lending_Rate")::numeric, 3),
       ROUND(CORR("DIAL_avg_close", "USD_LKR_Exchange_Rate")::numeric, 3)
FROM master_data
ORDER BY corr_exchange ASC;

## Volatility Ranking

SELECT 'JKH' AS company,
       ROUND((MAX("JKH_avg_close") - MIN("JKH_avg_close"))::numeric, 2) AS price_range,
       ROUND(AVG("JKH_avg_close")::numeric, 2) AS avg_price,
       ROUND(((MAX("JKH_avg_close") - MIN("JKH_avg_close")) / AVG("JKH_avg_close") * 100)::numeric, 1) AS range_pct_of_avg
FROM master_data
UNION ALL
SELECT 'COMB',
       ROUND((MAX("COMB_avg_close") - MIN("COMB_avg_close"))::numeric, 2),
       ROUND(AVG("COMB_avg_close")::numeric, 2),
       ROUND(((MAX("COMB_avg_close") - MIN("COMB_avg_close")) / AVG("COMB_avg_close") * 100)::numeric, 1)
FROM master_data
UNION ALL
SELECT 'LOLC',
       ROUND((MAX("LOLC_avg_close") - MIN("LOLC_avg_close"))::numeric, 2),
       ROUND(AVG("LOLC_avg_close")::numeric, 2),
       ROUND(((MAX("LOLC_avg_close") - MIN("LOLC_avg_close")) / AVG("LOLC_avg_close") * 100)::numeric, 1)
FROM master_data
UNION ALL
SELECT 'DIAL',
       ROUND((MAX("DIAL_avg_close") - MIN("DIAL_avg_close"))::numeric, 2),
       ROUND(AVG("DIAL_avg_close")::numeric, 2),
       ROUND(((MAX("DIAL_avg_close") - MIN("DIAL_avg_close")) / AVG("DIAL_avg_close") * 100)::numeric, 1)
FROM master_data
ORDER BY range_pct_of_avg DESC;