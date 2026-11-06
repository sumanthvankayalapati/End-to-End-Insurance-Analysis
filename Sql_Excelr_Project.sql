create database project;
use project;
#KPI 2
select count( distinct `customer id`) from `customer information`;
#KPI 3
select count(distinct `Policy ID`) from `policy details`;
#KPI 4
select sum(`claim amount`) as `Total claim amount` from claims;
#KPI 5
select `policy type`,round(avg(`Coverage Amount`),0) as `Avg Coverage amnt`  from `policy details` group by `policy type`;
#KPI 6
select `policy type`,round(avg(`Premium Amount`),0) as `Avg Premium Amount`  from `policy details` group by `policy type`;
#kpi 7
SELECT 
    ROUND(
        COUNT(CASE WHEN `Status` = 'Active' THEN 1 END) * 100.0 
        / COUNT(*),
        2
    ) AS Active_Policy_Percentage
FROM `Policy details`;
#kpi 8
select status ,count(*) as Count from `policy details` group by status order by count desc;
#KPI 9 
SELECT Status, COUNT(`Policy ID`) AS Policy_Count
FROM `Policy details`
GROUP BY Status
ORDER BY Policy_Count DESC
LIMIT 1;
# KPI 10 
SELECT 
    SUM(CASE 
        WHEN Status = 'Active' THEN 1 
        ELSE 0 
    END) AS Active_Policies,

    SUM(CASE 
        WHEN Status IN ('Terminated', 'Lapsed') THEN 1 
        ELSE 0 
    END) AS Inactive_Policies,

    CONCAT(
        SUM(CASE WHEN Status = 'Active' THEN 1 ELSE 0 END),
        ' : ',
        SUM(CASE WHEN Status IN ('Terminated', 'Lapsed') THEN 1 ELSE 0 END)
    ) AS Active_Inactive_Ratio

FROM `Policy details`;
#KPI 11
SELECT
    CASE
        WHEN ci.`Age` < 28 THEN '18-28'
        WHEN ci.`Age` < 38 THEN '28-38'
        WHEN ci.`Age` < 48 THEN '38-48'
        WHEN ci.`Age` < 58 THEN '48-58'
        WHEN ci.`Age` < 68 THEN '58-68'
        WHEN ci.`Age` < 78 THEN '68-78'
        ELSE '78-88'
    END AS `Age Group`,
    COUNT(pd.`Policy ID`) AS `Policy Count`
FROM `Customer Information` ci
JOIN `Policy Details` pd
    ON ci.`Customer ID` = pd.`Customer ID`
GROUP BY
    CASE
        WHEN ci.`Age` < 28 THEN '18-28'
        WHEN ci.`Age` < 38 THEN '28-38'
        WHEN ci.`Age` < 48 THEN '38-48'
        WHEN ci.`Age` < 58 THEN '48-58'
        WHEN ci.`Age` < 68 THEN '58-68'
        WHEN ci.`Age` < 78 THEN '68-78'
        ELSE '78-88'
    END
ORDER BY `Policy Count` DESC;
#KPI 12
SELECT
    CASE
        WHEN ci.`Age` < 28 THEN '18-28'
        WHEN ci.`Age` < 38 THEN '28-38'
        WHEN ci.`Age` < 48 THEN '38-48'
        WHEN ci.`Age` < 58 THEN '48-58'
        WHEN ci.`Age` < 68 THEN '58-68'
        WHEN ci.`Age` < 78 THEN '68-78'
        ELSE '78-88'
    END AS `Age Group`,
    COUNT(pd.`Policy ID`) AS `Policy Count`
FROM `Customer Information` ci
JOIN `Policy Details` pd
    ON ci.`Customer ID` = pd.`Customer ID`
GROUP BY
    CASE
        WHEN ci.`Age` < 28 THEN '18-28'
        WHEN ci.`Age` < 38 THEN '28-38'
        WHEN ci.`Age` < 48 THEN '38-48'
        WHEN ci.`Age` < 58 THEN '48-58'
        WHEN ci.`Age` < 68 THEN '58-68'
        WHEN ci.`Age` < 78 THEN '68-78'
        ELSE '78-88'
    END
