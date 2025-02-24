CREATE TABLE job_applied (
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);

SELECT * 
FROM job_applied;

INSERT INTO job_applied (
    job_id,
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status  
)
VALUES(
    1,
    '2024-02-01',
    TRUE,
    'resume_1.pdf',
    TRUE,
    'cover_letter_01.pdf',
    'submitted'
),
(
    2,
    '2024-02-02',
    FALSE,
    NULL,
    FALSE,
    NULL,
    'not submitted'
),
(
    3,
    '2024-02-03',
    TRUE,
    'resume_3.pdf',
    TRUE,
    'cover_letter_03.pdf',
    'submitted'
);

SELECT *
FROM job_applied;

ALTER TABLE job_applied
    ADD contact VARCHAR(50);

UPDATE job_applied
SET contact = 'John Doe'
WHERE job_id = 1;

UPDATE job_applied
SET contact = 'Dinesh Chugtai'
WHERE job_id = 2;

UPDATE job_applied
SET contact = 'Erich Backman'
WHERE job_id = 3;

SELECT *
FROM job_applied;

ALTER TABLE job_applied
ALTER COLUMN contact TYPE TEXT;

ALTER TABLE job_applied
DROP COLUMN contact;

DROP TABLE job_applied;
