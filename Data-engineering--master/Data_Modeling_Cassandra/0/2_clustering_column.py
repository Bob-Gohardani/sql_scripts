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


# give me every album in my music library that was relased by an artist with album name in DESC order
# partition key : artist_name
# clusting columns : album_name, city    || the resulting query will be ordered based on clustering columns
query = "create table if not exists music_library"
query = query + "(year int, artist_name text, album_name text, city text, primary key (artist_name, album_name, city))"

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
    session.execute(query, (1964, "The Beatles", "Beatles For Sale", "London"))
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


# here we don't mention the order specifically, it is done based on clustering columns
query = "select * from music_library WHERE ARTIST_NAME='The Beatles'"
try:
    rows = session.execute(query)
except Exception as e:
    print(e)
    
for row in rows:
    print (row.artist_name, row.album_name, row.city, row.year)


# normally this query will result in error, because year is not the partion key and it may need to retrive data from all nodes!!
query = "select * from music_library WHERE year=1965"
try:
    rows = session.execute(query)
except Exception as e:
    print(e)
    
for row in rows:
    print (row.artist_name, row.album_name, row.city, row.year)


query = "drop table music_library"
try:
    session.execute(query)
except Exception as e:
    print(e)


session.shutdown()
cluster.shutdown()

