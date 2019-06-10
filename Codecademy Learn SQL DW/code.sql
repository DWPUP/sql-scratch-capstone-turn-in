/* 2-1 Number of Campaigns */
SELECT COUNT(DISTINCT utm_campaign) AS 'Num_Campaigns'
FROM page_visits;

/* 2-2 Number of Sources */
SELECT COUNT(DISTINCT utm_source) AS 'Num_Sources'
FROM page_visits;

/* 2-3 Source Campaigns */
SELECT utm_campaign, utm_source
FROM page_visits 
GROUP BY utm_campaign, utm_source;

/* 3-1 Website Pages */
SELECT DISTINCT page_name
FROM page_visits;

/* 3-2 Campaign First Touches */
WITH first_touch AS (
  SELECT user_id, MIN(timestamp) AS 'first_touch_at'
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_campaign, COUNT(ft.first_touch_at) AS 'first_touches'
FROM first_touch AS ft
JOIN page_visits AS pv
  ON ft.user_id = pv.user_id
  AND ft.first_touch_at = pv.timestamp
GROUP BY pv.utm_campaign;

/* 3-3 Campaign Last Touches */
WITH last_touch AS (
  SELECT user_id, MAX(timestamp) AS 'last_touch_at'
  FROM page_visits
  GROUP BY user_id)
SELECT pv.utm_campaign, COUNT(lt.last_touch_at) AS 'last_touches'
FROM last_touch AS lt
JOIN page_visits AS pv
  ON lt.user_id = pv.user_id
  AND lt.last_touch_at = pv.timestamp
GROUP BY pv.utm_campaign;

/* 3-4 Visitor Purchases */
SELECT COUNT(DISTINCT user_id) AS 'NumUsersPurchased'
FROM page_visits
WHERE page_name = "4 - purchase";

/* 3-5 Campaign Last Touch Purchases */
WITH last_touch AS (
  SELECT user_id, MAX(timestamp) AS 'last_touch_at'
  FROM page_visits
  GROUP BY user_id)
SELECT pv.utm_campaign, COUNT(lt.last_touch_at) AS 'NumLastTouches'
FROM last_touch AS lt
JOIN page_visits AS pv
  ON lt.user_id = pv.user_id
  AND lt.last_touch_at = pv.timestamp
WHERE pv.page_name = "4 - purchase"
GROUP BY pv.utm_campaign
ORDER BY pv.utm_campaign;

/* 3-6 Visitor Journey */
  SELECT user_id, MAX(timestamp) AS 'last_touch_at'
  FROM page_visits
  GROUP BY user_id)
SELECT pv.page_name, COUNT(lt.user_id) AS 'users'
FROM last_touch AS lt
JOIN page_visits AS pv
  ON lt.user_id = pv.user_id
GROUP BY pv.page_name
ORDER BY page_name;

/* 4-1 Campaign Reinvest */
WITH last_touch AS (
  SELECT user_id, MAX(timestamp) AS 'last_touch_at'
  FROM page_visits
  GROUP BY user_id)
SELECT pv.utm_campaign, COUNT(lt.last_touch_at) AS 'purchases'
FROM last_touch AS lt
JOIN page_visits AS pv
  ON lt.user_id = pv.user_id
  AND lt.last_touch_at = pv.timestamp
WHERE pv.page_name = "4 - purchase"
GROUP BY pv.utm_campaign
ORDER BY purchases desc, last_touch_at desc
LIMIT 5;