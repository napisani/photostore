# Photostore

Photostore is a self-hosted, client-server solution for backing up, viewing and downloading photos. 


## How it works

The Photostore API (written in Python/FastAPI) is deployed to a server/computer of your choice. 
Photostore API can run natively via Python 3 or, preferably, as a docker container (or kubernetes deployment). 

Details about how to run the Photostore API server can be found in this: [photostore_fastapi:README.md](photostore_fastapi/README.md) 

The Photostore mobile app is a Flutter applicaiton that is built to run on both Android and iOS. Within these mobile apps, 
the user has the ability to configure the server details required to communicate with the Photostore API.
IE: Hostname/Server IP, Protocol, API Key (optional) etc.

Once the API Server and mobile apps are configured - the mobile app will be able to backup photos 
to the server and view all of the photos that are currently stored out on the server.


## Licensing

This project is currently independently developed and licensed under the GPLv3 License.

#TODO
links to the app store 
screenshots
links to video