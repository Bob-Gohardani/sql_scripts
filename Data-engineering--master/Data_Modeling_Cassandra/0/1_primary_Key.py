import cassandra
from cassandra.cluster import Cluster

try:
    cluster = Cluster(['127.0.0.1'])
    session = cluster.connect()
except Exception as e:
    print(e)

try:
    session.execute("""
    create keyspace if not exists udacity
    with replication =
    {'class' : 'SimpleStrategy', 'replication_factor' : 1}
    """)
except Exception as e:
    print(e)

try:
    session.set_keyspace('udacity')
except Exception as e:
    print(e)

# give me every album from my music library where year = 1970

query = "CREATE TABLE IF NOT EXISTS music_library "
# the problem here is that primary key (year) isn't unique therefore data will be over-written
query = query + "(year int, artist_name text, album_name text, city text, PRIMARY KEY (year))"
try:
    session.execute(query)
except Exception as e:
    print(e)


query = "INSERT INTO music_library (year, artist_name, album_name, city)"
query = query + " VALUES (%s, %s, %s, %s)"

try:
    session.execute(query, (1970, "The Beatles", "Let it Be", "Liverpool"))
except Exception as e:
    print(e)
    
try:
    session.execute(query, (1965, "The Beatles", "Rubber Soul", "Oxford"))
except Exception as e:
    print(e)
    
try:
    session.execute(query, (1965, "The Who", "My Generation", "London"))
except Exception as e:
    print(e)

try:
    session.execute(query, (1966, "The Monkees", "The Monkees", "Los Angeles"))
except Exception as e:
    print(e)

try:
    session.execute(query, (1970, "The Carpenters", "Close To You", "San Diego"))
except Exception as e:
    print(e)


query = "select * from music_library WHERE YEAR=1965"
try:
    rows = session.execute(query)
except Exception as e:
    print(e)
    
for row in rows:
    print (row.year, row.artist_name, row.album_name, row.city)

print("-------------")

query = "CREATE TABLE IF NOT EXISTS music_library1 "
# if here a band releases two albums per year, it will  again be over-written
# partition key : year
# clustering column : album_name
query = query + "(year int, artist_name text, album_name text, city text, PRIMARY KEY (year, album_name))"
try:
    session.execute(query)
except Exception as e:
    print(e)

query = "INSERT INTO music_library1 (year, artist_name, album_name, city)"
query = query + " VALUES (%s, %s, %s, %s)"

try:
    session.execute(query, (1970, "The Beatles", "Let it Be", "Liverpool"))
except Exception as e:
    print(e)
    
try:
    session.execute(query, (1965, "The Beatles", "Rubber Soul", "Oxford"))
except Exception as e:
    print(e)
    
try:
    session.execute(query, (1965, "The Who", "My Generation", "London"))
except Exception as e:
    print(e)

try:
    session.execute(query, (1966, "The Monkees", "The Monkees", "Los Angeles"))
except Exception as e:
    print(e)

try:
    session.execute(query, (1970, "The Carpenters", "Close To You", "San Diego"))
except Exception as e:
    print(e)

query = "select * from music_library1 WHERE YEAR=1965"
try:
    rows = session.execute(query)
except Exception as e:
    print(e)
    
for row in rows:
    print (row.year, row.artist_name, row.album_name, row.city)


query = "drop table music_library"
try:
    rows = session.execute(query)
except Exception as e:
    print(e)

query = "drop table music_library1"
try:
    rows = session.execute(query)
except Exception as e:
    print(e)


session.shutdown()
cluster.shutdown()
    