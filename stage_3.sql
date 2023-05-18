-- Reset the database to initial state
-- NOTE-MEMO: do `.backup /dev/shm/temp.db.backup` to a clean database first.
.restore /dev/shm/temp.db.backup

-- Import data from provided datasets
-- NOTE: The project assignment suggested manually creating the tables first
--       and then importing the csv's without the header row, but this works as well.
.import --csv ./person.csv person
.import --csv ./teacher.csv teacher
.mode column

-- Create the student grades table
CREATE TABLE student (
    person_id VARCHAR(9) PRIMARY KEY,
    grade_code TEXT
);

-- Initialize the student grades table with the students person_ids
INSERT INTO student (person_id)
SELECT person_id
FROM person
WHERE person_id NOT IN (
  SELECT DISTINCT person_id FROM teacher
);

-- List first 5 student by person_id
SELECT * FROM student ORDER BY person_id LIMIT 5;
