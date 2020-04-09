import psycopg2

try:
    conn = psycopg2.connect("user=postgres")
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
    cur.execute("create table if not exists songs (song_title varchar, artist_name varchar, year int, single Boolean);")
except psycopg2.Error as e:
    print(e)


try:
    cur.execute("insert into songs (song_title, artist_name, year, single) \
                 values (%s, %s, %s, %s)", \
                 ("Kooda", "Tekashi69", 2017, False))
except psycopg2.Error as e:
    print(e)
    
try:
    cur.execute("insert into songs (song_title, artist_name, year, single) \
                 values (%s, %s, %s, %s)", \
                 ("still dre", "dr.dre", 2001, False))
except psycopg2.Error as e:
    print(e)


try:
    cur.execute("select * from songs")
except psycopg2.Error as e:
    print(e)
    
row = cur.fetchone()
while row:
    print(row)
    row= cur.fetchone()

cur.close()
conn.close()