import psycopg2

conn = psycopg2.connect("user=postgres dbname=parch")
cur = conn.cursor()

conn.set_session(autocommit=True)
cur.execute("create table test123 (col1 int, col2 int, col3 int);")
cur.execute("select * from test123")

cur.execute("select count(*) from test123")
print(cur.fetchall())

cur.execute("drop table test123")