ORDER BY `Policy Count` DESC
LIMIT 3;
#KPI 13
select gender,count(`Policy ID`) as `Gender participation` from `customer information` c join `policy details` p on c.`Customer ID`=p.`Customer ID`  group by gender;
#kpi 14
SELECT
    ABS(
        SUM(CASE WHEN ci.`Gender` = 'Male' THEN 1 ELSE 0 END)
        -
        SUM(CASE WHEN ci.`Gender` = 'Female' THEN 1 ELSE 0 END)
    ) AS `Male Female Policy Count Difference`
FROM `Customer Information` ci
JOIN `Policy Details` pd
    ON ci.`Customer ID` = pd.`Customer ID`;
#kpi 15
select `Policy Type`,count(*) as  `Maximum count` from `policy details` group by `Policy Type` order by `Maximum count` desc limit 1;

#kpi 16
select `Policy Type`,count(*) as  `Minimum count` from `policy details` group by `Policy Type` order by  `Minimum count` limit 1;
#kpi 17
SELECT
    SUM(CASE WHEN `Policy Type` = 'Auto' THEN 1 ELSE 0 END) AS `Auto Policy Count`,
    SUM(CASE WHEN `Policy Type` = 'Health' THEN 1 ELSE 0 END) AS `Health Policy Count`
FROM `Policy Details`;
#kpi 18
select `Policy Type`,count(`Policy Type`) as `policies count` from  `policy details`group by `Policy Type`;
#kpi 19 
WITH YearlyPremium AS (
    SELECT
        YEAR(`Policy Start Date`) AS PolicyYear,
        AVG(`Premium Amount`) AS AvgPremium
    FROM `policy details`
    GROUP BY YEAR(`Policy Start Date`)
),
PremiumGrowth AS (
    SELECT
        PolicyYear,
        AvgPremium,
        LAG(AvgPremium) OVER (ORDER BY PolicyYear) AS PreviousPremium
    FROM YearlyPremium
)
SELECT
    ROUND(
        AVG(
            (AvgPremium - PreviousPremium) / PreviousPremium
        ) * 100,
        2
    ) AS AveragePremiumGrowthRate
FROM PremiumGrowth
WHERE PreviousPremium IS NOT NULL;
#kpi 20
WITH YearlyPremium AS (
    SELECT
        YEAR(`Policy Start Date`) AS PolicyYear,
        AVG(`Premium Amount`) AS AvgPremium
    FROM `policy details`
    GROUP BY YEAR(`Policy Start Date`)
),
PremiumGrowth AS (
    SELECT
        PolicyYear,
        AvgPremium,
        LAG(AvgPremium) OVER (ORDER BY PolicyYear) AS PreviousPremium
    FROM YearlyPremium
)
SELECT
    PolicyYear,
    ROUND(
        ((AvgPremium - PreviousPremium) / PreviousPremium) * 100,
        2
    ) AS PremiumGrowthRate
FROM PremiumGrowth
WHERE PreviousPremium IS NOT NULL
ORDER BY PolicyYear;
#kpi 21
WITH YearlyPremium AS (
    SELECT
        YEAR(`Policy Start Date`) AS PolicyYear,
        AVG(`Premium Amount`) AS AvgPremium
    FROM `policy details`
    GROUP BY YEAR(`Policy Start Date`)
),
PremiumGrowth AS (
    SELECT
        PolicyYear,
        AvgPremium,
        LAG(AvgPremium) OVER (ORDER BY PolicyYear) AS PreviousPremium
    FROM YearlyPremium
),
GrowthRates AS (
    SELECT
        ((AvgPremium - PreviousPremium) / PreviousPremium) * 100 AS GrowthRate
    FROM PremiumGrowth
    WHERE PreviousPremium IS NOT NULL
)
SELECT
    ROUND(MAX(GrowthRate) - MIN(GrowthRate), 2) AS PremiumGrowthDifference
FROM GrowthRates;
#kpi 22
select year(`Policy End Date`),count(*) as `policies count` from  `policy details` group by year(`Policy End Date`) order by year(`Policy End Date`);
