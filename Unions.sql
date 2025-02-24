(
SELECT
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    'With salary info' AS salary_info
FROM
    job_postings_fact
WHERE
    job_postings_fact.salary_year_avg IS NOT NULL OR job_postings_fact.salary_hour_avg IS NOT NULL
)
UNION ALL
(
SELECT
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    'Without salary info' AS salary_info
FROM
    job_postings_fact
WHERE
    job_postings_fact.salary_hour_avg IS NULL AND job_postings_fact.salary_year_avg IS NULL
)
ORDER BY 
	salary_info DESC, 
	job_id; 


-- For January
CREATE TABLE january_jobs AS 
	SELECT * 
	FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- For February
CREATE TABLE february_jobs AS 
	SELECT * 
	FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- For March
CREATE TABLE march_jobs AS 
	SELECT * 
	FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT
    january_jobs.job_id,
    january_jobs.job_title_short,
    january_jobs.job_location,
    january_jobs.job_via,
    skills_dim.skills,
    skills_dim.type
FROM
    january_jobs
LEFT JOIN skills_job_dim ON
    january_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    salary_year_avg > 70000

UNION ALL

SELECT
    february_jobs.job_id,
    february_jobs.job_title_short,
    february_jobs.job_location,
    february_jobs.job_via,
    skills_dim.skills,
    skills_dim.type
FROM
    february_jobs
LEFT JOIN skills_job_dim ON
    february_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    salary_year_avg > 70000

UNION ALL

SELECT
    march_jobs.job_id,
    march_jobs.job_title_short,
    march_jobs.job_location,
    march_jobs.job_via,
    skills_dim.skills,
    skills_dim.type
FROM
    march_jobs
LEFT JOIN skills_job_dim ON
    march_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    salary_year_avg > 70000
ORDER BY
    job_id;

-- CTE for combining job postings from January, February, and March
WITH combined_job_postings AS (
  SELECT job_id, job_posted_date
  FROM january_jobs
  UNION ALL
  SELECT job_id, job_posted_date
  FROM february_jobs
  UNION ALL
  SELECT job_id, job_posted_date
  FROM march_jobs
),
-- CTE for calculating monthly skill demand based on the combined postings
monthly_skill_demand AS (
  SELECT
    skills_dim.skills,  
    EXTRACT(YEAR FROM combined_job_postings.job_posted_date) AS year,  
    EXTRACT(MONTH FROM combined_job_postings.job_posted_date) AS month,  
    COUNT(combined_job_postings.job_id) AS postings_count 
  FROM
    combined_job_postings
	  INNER JOIN skills_job_dim ON combined_job_postings.job_id = skills_job_dim.job_id  
	  INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id  
  GROUP BY
    skills_dim.skills, year, month
)
-- Main query to display the demand for each skill during the first quarter
SELECT
  skills,  
  year,  
  month,  
  postings_count 
FROM
  monthly_skill_demand
ORDER BY
  skills, year, month;  