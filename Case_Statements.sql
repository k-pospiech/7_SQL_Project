SELECT
    job_id,
    job_title,
    salary_year_avg,
    CASE
        WHEN salary_year_avg >= 100000 THEN 'High salary'
        WHEN salary_year_avg BETWEEN 60000 AND 99999 THEN 'Standard salary'
        ELSE 'Low salary'
    END AS salary_category
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;

SELECT
    CASE
        WHEN job_work_from_home = 'Yes' THEN 'Remote'
        ELSE 'Onsite'
    END AS job_remote,
    COUNT(DISTINCT(company_id)) AS company_count
FROM
    job_postings_fact
GROUP BY
    job_remote;

SELECT
    job_id,
    salary_year_avg,
    CASE
        WHEN job_title ILIKE '%Senior%' THEN 'Senior'
        WHEN (job_title ILIKE '%Manager%' OR job_title ILIKE '%Lead%') THEN 'Lead/Manager'
        WHEN (job_title ILIKE '%Junior%' OR job_title ILIKE '%Entry%') THEN 'Junior/Entry'
        ELSE 'Not specified'
    END AS experience_level,
    CASE
        WHEN job_work_from_home = 'Yes' THEN 'Yes'
        ELSE 'No'
    END AS remote_option
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    job_id;