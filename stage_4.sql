-- Cleanup
DROP TABLE IF EXISTS "person";
DROP TABLE IF EXISTS "teacher";
DROP TABLE IF EXISTS "student";
DROP TABLE IF EXISTS "score1";
DROP TABLE IF EXISTS "score2";
DROP TABLE IF EXISTS "score3";

-- Create Tables
CREATE TABLE IF NOT EXISTS "person"(
  "person_id" TEXT,
  "full_name" TEXT,
  "address" TEXT,
  "building_number" TEXT,
  "phone_number" TEXT
);

CREATE TABLE IF NOT EXISTS "teacher"(
  "person_id" TEXT,
  "class_code" TEXT
);

CREATE TABLE student (
    person_id VARCHAR(9) PRIMARY KEY,
    grade_code TEXT
);

CREATE TABLE score1 (
    person_id VARCHAR(9) PRIMARY KEY,
    score INTEGER
);

CREATE TABLE score2 (
    person_id VARCHAR(9) PRIMARY KEY,
    score INTEGER
);

CREATE TABLE score3 (
    person_id VARCHAR(9) PRIMARY KEY,
    score INTEGER
);

-- Import data from provided datasets
-- NOTE: The project assignment suggested manually creating the tables first
--       and then importing the csv's without the header row, but this works as well.
.import --skip 1 --csv ./person.csv person
.import --skip 1 --csv ./teacher.csv teacher
.import --skip 1 --csv ./score1.csv score1
.import --skip 1 --csv ./score2.csv score2
.import --skip 1 --csv ./score3.csv score3
.mode column

-- Initialize the student grades table with the students person_ids
INSERT INTO student (person_id)
SELECT person_id
FROM person
WHERE person_id NOT IN (
  SELECT DISTINCT person_id FROM teacher
);

-- Print the unified table of all scores
SELECT person_id, score FROM score1
UNION ALL
SELECT person_id, score FROM score2
UNION ALL
SELECT person_id, score FROM score3
;

