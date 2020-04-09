import psycopg2

conn = psycopg2.connect("dbname=sparkifydb user=postgres")
conn.set_session(autocommit=True)
cur = conn.cursor()

def run_query(cur, query):
    try:
        cur.execute(query)
        print(cur.fetchall())
    except psycopg2.Error as e:
        print(e)


# test creation of the tables
run_query(cur, "SELECT * FROM songplays LIMIT 5;")
run_query(cur, "SELECT * FROM users LIMIT 5")
run_query(cur, "SELECT * FROM songs LIMIT 5")
run_query(cur, "SELECT * FROM artists LIMIT 5")
run_query(cur, "SELECT * FROM time LIMIT 5")