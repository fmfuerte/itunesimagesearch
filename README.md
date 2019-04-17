# itunesmoviessearch

A simple iTunes movie serach project made with Flutter.

The following dependencies are used (this can be found in the pubspec.yaml file along with other assets): 
http: ^0.12.0
path_provider: ^0.5.0+1
cached_network_image:^0.7.0

Description:
The app gets JSON from the iTunes Search API, it will then save it as a JSON file to the local directory for offline access

Images are then loaded using cachednetworkimage which will save the images to cache for easy loading and offline availability

The default search for first-time launch is https://itunes.apple.com/search?term=star&amp;country=au&amp;media=movie

However, the user can change this by using the search function at header, this will also save and overwrite the current search term to update persistence


