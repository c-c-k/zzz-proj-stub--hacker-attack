.restore /dev/shm/temp.db.backup
.import --csv ./person.csv person
.mode column

SELECT person_id, full_name
FROM person
ORDER BY person_id
LIMIT 5
;
