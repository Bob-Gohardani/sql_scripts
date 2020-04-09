# DROP TABLES

songplay_table_drop = "DROP TABLE IF EXISTS songplays"
user_table_drop = "DROP TABLE IF EXISTS users"
song_table_drop = "DROP TABLE IF EXISTS songs"
artist_table_drop = "DROP TABLE IF EXISTS artists"
time_table_drop = "DROP TABLE IF EXISTS time"

# CREATE TABLES
# either have song_id, artist_id empty or with you fill them, they should reference real value in dimension tables
songplay_table_create = ("""create table if not exists songplays 
                            (songplay_id SERIAL not null primary key, 
                             start_time bigint not null REFERENCES time(start_time),
                             user_id int not null REFERENCES users(user_id),
                             level varchar,
                             song_id varchar REFERENCES songs(song_id),
                             artist_id varchar REFERENCES artists(artist_id),
                             session_id int,
                             location varchar,
                             user_agent text)""")

user_table_create = ("""create table if not exists users 
                        (user_id int not null primary key,
                         first_name varchar,
                         last_name varchar,
                         gender varchar CHECK (gender IN ('M', 'F')),
                         level varchar CHECK (level IN ('free', 'paid')))""")

song_table_create = ("""create table if not exists songs 
                        (song_id varchar not null primary key,
                         title varchar,
                         artist_id varchar not null,
                         year int,
                         duration float)""")

artist_table_create = ("""create table if not exists artists 
                          (artist_id varchar not null primary key,
                           name varchar not null unique,
                           location text,
                           latitude text,
                           longitude text)""")

time_table_create = ("""create table if not exists time
                        (start_time bigint primary key,
                        hour int,
                        day int,
                        week int,
                        month int,
                        year int,
                        weekday int)""")

# INSERT RECORDS
songplay_table_insert = ("""INSERT INTO songplays(start_time, user_id,level,artist_id,song_id, session_id, location, user_agent)
                            VALUES(%s, %s, %s, %s, %s, %s, %s, %s)""")

user_table_insert = ("""insert into users (user_id ,first_name, last_name, gender, level) values (%s, %s, %s, %s, %s) 
on conflict (user_id) do NOTHING""")

song_table_insert = ("""insert into songs (song_id, title, artist_id, year, duration) values (%s, %s, %s, %s, %s) 
ON CONFLICT (song_id) DO NOTHING""")

artist_table_insert = ("""insert into artists (artist_id, name, location, latitude, longitude) values (%s, %s, %s, %s, %s) 
ON CONFLICT (artist_id) DO NOTHING""")


time_table_insert = ("""insert into time (start_time, hour, day, week, month, year, weekday) values (%s, %s, %s, %s, %s, %s, %s)
ON CONFLICT (start_time) DO NOTHING""")

# FIND SONGS
# here we do a join because we need to put in a row : song_id and artist_id related to that song
song_select = ("""SELECT songs.song_id, artists.artist_id FROM songs 
                  JOIN artists ON  songs.artist_id=artists.artist_id
                  WHERE songs.title=%s AND artists.name=%s AND songs.duration=%s;""")

# QUERY LISTS

create_table_queries = [songplay_table_create, user_table_create, song_table_create, artist_table_create, time_table_create]
drop_table_queries = [songplay_table_drop, user_table_drop, song_table_drop, artist_table_drop, time_table_drop]