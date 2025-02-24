WITH unique_job_titles AS (
    SELECT
        company_id,
        COUNT(DISTINCT job_title) AS jobs_count
    FROM
        job_postings_fact
    GROUP BY
        company_id
    ORDER BY
        jobs_count DESC
)

SELECT
    company_dim.name as company_name,
    unique_job_titles.jobs_count
FROM
    company_dim
LEFT JOIN unique_job_titles ON
    company_dim.company_id = unique_job_titles.company_id
ORDER BY
    jobs_count DESC
LIMIT 10;


WITH country_averages AS (
    SELECT
        job_country,
        AVG(salary_year_avg) AS avg_salary
    FROM
        job_postings_fact
    WHERE
        salary_year_avg IS NOT NULL
    GROUP BY
        job_country
)

SELECT
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    company_dim.name AS company_name,
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date) AS job_posted_month,
    job_postings_fact.salary_year_avg,
    country_averages.avg_salary AS country_avg_salary,
    CASE
        WHEN job_postings_fact.salary_year_avg > country_averages.avg_salary THEN 'Above average'
        WHEN job_postings_fact.salary_year_avg = country_averages.avg_salary THEN 'Average'
        ELSE 'Below average'
    END AS country_salary_rating
FROM
    job_postings_fact
    LEFT JOIN country_averages ON
    job_postings_fact.job_country = country_averages.job_country
    LEFT JOIN company_dim ON
    job_postings_fact.company_id = company_dim.company_id
WHERE
    job_postings_fact.salary_year_avg IS NOT NULL
ORDER BY
    job_posted_month DESC;


WITH unique_skills AS (
    SELECT
        job_id,
        COUNT(DISTINCT skill_id) AS skills_count
    FROM
        skills_job_dim
    GROUP BY
        job_id
),

skill_average_salaries AS (
    SELECT
        company_id,
        MAX(salary_year_avg) AS average_salary
    FROM
        job_postings_fact
    WHERE
        salary_year_avg IS NOT NULL
    GROUP BY
        company_id
) 

SELECT
    company_dim.name AS company_name,
    unique_skills.skills_count,
    skill_average_salaries.average_salary,
    COALESCE(unique_skills.skills_count, 0) AS skills_count,
    COALESCE(skill_average_salaries.average_salary, 0) AS average_salary
FROM
    job_postings_fact
    LEFT JOIN unique_skills ON
        job_postings_fact.job_id = unique_skills.job_id
    LEFT JOIN skill_average_salaries ON
        job_postings_fact.company_id = skill_average_salaries.company_id
    LEFT JOIN company_dim ON
        job_postings_fact.company_id = company_dim.company_id
ORDER BY
    company_name;

-- Counts the distinct skills required for each company's job posting
WITH required_skills AS (
  SELECT
    companies.company_id,
    COUNT(DISTINCT skills_to_job.skill_id) AS unique_skills_required
  FROM
    company_dim AS companies 
  LEFT JOIN job_postings_fact as job_postings ON companies.company_id = job_postings.company_id
  LEFT JOIN skills_job_dim as skills_to_job ON job_postings.job_id = skills_to_job.job_id
  GROUP BY
    companies.company_id
),
-- Gets the highest average yearly salary from the jobs that require at least one skills 
max_salary AS (
  SELECT
    job_postings.company_id,
    MAX(job_postings.salary_year_avg) AS highest_average_salary
  FROM
    job_postings_fact AS job_postings
  WHERE
    job_postings.job_id IN (SELECT job_id FROM skills_job_dim)
  GROUP BY
    job_postings.company_id
)
-- Joins 2 CTEs with table to get the query
SELECT
  companies.name,
  required_skills.unique_skills_required as unique_skills_required, --handle companies w/o any skills required
  max_salary.highest_average_salary
FROM
  company_dim AS companies
LEFT JOIN required_skills ON companies.company_id = required_skills.company_id
LEFT JOIN max_salary ON companies.company_id = max_salary.company_id
ORDER BY
	companies.name;