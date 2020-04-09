import psycopg2

try:
    conn = psycopg2.connect("user=postgres dbname=parch")
except psycopg2.Error as e:
    print("Error connecting to db")
    print(e)

try:
    cur = conn.cursor()
except psycopg2.Error as e:
    print("can't get a cursor to db")
    print(e)

conn.set_session(autocommit=True)

try:
    cur.execute("select * from udacity.music_library")
except psycopg2.Error as e:
    print(e)

try:
    cur.execute("create database udacity")
except psycopg2.Error as e:
    print(e)

try:
    conn.close()
except psycopg2.Error as e:
    print(e)

try:
    conn = psycopg2.connect("user=postgres dbname=udacity")
except psycopg2.Error as e:
    print("Error connecting to db")
    print(e)

try:
    cur = conn.cursor()
except psycopg2.Error as e:
    print("can't get a cursor to db")
    print(e)

conn.set_session(autocommit=True)

try:
    cur.execute("create table if not exists music_library (album_name varchar, artist_name varchar, year int);")
except psycopg2.Error as e:
    print(e)

try:
    cur.execute("select count(*) from music_library")
except psycopg2.Error as e:
    print(e)
    
print(cur.fetchall())

try:
    cur.execute("insert into music_library (album_name, artist_name, year) \
                 values (%s, %s, %s)", \
                 ("Rubber Soul", "the Beatles", 1965))
except psycopg2.Error as e:
    print(e)
    
try:
    cur.execute("insert into music_library (album_name, artist_name, year) \
                 values (%s, %s, %s)", \
                 ("let it be", "the Beatles", 1970))
except psycopg2.Error as e:
    print(e)

try:
    cur.execute("select * from music_library")
except psycopg2.Error as e:
    print(e)
    
row = cur.fetchone()
while row:
    print(row)
    row= cur.fetchone()

try:
    cur.execute("drop table music_library")
except psycopg2.Error as e:
    print(e)

cur.close()
conn.close()