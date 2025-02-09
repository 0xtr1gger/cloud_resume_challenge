# src/api/app.py

from flask import Flask, jsonify
from flask_cors import CORS
import sqlite3
from sqlite3 import Error

app = Flask(__name__) # create an application
CORS(app) # enable CORS for all routes
DATABASE = 'visitor_counter.db' # name for the database file

def create_connection():
    """
    Create a database connection to the SQLite database. 
    """
    conn = None
    try:
        conn = sqlite3.connect(DATABASE)
        return conn
    except Error as e:
        print(f'Database connection error: {e}')
    return conn

def init_db():
	"""
	Initialize the database and create the visitor table.
	"""
	try:
		conn = create_connection()
		cursor = conn.cursor()

		create_table_query = 'CREATE TABLE IF NOT EXISTS visitors (id INTEGER PRIMARY KEY AUTOINCREMENT, count INTEGER)'
		cursor.execute(create_table_query)

		insert_initial_value_query = 'INSERT INTO visitors (count) VALUES (0);'
		cursor.execute(insert_initial_value_query)

		conn.commit()
	except Error as e:
		print(f'Error initializing database: {e}')
	finally:
		if conn:
			conn.close

def increment_visitor_counter():
	"""
	Increment the visitor counter and return the updated value.
	"""
	try:
		conn = create_connection()
		cursor = conn.cursor()

		# increment visitor count
		update_query = 'UPDATE visitors SET count = count + 1'
		cursor.execute(update_query)

		conn.commit() # applying changes

		# retrieve the updated visitor count
		retrieve_query = 'SELECT count FROM visitors;'
		cursor.execute(retrieve_query)
		counter = cursor.fetchone()[0]  # fetch the counter value

		return counter

	except Error as e:
		print(f"Error updating visitor counter: {e}")
		return None

	finally:
		if conn:
			conn.close()


def fetch_visitor_counter():
	"""
	Retrieve the current value of the visitor counter from the database.
	"""
	try:
		conn = create_connection()
		cursor = conn.cursor()

		# retrieve the current value of the counter
		retrieve_query = 'SELECT count FROM visitors;'
		cursor.execute(retrieve_query)
		counter = cursor.fetchone()[0]  # fetch the counter value

		return counter

	except Error as e:
		print(f'Error fetching visitor counter: {e}')
		return None

	finally:
		if conn:
			conn.close()


@app.route('/api/visit', methods=['GET'])
def visit():
	"""
	Handle GET requests to increment visitor counter and return the updated counter.
	"""
	counter = increment_visitor_counter()
	if counter is not None:
		return jsonify({'visitor_counter': counter}), 200
	else:
		return jsonify({'error': 'Failed to retrieve visitor counter'}), 500

@app.route('/api/fetch', methods=['GET'])
def fetch_counter():
	"""
	Only return the current visitor counter.
	"""
	counter = fetch_visitor_counter()
	if counter is not None:
		return jsonify({'visitor_counter': counter}), 200
	else:
		return jsonify({'error': 'Failed to retrieve visitor counter'}), 500
	

if __name__ == '__main__':
	init_db()  # initialize the DB
	app.run(host='0.0.0.0', port=5000)  # run the server
	