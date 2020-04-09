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
    { 'class' : 'SimpleStrategy', 'replication_factor' : 1}
    """)
except Exception as e:
    print(e)


try:
    session.set_keyspace('udacity')
except Exception as e:
    print(e)


query = "create table if not exists music_library"
query = query + "(year int, artist_name text, album_name text, primary key (year, artist_name))"
try:
    session.execute(query)
except Exception as e:
    print(e)


query = "create table if not exists artist_library"
query = query + "( artist_name text,year int, album_name text, primary key (artist_name, year))"
try:
    session.execute(query)
except Exception as e:
    print(e)

query = "insert into music_library (year, artist_name, album_name)"
query = query + "values (%s, %s, %s)"

query1 = "insert into artist_library (artist_name, year, album_name)"
query1 = query1 + "values (%s, %s, %s)"

try:
    session.execute(query, (1970, "the beatles", "let it be"))
except Exception as e:
    print(e)

try:
    session.execute(query, (1965, "the beatles", "rubber soul"))
except Exception as e:
    print(e)

try:
    session.execute(query, (1965, "the who", "my generation"))
except Exception as e:
    print(e)

try:
    session.execute(query1, ("the beatles", 1970, "let it be"))
except Exception as e:
    print(e)

try:
    session.execute(query1, ("the beatles", 1965, "rubber soul"))
except Exception as e:
    print(e)

try:
    session.execute(query1, ("the who", 1965, "my generation"))
except Exception as e:
    print(e)


query = "select * from music_library where year=1970"
try:
    rows = session.execute(query)
except Exception as e:
    print(e)

for row in rows:
    print(row.year, row.artist_name, row.album_name)


query = "select * from artist_library where artist_name='the beatles'"
try:
    rows = session.execute(query)
except Exception as e:
    print(e)

for row in rows:
    print(row.artist_name, row.year, row.album_name)


query = "drop table if exists music_library"
try:
    session.execute(query)
except Exception as e:
    print(e)

query = "drop table if exists artist_library"
try:
    session.execute(query)
except Exception as e:
    print(e)


session.shutdown()
cluster.shutdown()