###We are creating a table so that we work on it not on the original table or raw table

DELIMITER $$
DROP procedure if exists copy_and_clean_data;
Create procedure copy_and_clean_data()
Begin
 CREATE TABLE IF NOT EXISTS `ushouseholdincome_auto_cleaned` (
  `row_id` int DEFAULT NULL,
  `id` int DEFAULT NULL,
  `State_Code` int DEFAULT NULL,
  `State_Name` text,
  `State_ab` text,
  `County` text,
  `City` text,
  `Place` text,
  `Type` text,
  `Primary` text,
  `Zip_Code` int DEFAULT NULL,
  `Area_Code` int DEFAULT NULL,
  `ALand` int DEFAULT NULL,
  `AWater` int DEFAULT NULL,
  `Lat` double DEFAULT NULL,
  `Lon` double DEFAULT NULL,
  `Timestamp` Timestamp  DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


### Copy DATA INTO NEWLY CREATED TABLE

INSERT INTO ushouseholdincome_auto_cleaned
SELECT * , current_timestamp()
FROM ushouseholdincome_auto;

## DATA CLEANING STEP 

-- Remove Duplicates
DELETE FROM ushouseholdincome_auto_cleaned 
WHERE 
	row_id IN (
	SELECT row_id
FROM (
	SELECT row_id, id,
		ROW_NUMBER() OVER (
			PARTITION BY id, `Timestamp`
			ORDER BY id, `Timestamp`) AS row_num
	FROM 
		ushouseholdincome_auto_cleaned
) duplicates
WHERE 
	row_num > 1
);

-- Fixing some data quality issues by fixing typos and general standardization
UPDATE ushouseholdincome_auto_cleaned
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE ushouseholdincome_auto_cleaned
SET County = UPPER(County);

UPDATE ushouseholdincome_auto_cleaned
SET City = UPPER(City);

UPDATE ushouseholdincome_auto_cleaned
SET Place = UPPER(Place);

UPDATE ushouseholdincome_auto_cleaned
SET State_Name = UPPER(State_Name);

UPDATE ushouseholdincome_auto_cleaned
SET `Type` = 'CDP'
WHERE `Type` = 'CPD';

UPDATE ushouseholdincome_auto_cleaned
SET `Type` = 'Borough'
WHERE `Type` = 'Boroughs';

END $$
DELIMITER ;

Call copy_and_clean_data ;


-- create event ( now we are creating an event to run )
CREATE EVENT run_data_cleaning
 ON SCHEDULE EVERY 2 MINUTE
 DO CALL copy_and_clean_data() ;
 
-- CReate trigger
DELIMITER $$
CREATE TRIGGER Transfer_clean_data
 AFTER INSERT ON ushouseholdincome_auto
 FOR EACH ROW
BEGIN
CALL copy_and_clean_data();
END $$
 
DELIMITER ;


## NOTE Trigger will not wokr as we create table in call procedure if the table is not created then trigger will work
