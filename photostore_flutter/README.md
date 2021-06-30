# Photostore Flutter App

The Photostore flutter app main purpose is to act the client-side of a self-hosted backup strategy for all mobile
devices (Android and iOS). When running on a mobile device, the app has the ability to back up all photos, videos and
albums to a central, self-hosted server. The app also provides the ability to browse/download photos stored on the
configured server.

The Photostore flutter app can also be compiled to a webapp (which is then packaged/served up by the Photostore API).
The webapp version of Photostore flutter allows users to simply browse and download all photos on the server.

## Local Development

Photostore is built using the flutter framework. Before attempting to compile the app locally, please make sure you have
the full flutter SDK/toolset installed on your computer.

Use the below instructions to run Photostore Flutter using the iOS Simulator.

```bash

# download all dependencies
flutter pub get

# open iOS Simulator (android can be used instead)
open -a Simulator

# compile and run the flutter app in the iOS simulator
flutter run

```

Below are instructions for running the webapp version

```bash
# download all dependencies
flutter pub get


# compile and run the flutter app as a webapp
flutter run -d chrome

```

The above commands will start Photostore in livereload mode and chrome instance will launch with the webapp loaded.
However, (:warning:) API requests to the server will not work correctly using the launched instance of google Chrome.
The CORS protection will prevent cross-domain communication. As a result, all of the HTTP API calls will be blocked.

In order to temporarily circumvent the CORS security protection while developing, I run the following command to start
chrome in Insecure Mode (disabling cross origin protection).

```bash

# open chrome in insecure mode
open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security


# copy the url from the original chrome window to the insecure chrome window
# IE: http://localhost:50911/#/ (the port number may vary)
```

## Building a release version of the Photostore webapp

In order to build new code changes made to the webapp and package them into the Photostore API
(so that they can be served up as static assets by the Photostore API server) run the following command to compile the
Photostore webapp and copy the assets to the Photostore API codebase

```bash
# build the webapp and copy the results to Photostore API codebase
./buildWeb.sh

```

Now you can follow the instructions in : [photostore_fastapi:README.md](../photostore_fastapi/README.md) to build a new
version of the Photostore API, which will now include the new webapp.

## Building a release version of the Photostore iOS app
```bash
flutter build ipa
```

## Building a release version of the Photostore Android app
```bash
#use bundletool cli to produce APKs
flutter build appbundle

```

## Additional helpful commands

```bash
# start flutter development tools
flutter pub global run devtools
# generate mobile images/icons
flutter pub run flutter_launcher_icons:main
# establish app name
flutter pub run flutter_launcher_name:main
```


