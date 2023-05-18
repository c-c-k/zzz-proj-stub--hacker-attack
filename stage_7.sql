-- Cleanup
DROP TABLE IF EXISTS "person";
DROP TABLE IF EXISTS "teacher";
DROP TABLE IF EXISTS "student";
DROP TABLE IF EXISTS "score";
DROP TABLE IF EXISTS "score1";
DROP TABLE IF EXISTS "score2";
DROP TABLE IF EXISTS "score3";
DROP VIEW IF EXISTS "gd12_averages_view";

-- Create Tables
CREATE TABLE "person"(
  "person_id" TEXT,
  "full_name" TEXT,
  "address" TEXT,
  "building_number" TEXT,
  "phone_number" TEXT
);

CREATE TABLE "teacher"(
  "person_id" TEXT,
  "class_code" TEXT,
  FOREIGN KEY ("person_id") 
    REFERENCES person ("person_id") 
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE "student" (
  "person_id" VARCHAR(9) PRIMARY KEY,
  "grade_code" TEXT,
  FOREIGN KEY ("person_id") 
    REFERENCES "person" ("person_id") 
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE "score" (
  "person_id" VARCHAR(9),
  "score" INTEGER,
  FOREIGN KEY ("person_id") 
    REFERENCES "person" ("person_id") 
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE "score1" (
  "person_id" VARCHAR(9) PRIMARY KEY,
  "score" INTEGER
);

CREATE TABLE "score2" (
  "person_id" VARCHAR(9) PRIMARY KEY,
  "score" INTEGER
);

CREATE TABLE "score3" (
  "person_id" VARCHAR(9) PRIMARY KEY,
  "score" INTEGER
);

-- Import data from provided datasets
-- NOTE: The project assignment suggested manually creating the tables first
--       and then importing the csv's without the header row, but this works as well.
.mode csv
.import --skip 1 ./person.csv person
.import --skip 1 ./teacher.csv teacher
.import --skip 1 ./score1.csv score1
.import --skip 1 ./score2.csv score2
.import --skip 1 ./score3.csv score3
.mode column

-- Initialize the student grades table with the students person_ids
INSERT INTO "student" ("person_id")
SELECT "person_id"
FROM "person"
WHERE "person_id" NOT IN (
  SELECT DISTINCT "person_id" FROM "teacher"
);

-- Fill the unified table of all scores
INSERT INTO "score" ("person_id", "score")
SELECT "person_id", "score" FROM "score1"
UNION ALL
SELECT "person_id", "score" FROM "score2"
UNION ALL
SELECT "person_id", "score" FROM "score3"
;

-- Drop the intermediary score tables
DROP TABLE IF EXISTS "score1";
DROP TABLE IF EXISTS "score2";
DROP TABLE IF EXISTS "score3";

-- Fill in grade codes
UPDATE "student"
SET "grade_code" = "GD-09"
WHERE "person_id" NOT IN (
    SELECT DISTINCT "person_id"
    FROM "score"
);

UPDATE "student"
SET "grade_code" = "GD-10"
WHERE "person_id" IN (
    SELECT "person_id"
    FROM "score"
    GROUP BY "person_id"
    HAVING count("score") = 1
);

UPDATE "student"
SET "grade_code" = "GD-11"
WHERE "person_id" IN (
    SELECT "person_id"
    FROM "score"
    GROUP BY "person_id"
    HAVING count("score") = 2
);

UPDATE "student"
SET "grade_code" = "GD-12"
WHERE "person_id" IN (
    SELECT "person_id"
    FROM "score"
    GROUP BY "person_id"
    HAVING count("score") = 3
);

-- Create 12'th graders score average view
CREATE VIEW "gd12_averages_view" (
  "person_id", "avg_score"
)
AS
SELECT "person_id", round(avg("score"), 2)
FROM "student"
INNER JOIN "score" USING ("person_id")
GROUP BY "person_id"
HAVING "grade_code" = "GD-12"
;

-- Print 12'th graders score average view
SELECT * FROM "gd12_averages_view"
ORDER BY "avg_score" DESC;
