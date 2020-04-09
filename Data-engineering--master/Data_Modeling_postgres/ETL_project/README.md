In this project we explored the given data (in the json format) and created a database with star schema imcluding one fact table and four dimension tables.

The fact table is called "songplays" and included the data from the log file about records played.
the four other tables are named users, songs, artists, time. last table is an extention of the fact table with exact timing of each song that was played.

sql_queries.py is a script containing all the sql queries used in the project.

create_tables.py is the script using the previous file to delete and create tables in the database.

etl.py is the main file for Extract Transform Load from json files into postgres database and python notebook with same name does the same operations but only on a single song / log file.


