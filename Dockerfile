
# Install the base Python image (version 3.6.4)
FROM python:3.6.4

# Create the user that will run the app
RUN adduser --disabled-password --gecos '' ml-api-user

# Set the working directory to the API source code directory
WORKDIR /opt/ml_api

# Specify the URL of an extra PIP index to use for installation
ARG PIP_EXTRA_INDEX_URL

# Set the name of the Flask app to run
ENV FLASK_APP run.py

# Install requirements, including those in the Gemfury repository
ADD ./packages/ml_api /opt/ml_api/
RUN pip install --upgrade pip
RUN pip install -r /opt/ml_api/requirements.txt

# Make the run script executable and set its file group
RUN chmod +x /opt/ml_api/run.sh
RUN chown -R ml-api-user:ml-api-user ./

# Switch to the user that will run the app
USER ml-api-user

# Expose port 5000 for incoming connections
EXPOSE 5000

# Start the Flask app when the container starts
CMD ["bash", "./run.sh"]
