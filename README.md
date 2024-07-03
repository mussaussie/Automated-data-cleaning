
Project Title: MySQL Data Copy and Clean Procedure

Description:
This MySQL script defines a stored procedure copy_and_clean_data to create a new table ushouseholdincome_auto_cleaned and copy data from ushouseholdincome_auto. It performs data cleaning steps like removing duplicates and standardizing field values. Additionally, it creates an event run_data_cleaning to automate data cleaning at intervals and a trigger Transfer_clean_data to execute the procedure after data insertion.

Features:

Stored Procedure: Defines copy_and_clean_data to create and populate a cleaned table.
Data Cleaning: Removes duplicates and standardizes data fields using SQL queries.
Automation: Implements an event to schedule periodic data cleaning and a trigger to execute cleaning on new data insertion.
Usage:

Setup: Run the script in MySQL to create the procedure, event, and trigger.
Execution: Call copy_and_clean_data() to initiate table creation and data cleaning.
Automation: The run_data_cleaning event ensures regular updates, enhancing data quality and consistency.
Contributing:
Contributions welcome! Fork the repository, submit pull requests, or open issues for improvements, such as adding more data quality checks or enhancing automation features.
