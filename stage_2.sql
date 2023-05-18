-- Reset the database to initial state
-- NOTE-MEMO: do `.backup /dev/shm/temp.db.backup` to a clean database first.
.restore /dev/shm/temp.db.backup

-- Import data from provided datasets
-- NOTE: The project assignment suggested manually creating the tables first
--       and then importing the csv's without the header row, but this works as well.
.import --csv ./person.csv person
.import --csv ./teacher.csv teacher
.mode column

-- Create a students view for convenience
CREATE VIEW student_view
AS
SELECT person_id, full_name
FROM person
WHERE person_id NOT IN (
  SELECT DISTINCT person_id FROM teacher
);

-- List first 5 student by full name
SELECT * FROM student_view ORDER BY full_name LIMIT 5;

-- Count total number of students
SELECT COUNT(person_id) FROM student_view;
