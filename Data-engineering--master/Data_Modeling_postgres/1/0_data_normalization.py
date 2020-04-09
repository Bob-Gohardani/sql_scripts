import psycopg2

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
    cur.execute("create table if not exists music_library (album_id int, album_name varchar, artist_name varchar, year int, songs text[]);")
except psycopg2.Error as e:
    print(e)

try:
    cur.execute("insert into music_library (album_id, album_name, artist_name, year, songs) \
                 values (%s, %s, %s, %s, %s)", \
                 (1, "Rubber soul", "the Beatles", 1965, ["michele", "think for yourself"]))
except psycopg2.Error as e:
    print(e)
    
try:
    cur.execute("insert into music_library (album_id, album_name, artist_name, year, songs) \
                 values (%s, %s, %s, %s, %s)", \
                 (2, "Let it be", "the Beatles", 1970, ["Let it be", "Across the universe"]))
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

# 1NF
try:
    cur.execute("create table if not exists music_library_2 (album_id int, album_name varchar, artist_name varchar, year int, song_name text);")
except psycopg2.Error as e:
    print(e)

try:
    cur.execute("insert into music_library_2 (album_id, album_name, artist_name, year, song_name) \
                 values (%s, %s, %s, %s, %s)", \
                 (1, "Rubber soul", "the Beatles", 1965, "michele"))
except psycopg2.Error as e:
    print(e)

try:
    cur.execute("insert into music_library_2 (album_id, album_name, artist_name, year, song_name) \
                 values (%s, %s, %s, %s, %s)", \
                 (1, "Rubber soul", "the Beatles", 1965, "think for yourself"))
except psycopg2.Error as e:
    print(e)
    
try:
    cur.execute("insert into music_library_2 (album_id, album_name, artist_name, year, song_name) \
                 values (%s, %s, %s, %s, %s)", \
                 (2, "Let it be", "the Beatles", 1970, "Let it be"))
except psycopg2.Error as e:
    print(e)

try:
    cur.execute("insert into music_library_2 (album_id, album_name, artist_name, year, song_name) \
                 values (%s, %s, %s, %s, %s)", \
                 (2, "Let it be", "the Beatles", 1970, "Across the universe"))
except psycopg2.Error as e:
    print(e)

try:
    cur.execute("select * from music_library_2")
except psycopg2.Error as e:
    print(e)
    
row = cur.fetchone()
while row:
    print(row)
    row= cur.fetchone()

# 2NF
try: 
    cur.execute("CREATE TABLE IF NOT EXISTS album_library (album_id int, \
                                                           album_name varchar, artist_name varchar, \
                                                           year int);")
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("CREATE TABLE IF NOT EXISTS song_library (song_id int, album_id int, \
                                                          song_name varchar);")
except psycopg2.Error as e: 
    print (e)
    
try: 
    cur.execute("INSERT INTO album_library (album_id, album_name, artist_name, year) \
                 VALUES (%s, %s, %s, %s)", \
                 (1, "Rubber Soul", "The Beatles", 1965))
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("INSERT INTO album_library (album_id, album_name, artist_name, year) \
                 VALUES (%s, %s, %s, %s)", \
                 (2, "Let It Be", "The Beatles", 1970))
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("INSERT INTO song_library (song_id, album_id, song_name) \
                 VALUES (%s, %s, %s)", \
                 (1, 1, "Michelle"))
except psycopg2.Error as e: 
    print (e)
    
try: 
    cur.execute("INSERT INTO song_library (song_id, album_id, song_name) \
                 VALUES (%s, %s, %s)", \
                 (2, 1, "Think For Yourself"))
except psycopg2.Error as e: 
    print (e)
    
try: 
    cur.execute("INSERT INTO song_library (song_id, album_id, song_name) \
                 VALUES (%s, %s, %s)", \
                 (3, 1, "In My Life"))
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("INSERT INTO song_library (song_id, album_id, song_name) \
                 VALUES (%s, %s, %s)", \
                 (4, 2, "Let It Be"))
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("INSERT INTO song_library (song_id, album_id, song_name) \
                 VALUES (%s, %s, %s)", \
                 (5, 2, "Across the Universe"))
except psycopg2.Error as e: 
    print (e)

print("Table: album_library\n")
try: 
    cur.execute("SELECT * FROM album_library;")
except psycopg2.Error as e: 
    print (e)

row = cur.fetchone()
while row:
   print(row)
   row = cur.fetchone()

print("\nTable: song_library\n")
try: 
    cur.execute("SELECT * FROM song_library;")
except psycopg2.Error as e: 
    print (e)
row = cur.fetchone()
while row:
   print(row)
   row = cur.fetchone()

try:
    cur.execute("select * from album_library join song_library on album_library.album_id = song_library.album_id")
except psycopg2.Error as e:
    print(e)

row = cur.fetchone()

while row:
    print(row)
    row = cur.fetchone()

# 3NF
try: 
    cur.execute("CREATE TABLE IF NOT EXISTS album_library2 (album_id int, \
                                                           album_name varchar, artist_id int, \
                                                           year int);")
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("CREATE TABLE IF NOT EXISTS artist_library (artist_id int, \
                                                           artist_name varchar);")
except psycopg2.Error as e: 
    print (e)

    
try: 
    cur.execute("INSERT INTO album_library2 (album_id, album_name, artist_id, year) \
                 VALUES (%s, %s, %s, %s)", \
                 (1, "Rubber Soul", 1, 1965))
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("INSERT INTO album_library2 (album_id, album_name, artist_id, year) \
                 VALUES (%s, %s, %s, %s)", \
                 (2, "Let It Be", 1, 1970))
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("INSERT INTO artist_library (artist_id, artist_name) \
                 VALUES (%s, %s)", \
                 (1, "The Beatles"))
except psycopg2.Error as e: 
    print (e)
    

print("Table: album_library2\n")
try: 
    cur.execute("SELECT * FROM album_library2;")
except psycopg2.Error as e: 
    print (e)

row = cur.fetchone()
while row:
   print(row)
   row = cur.fetchone()

print("\nTable: song_library\n")
try: 
    cur.execute("SELECT * FROM song_library;")
except psycopg2.Error as e: 
    print (e)

row = cur.fetchone()
while row:
   print(row)
   row = cur.fetchone()

#Doublechecking that data is in the table
print("\nTable: artist_library\n")
try: 
    cur.execute("SELECT * FROM artist_library;")
except psycopg2.Error as e: 
    print (e)

row = cur.fetchone()
while row:
   print(row)
   row = cur.fetchone()


try:
    cur.execute("select * from (artist_library join album_library2 on \
                                artist_library.artist_id = album_library2.artist_id) join \
                                song_library on album_library2.album_id = song_library.album_id;")
except psycopg2.Error as e:
    print(e)

row = cur.fetchone()
while row:
   print(row)
   row = cur.fetchone()


try: 
    cur.execute("DROP table music_library")
except psycopg2.Error as e: 
    print (e)
try: 
    cur.execute("DROP table music_library2")
except psycopg2.Error as e: 
    print (e)
try: 
    cur.execute("DROP table album_library")
except psycopg2.Error as e: 

    print (e)
try: 
    cur.execute("DROP table song_library")
except psycopg2.Error as e: 
    print (e)
try: 
    cur.execute("DROP table album_library2")
except psycopg2.Error as e: 
    print (e)
try: 
    cur.execute("DROP table artist_library")
except psycopg2.Error as e: 
    print (e)

cur.close()
conn.close()