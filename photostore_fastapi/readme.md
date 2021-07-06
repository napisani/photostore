# Photostore API

This is an API used for backing up, viewing and downloading photos and albums.
This API serves as the backend for the Photosore Flutter app. 


## Setting up API configuration (.env file)
The .env file specifies all necessary environment variables / external app configuration.

If the app is running natively using python (not in a docker container), then the env file should be named ".env"

If the app is running within a docker container, the env file must be mapped via volume mount to the following location
"/code/.env"

Photostore can be configured to use either SQLite or Postgres as a DB.
```
# the directory where the photos will be stored (device sub directories will be created automatically)
SAVE_PHOTO_DIR=/tmp/photostore

#which DB implementation to use (sqlite or postgres)
DB_TYPE=sqlite
#if DB_TYPE is `sqlite` this property specifies the database file where the data will be persited
SQLITE_FILE=//tmp/photostore.db


# if DB_type is `postgres` - use the following settings to configure the db connection settings
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=photostore
POSTGRES_SERVER=localhost

# Used to configure the photo thumbnail dimensions that will get created upon upload
THUMBNAIL_HEIGHT=500
THUMBNAIL_WIDTH=500

# used to configure the API key required for all requests
API_KEY=abc123

# If running under a docker context, this property should be '/code/photostore_fastapi'.
# Otherwise, project root should full path to the 'photostore_fastapi' project directory 
PROJECT_ROOT=/Users/nick/PycharmProjects/photostore-mono/photostore_fastapi

PROJECT_NAME=photostore
```

## Running Photosore API using source code / python directly
```bash
# set PYTHONPATH to current project directory "./photostore_fastapi"
export PYTHONPATH=`pwd`


# if you have pipenv installed  - install all dependencies using pipenv
pipenv install

# otherwise - pip can be used instead
pip install -r requirements.txt

# Apply SQL
alembic upgrade head

# Start Photostore API
python app/main.py 
```


## Development - Running Unit tests
```bash
export PYTHONPATH=`pwd`

# Apply SQL
alembic upgrade head

#Run tests
pytest  app/tests -s
```


## Development - Generating new SQL Migration files
Alembic is used to manage SQL migrations. SQL migration files can be generated using Alembic by running 
 the following command after modifying the necessary SQLAlchemy models (modules: app.models.*) 
```bash
PYTHONPATH=`pwd` alembic revision --autogenerate -m "init"
```


## Build native binary (experimental)
You can use Nuitka to compile the entire app to a natively executable binary using the following command
```bash
chmod +x ./buildBin.sh
./buildBin.sh
```



## Build docker image and run as a docker container
First, configure .env file (described above), then make sure the volume mount in docker-compose.yml is configured.
Finally, run:
```bash
docker-compose up
```


## Pulling docker image (instead of building from source)
information: https://hub.docker.com/r/napisani/photostore
```bash
# then pull the image
docker pull napisani/photostore:latest
# and run the image using your custom .env file as volume mount and forwarding port 8000 to your localhost
docker run   -p 8000:8000 -v "$(pwd)/.env":"/code/.env"   napisani/photostore:latest
```


## API Endpoints / Documentation
Once the app is running (either natively or via docker)
navigate to [http://localhost:8000/docs](http://localhost:8000/docs)



## Pull pre-built image from docker hub and run
First, configure .env file (described above), then mount the env file to the new container.
```bash
docker pull photostore_fastapi
docker run photostore_fastapi --volume .env:/code/.env --port 8000:8000
```