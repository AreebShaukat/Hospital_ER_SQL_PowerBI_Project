-- What is the average wait time for patients in the ER?

SELECT AVG(patient_waittime) AS avg_wait_time
FROM hospitaltable;

-- How does patient satisfaction vary by gender?

SELECT patient_gender, AVG(patient_sat_score) AS avg_sat_score
FROM hospitaltable
WHERE patient_gender IN ('M', 'F')
GROUP BY patient_gender;

-- What is the average patient satisfaction score by patient gender and age group (e.g., under 30, 30-39, 40-49)?

SELECT 
    CASE
        WHEN patient_age < 30 THEN 'Under 30'
        WHEN patient_age BETWEEN 30 AND 39 THEN '30-39'
        WHEN patient_age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and over'
    END AS age_group,
    patient_gender,
    AVG(patient_sat_score) AS avg_sat_score
FROM hospitaltable
WHERE patient_gender IN ('M', 'F')
GROUP BY age_group, patient_gender
ORDER BY age_group, patient_gender;



-- What is the distribution of patient ages in the ER?
SELECT 
    CASE
        WHEN patient_age < 20 THEN 'Under 20'
        WHEN patient_age >= 20 AND patient_age < 30 THEN '20-29'
        WHEN patient_age >= 30 AND patient_age < 40 THEN '30-39'
        WHEN patient_age >= 40 AND patient_age < 50 THEN '40-49'
        ELSE '50 and over'
    END AS age_group,
    COUNT(*) AS num_patients
FROM hospitaltable
GROUP BY age_group
ORDER BY age_group;

-- Which departments receive the most referrals from the ER?

SELECT department_referral, COUNT(*) AS num_referrals
FROM hospitaltable
WHERE department_referral IS NOT NULL
  AND department_referral != 'None'
GROUP BY department_referral
ORDER BY num_referrals DESC;


-- What is the trend of patient admissions flagged for urgent care over time?
SELECT 
    DATE_FORMAT(date, '%Y-%m') AS month,
    SUM(CASE WHEN patient_admin_flag = 'true' THEN 1 ELSE 0 END) AS num_urgent_admissions
FROM hospitaltable
GROUP BY month
ORDER BY month;

SELECT 
    MONTHNAME(date) AS month_name,
    SUM(CASE WHEN patient_admin_flag = 'true' THEN 1 ELSE 0 END) AS num_urgent_admissions
FROM hospitaltable
GROUP BY month_name
ORDER BY month_name;

-- admission rate
SELECT 
    COUNT(CASE WHEN patient_admin_flag = 'true' THEN 1 END) AS num_admissions,
    COUNT(*) AS total_patients,
    (COUNT(CASE WHEN patient_admin_flag = 'true' THEN 1 END) / COUNT(*)) * 100 AS admission_rate_percentage
FROM hospitaltable;
