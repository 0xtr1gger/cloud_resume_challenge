# src/api/app.py

from flask import Flask, jsonify
from flask_cors import CORS
import sqlite3
from sqlite3 import Error
import logging

app = Flask(__name__) # create an application
CORS(app) # enable CORS for all routes
DATABASE = 'visitor_counter.db' # name for the database file

logging.basicConfig(filename='app.log', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

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
		if conn is not None:
			cursor = conn.cursor()

			logging.info('Successfully connected to the DB. Creating a new table...')

			create_table_query = 'CREATE TABLE IF NOT EXISTS visitors (id INTEGER PRIMARY KEY AUTOINCREMENT, count INTEGER)'
			cursor.execute(create_table_query)

			insert_initial_value_query = 'INSERT INTO visitors (count) VALUES (0);'
			cursor.execute(insert_initial_value_query)

			conn.commit()
			logging.info('Successfully created and initialized the DB table for the visitor counter.')
		else:
			logging.error(f'init_db(): conn is None: conn={conn}')
	except Error as e:
		logging.error(f'Error initializing database: {e}')
	finally:
		if conn:
			conn.close

def increment_visitor_counter():
	"""
	Increment the visitor counter and return the updated value.
	"""
	try:
		conn = create_connection()
		if conn is not None:
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
		else:
			logging.error(f'init_db(): conn is None: conn={conn}')
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
		if conn is not None:
			cursor = conn.cursor()

			logging.info('Successfully connected to the DB. Retrieving visitor counter value...')

			# retrieve the current value of the counter
			retrieve_query = 'SELECT count FROM visitors;'
			cursor.execute(retrieve_query)
			counter = cursor.fetchone()[0]  # fetch the counter value

			logging.info(f'Visitor counter value retrieved: counter={counter}')
			return counter
		else:
			logging.error(f'init_db(): conn is None: conn={conn}')

	except Error as e:
		logging.error(f'Error fetching visitor counter: {e}')
		return None

	finally:
		if conn:
			conn.close()


@app.route('/api/visit', methods=['GET'])
def visit():
	"""
	Handle GET requests to increment visitor counter and return the updated counter.
	"""
	logging.info(f'GET request has been received to the /api/visit endpoint. Processing request...')
	logging.info(f'Invoking the increment_visitor_counter() function...')
	counter = increment_visitor_counter()
	logging.info(f'Retrieved visitor counter value: {counter}')
	if counter is not None:
		return jsonify({'visitor_counter': counter}), 200
		logging.info(f'Successfully retrieved the visitor counter value: counter={counter}')
	else:
		return jsonify({'error': 'Failed to retrieve visitor counter'}), 500
		logging.error(f'Visitor counter is None: counter={counter}')

@app.route('/api/fetch', methods=['GET'])
def fetch_counter():
	"""
	Only return the current visitor counter.
	"""
	logging.info(f'GET request has been received to the /api/fetch endpoint. Processing request...')
	counter = fetch_visitor_counter()
	if counter is not None:
		return jsonify({'visitor_counter': counter}), 200
	else:
		return jsonify({'error': 'Failed to retrieve visitor counter'}), 500


if __name__ == '__main__':
	init_db()  # initialize the DB
	logging.info('Successfully initialized visitor counter DB.')
	app.run(host='0.0.0.0', port=5000)  # run the server
