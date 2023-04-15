USE mavenfuzzyfactory;

SELECT * 
FROM website_sessions
WHERE website_session_id = 1000;

SELECT *
FROM website_pageviews
WHERE website_session_id = 1000;

SELECT *
FROM ORDERS
WHERE website_session_id = 1000;

SELECT DISTINCT
	utm_source,
    utm_campaign
FROM website_sessions;

SELECT *
FROM website_sessions;

-- Which adds campaign generating the highest shares of sessions(activity)

SELECT
	utm_content,
    COUNT(DISTINCT website_session_id) AS sessions
FROM 
	website_sessions
GROUP BY 
	utm_content
ORDER BY
	sessions DESC;
    
-- Through which add compaign(utf_content) company is getting highest orders.

SELECT
	w.utm_content,
    COUNT(DISTINCT w.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders
FROM 
	website_sessions AS w
	LEFT JOIN
		orders AS o
	ON o.website_session_id = w.website_session_id
GROUP BY 
	w.utm_content
ORDER BY
	sessions DESC;

-- Find out the conversion rate
SELECT
	w.utm_content,
    COUNT(DISTINCT w.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id)*100 AS conversion_rate
FROM 
	website_sessions AS w
	LEFT JOIN
		orders AS o
	ON o.website_session_id = w.website_session_id
GROUP BY 
	w.utm_content
ORDER BY
	sessions DESC;
    
/*
Date: 12, April 2012
From Cindy Sharp(CEO)
Subject:  Site traffic breakdown
Good Morning,

We've been live for almost a month now and we are starting to generate sales. Can you help me understand 
where the bulk of our website sessions are coming from, through yesterday ?

I' Would like to get a breakdown by UTM source, campaign and referring domain if possible.Thanks!

*/
;

SELECT 
	utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_session_id) AS Sessions
FROM
	website_sessions
WHERE 
	created_at < '2012-04-14'
GROUP BY 
	utm_source,
    utm_campaign,
    http_referer
ORDER BY 
	Sessions DESC;
    
/*
From: TOM ( Marketing Director)
Subject: Gsearch conversion rate

Sounds like search nonbrand is our major traffic source, but we need to understand if those sessions are driving sales.
Could you please calculate the conversion rate (CVR) from session to order? Based on what we're paying for clicks, we'll need a CVR of at least 4% to make the numbers work.
If we're much lower, we'll need to reduce bids. If we're higher, we can increase bids to drive more volume.

Thanks, Tom
*/

SELECT 
	COUNT(DISTINCT w.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) as orders,
    COUNT(order_id)/COUNT(w.website_session_id)*100 AS session_to_order_conv_rate
FROM 
	website_sessions AS w
LEFT JOIN 
	orders AS o
ON o.website_session_id = w.website_session_id
WHERE 
	w.created_at < '2012-04-14' AND utm_source = 'gsearch' AND utm_campaign = 'nonbrand'
;	
/*	
From: TOM ( Marketing Director)
Subject: RE: Gsearch conversion rate
Hmm, looks like we're below the 4% threshold we need to make the economics work.
Based on this analysis, we'll need to dial down our search bids a bit. We're over-spending based on the current conversion rate.
Nice work, your analysis just saved us some $$$!
*/

    
 /*   
 Today Date: May,10, 2012
From Tom Parmesan
Subject: Gsearch volume trends

Hi there,
Based on your conversion rate analysis, we bid down search nonbrand on 2012-04-15.
Can you pull search nonbrand trended session volume, by week, to see if the bid changes have caused volume to drop at all?
Thanks, Tom
*/

SELECT 
	-- YEAR(created_at) AS yr,
    -- WEEK(created_at) AS week,
     MIN(DATE (created_at)),
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions 
WHERE
	created_at < '2012-05-12' AND utm_source = 'gsearch' AND utm_campaign = 'nonbrand'
GROUP BY 
	YEAR(created_at),
    WEEK(created_at)

/*
Hi there, great analysis!
Okay, based on this, it does look like search nonbrand is fairly sensitive to bid changes.
We want maximum volume, but don't want to spend more on ads than we can afford.
Let me think on this. I will likely follow up with some ideas.
Thanks, Tom
*/

/*
DATE MAY,11 2012
FROM: TOM (Marketing Director)
Subject: Gsearch Device level performance
1 was trying to use our site on my mobile device the other day, and the experience was not great.
Could you pull conversion rates from session to order, by device type?
If desktop performance is better than on mobile we may be able to bid up for desktop specifically to get more volume?

Thanks, 
Tom
*/

SELECT
	w.device_type,
    COUNT(distinct w.website_session_id)AS sessions,
    COUNT(o.order_id) AS orders,
    COUNT(o.order_id)/COUNT(distinct w.website_session_id)*100 AS conversion_rate
FROM 
	website_sessions AS w
LEFT JOIN
	orders AS o
ON w.website_session_id = o.website_session_id
WHERE w.created_at < '2012-05-11' AND w.utm_source = 'gsearch' AND w.utm_campaign = 'nonbrand'
GROUP BY 
	w.device_type

/*
FROM: TOM(Marketing Director)

I'm going to increase our bids on desktop.
When we bid higher, we'll rank higher in the auctions, so I think your insights here should lead to a sales boost.
Well done!!

Tom
*/
/*
Date: June, 09, 2012
From: Tom (Marketing Director)
Subject: Grearch devise-level Trends
After your device-level analysis of conversion rates, we realized desktop was doing well, so we bid our gsearch nonbrand desktop campaigns up on 2012-05-19.
Could you pull weekly trends for both desktop and mobile so we can see the impact on volume?
You can use 2012-04-15 until the bid change as a baseline.

Thanks, 
Tom
*/

SELECT
	device_type,
	MIN(DATE (created_at)),
    COUNT(CASE WHEN device_type = dekstop THEN website_session_id ELSE NULL END) AS Dtop_sessions,
    COUNT(CASE WHEN device_type = mobile THEN website_session_id ELSE NULL END) AS Mob_sessions
FROM 
	website_sessions
WHERE created_at > '2012-04-15' AND utm_source = 'gsearch' AND utm_campaign = 'nonbrand'
GROUP BY
	device_type,
    YEAR(created_at),
    WEEK(created_at)
