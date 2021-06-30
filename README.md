# Photostore

Photostore is a self-hosted, client-server solution for backing up, viewing and downloading photos. 


## How it works

The Photostore API (written in Python/FastAPI) is deployed to a server/computer of your choice. 
Photostore API can run natively via Python 3 or, preferably, as a docker container (or kubernetes deployment). 

Details about how to run the Photostore API server can be found in this: [photostore_fastapi:readme.md](photostore_fastapi/README.md) 

The Photostore mobile app is a Flutter applicaiton that is built to run on both Android and iOS. Within these mobile apps, 
the user has the ability to configure the server details required to communicate with the Photostore API.
IE: Hostname/Server IP, Protocol, API Key (optional) etc.

Details about how to build and install the the Photostore mobile app can be found in this: [photostore_flutter:README.md](photostore_flutter/README.md) 


Once the API Server and mobile apps are configured - the mobile app will be able to backup photos 
to the server and view all of the photos that are currently stored out on the server.


## Licensing

This project is currently independently developed and licensed under the GPLv3 License.

## Screenshots
![](screenshots/screenshot_1.png?raw=true)
![](screenshots/filters_1.png?raw=true)
![](screenshots/screenshot_2.png?raw=true)
![](screenshots/server_screen_1.png?raw=true)
![](screenshots/webapp1.png?raw=true)
