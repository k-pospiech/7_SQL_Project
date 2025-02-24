SELECT
    skills_dim.skills
FROM
(
    SELECT
    skill_id,
    COUNT(skill_id) AS skill_count
    FROM
        skills_job_dim
    GROUP BY
        skill_id
    ORDER BY
        skill_count DESC
    LIMIT 5
) AS top_skills
LEFT JOIN
    skills_dim ON
    skills_dim.skill_id = top_skills.skill_id
ORDER BY
    top_skills.skill_count DESC;

SELECT
    company_dim.name,
    CASE
        WHEN job_count < 10 THEN 'Small'
        WHEN job_count BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS size_category
FROM (

SELECT
    company_id,
    COUNT(*) AS job_count
FROM
    job_postings_fact
GROUP BY
    company_id
ORDER BY
    job_count DESC
    ) AS company_aggregated

JOIN
    company_dim ON company_dim.company_id = company_aggregated.company_id;


SELECT
    company_dim.name,
    avg_salary
FROM
    (SELECT
    job_postings_fact.company_id,
    AVG(job_postings_fact.salary_year_avg) AS avg_salary
FROM
    job_postings_fact
WHERE
    job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY
    company_id
ORDER BY
    avg_salary DESC) AS company_averages
JOIN
    company_dim ON company_dim.company_id = company_averages.company_id
WHERE
    avg_salary > (SELECT
    AVG(job_postings_fact.salary_year_avg)
FROM
    job_postings_fact);