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
This license gives the public the right to download, compile, manipulate and distribute the application freely. 
However, I have submitted the Apps to the Apple App Store and the Google Play Store as paid apps (one-time fee, no in app purchase).

If you plan to use the app as it exists (including future updates), in other words - without making personalized changes, 
I would like to encourage to you please support the Photostore by purchasing the app directly from the respective app store marketplace.
Also, I would like to kindly request that folks refrain from submitting these apps as to the App Store or Google Play Store as their own.

#TODO
links to the app store 
screen shots
links to video