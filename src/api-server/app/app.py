# src/api/app.py

from flask import Flask, jsonify
from flask_cors import CORS
from pymongo import MongoClient
import logging
import os

app = Flask(__name__)
CORS(app)
DATABASE_URL = os.getenv('MONGO_URI', 'mongodb://mongo:27017/')
DATABASE_NAME = 'visitorCounterDB'
COLLECTION_NAME = 'visitors'

logging.basicConfig(filename='app.log', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

logger.info(f'Connecting to the Mongo DB: executing MongoClient({DATABASE_URL})...')
client = MongoClient(DATABASE_URL)
logger.info(f'Creating a DB: executing client[{DATABASE_NAME}]...')
db = client[DATABASE_NAME]
logger.info(f'Creating a collection: executing db[{COLLECTION_NAME}]...')
collection = db[COLLECTION_NAME]

logger.info('Database, DB, and collection have been created. Initializing visitor coutner...')

if collection.count_documents({}) == 0:
	logger.info('Collection is empty. Inserting initial visitor counter document...')
	collection.insert_one({'count': 0})

@app.route('/api/visit', methods=['GET'])
def visit():
	"""
	Handle GET requests to increment visitor counter and return the updated counter.
	"""
	logger.info('GET request has been received on the /api/visit endpoint. Processing request...')
	logger.info('Incrementing visitor counter...')
	try:
		collection.update_one({}, {'$inc': {'count': 1}}, upsert=True)
		logger.info('collection.update_one() executed...')
		count = collection.find_one({})['count']
		logger.info('count = collection.find_one({})[count] executed...')
		logger.info(f'Visitor count incremented to: count = {count}')	
		if count is not None:
			logger.info(f'Visitor counter updated and retrieved successfully.')
			return jsonify({'visitor_counter': count}), 200
		else:
			logger.error(f'Error retrieving visitor coutner: visitor counter is None')
			return jsonify({'error': 'Failed to retrieve visitor counter.'}), 500
	except Exception as e:
		logger.error(f'Error incrementing visitor coutner: {e}')
		return jsonify({'error': 'Failed to increment visitor counter.'}), 500


@app.route('/api/fetch', methods=['GET'])
def fetch_counter():
	"""
	Only return the current visitor counter.
	"""
	try:
		logger.info('GET request has been received on the /api/fetch endpoint. Processing request...')
		logger.info('Fetching visitor counter...')
		count = collection.find_one({})['count']
		logger.info('count = collection.find_one({})[count] executed...')
		logger.info(f'Visitor counter value retrieved: count = {count}')
		if count is not None:
			logger.info(f'Visitor counter retrieved successfully.')
			return jsonify({'visitor_counter': count}), 200
		else:
			logger.error(f'Error retrieving visitor coutner: visitor counter is None')
			return jsonify({'error': 'Failed to retrieve visitor counter.'}), 500
	except Exception as e:
		logger.error(f'Error fetching visitor coutner: {e}')
		return jsonify({'error': 'Failed to fetch visitor counter'}), 500


if __name__ == '__main__':
    logger.info('Starting API server...')
    app.run(host='0.0.0.0', port=5000, debug=True)  # Run the server
