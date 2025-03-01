FROM python:3.12-slim

WORKDIR /app

# copy requirements file to the container
COPY requirements.txt ./ 

# install necessary packages
RUN pip install -r requirements.txt

# copy application code
COPY ./app.py . 

# expose the port the app runs on
EXPOSE 5000

# command to run the application
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"] 