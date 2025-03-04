## Introduction  
This project analyzes the data analyst job market, focusing on top-paying roles, in-demand skills, and the relationship between salary and required expertise.  

**SQL queries used in this analysis can be found here:** [7_SQL_project folder](/7_SQL_project/)  

## Background  
The goal of the project was to better understand the job market for data analysts, specifically identifying high-paying roles and in-demand skills. The goal was to streamline the process of assessing job opportunities based on salary and skill requirements.  

The dataset originates from the [SQL Course](https://lukebarousse.com/sql) and includes insights on job titles, salaries, locations, and essential skills.  

### Key Research Questions  
The analysis focused on answering the following:  
1. Which data analyst roles offer the highest salaries?  
2. What skills are required for these top-paying roles?  
3. What skills are most frequently listed in job postings?  
4. Which skills are correlated with higher salaries?  
5. Which skills provide the best return on investment in terms of salary and demand?  

## Tools Used  
Several tools were used to conduct this analysis:  
- **SQL:** Primary tool for querying and analyzing the dataset.  
- **PostgreSQL:** Database management system for handling job posting data.  
- **Visual Studio Code:** Development environment for SQL queries and database management.  
- **Git & GitHub:** Version control and project tracking for SQL scripts and analysis.  

## Analysis  

### 1. Top-Paying Data Analyst Jobs  
This query identifies the highest-paying data analyst roles, filtered by average yearly salary and remote work availability.  

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

**Findings:**  
- Salaries for top-paying data analyst roles range from $184,000 to $650,000.  
- High-paying positions are available across industries, with employers including SmartAsset, Meta, and AT&T.  
- Job titles vary, spanning from Data Analyst to Director of Analytics, indicating different levels of responsibility and specialization.  

### 2. Skills for Top-Paying Jobs  
This query identifies the most common skills among the highest-paying data analyst roles.  

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
INNER JOIN 
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    top_paying_jobs.salary_year_avg DESC
```

**Findings:**  
- **SQL** is the most common skill among top-paying roles, appearing in 8 of the 10 highest-paid positions.  
- **Python** follows closely with 7 mentions.  
- Other frequently listed skills include **Tableau, R, Snowflake, Pandas, and Excel**.  

### 3. Most In-Demand Skills  

```sql
SELECT
    skills,
    COUNT(skills_job_dim.skill_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```

**Findings:**  
- **SQL and Excel** are the most in-demand skills.  
- **Python, Tableau, and Power BI** are also commonly required.  

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 92,628       |
| Excel    | 67,031       |
| Python   | 57,326       |
| Tableau  | 46,554       |
| Power BI | 39,468       |

## Key Takeaways  

### Insights from the Analysis  
1. **Salary Distribution**: Remote data analyst salaries range widely, with top salaries reaching $650,000.  
2. **Essential Skills**: SQL is the most frequently required skill and is also highly associated with top-paying roles.  
3. **Technical Skills Matter**: Python, Tableau, and Power BI are critical for career advancement in data analytics.  
4. **High-Paying Specializations**: Specialized technical skills, such as PySpark and DataRobot, drive the highest salaries.  
5. **Optimal Skills to Learn**: A combination of SQL, cloud computing, and data visualization provides strong job market positioning.  

## Conclusion  
This project gave a great insight into the data analyst job market, identifying key skills and salary trends. The findings serve as a reference for skill development and job market strategy, highlighting the importance of SQL, technical proficiency, and emerging data technologies
