SELECT
    job_postings_fact.job_schedule_type,
    AVG(salary_year_avg) AS avg_salary_year,
    AVG(salary_hour_avg) AS avg_salary_hour
FROM
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type
ORDER BY
    job_schedule_type;


SELECT
    COUNT(*) AS job_posting_count,
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS job_posting_month
FROM
    job_postings_fact
GROUP BY
    job_posting_month
ORDER BY
    job_posting_month;

SELECT
    COUNT(jobs.job_id) AS job_posting_count,
    companies.name
FROM
    job_postings_fact AS jobs
    INNER JOIN
        company_dim AS companies
        ON jobs.company_id = companies.company_id
WHERE
    jobs.job_health_insurance = TRUE AND
    EXTRACT(QUARTER FROM jobs.job_posted_date) = 2
GROUP BY
    companies.name
HAVING
    COUNT(jobs.job_id) > 1
ORDER BY
    job_posting_count DESC;