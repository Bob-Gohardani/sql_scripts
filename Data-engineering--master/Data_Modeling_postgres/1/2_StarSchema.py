import psycopg2

try:
    conn = psycopg2.connect("user=postgres dbname=udacity")
except psycopg2.Error as e:
    print(e)

try:
    cur = conn.cursor()
except psycopg2.Error as e:
    print(e)

conn.set_session(autocommit=True)

# fact table
try: 
    cur.execute("create table if not exists customer_transactions (customer_id int, store_id int, spent numeric);")
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("insert into customer_transactions (customer_id, store_id, spent) values (%s, %s, %s)", (1, 1, 20.5))
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("insert into customer_transactions (customer_id, store_id, spent) values (%s, %s, %s)", (2, 1, 35.21))
except psycopg2.Error as e: 
    print (e)


# dimension tables
try: 
    cur.execute("create table if not exists items_purchased (customer_id int, item_number int, item_name varchar);")
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("INSERT INTO items_purchased (customer_id, item_number, item_name) VALUES (%s, %s, %s)", (1, 1, "Rubber Soul"))
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("INSERT INTO items_purchased (customer_id, item_number, item_name) VALUES (%s, %s, %s)", (2, 3, "Let It Be"))
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("create table if not exists store (store_id int, state varchar);")
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("INSERT INTO store (store_id, state) VALUES (%s, %s)", (1, "CA"))
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("INSERT INTO store (store_id, state) VALUES (%s, %s)", (2, "WA"))
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("create table if not exists customer (customer_id int, name varchar, rewards boolean);")
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("INSERT INTO customer (customer_id, name, rewards) VALUES (%s, %s, %s)", (1, "Amanda", True))
except psycopg2.Error as e: 
    print (e)

try: 
    cur.execute("INSERT INTO customer (customer_id, name, rewards) VALUES (%s, %s, %s)", (2, "Toby", False))
except psycopg2.Error as e: 
    print (e)

# query 1
try:
    cur.execute("select name, item_name, rewards from ((customer_transactions join customer on customer.customer_id = customer_transactions.customer_id) \
                 join items_purchased on customer_transactions.customer_id = items_purchased.customer_id) where spent > 30 ;")
except psycopg2.Error as e:
    print(e)

row = cur.fetchone()
while row:
    print(row)
    row = cur.fetchone()

# query 2
try:
    cur.execute("select store_id, sum(spent) from customer_transactions where store_id=1 group by store_id")
except psycopg2.Error as e:
    print(e)

row = cur.fetchone()
print(row)

cur.execute("DROP table customer_transactions")
cur.execute("DROP table customer")
cur.execute("DROP table items_purchased")
cur.execute("DROP table store")

cur.close()
conn.close()