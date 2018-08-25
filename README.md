# TruDocPhotos

This application is an example of searching the Flickr API for photos in Objective-c

### Getting Started

- Clone the repo and   install  pod 'SDWebImage'.  
- run TruDocPhotos.xcworkspace

### The Flickr API
reference https://www.flickr.com/services/api/ 

Photos are retrieved by hitting the [Flickr API](https://www.flickr.com/services/api/flickr.photos.search.html).
- Search Path: https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=FLICKR_API_KEY&tags=SEARCH_TEXT&per_page=10&page=1&format=json&nojsoncallback=1
- Response object is All photos according for searchtext.


- Get Info Path: https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=FLICKR_API_KEY&photo_id=POTO_ID&format=json&nojsoncallback=1
- Response object is the Description about photo.

We use the farm, server, id, and secret to get Larger  image path.

- Image Path:"https://farmFARM.staticflickr.com/SERVER/PHOTOIDSERVER.jpg",  [_flickrPhoto farm],[_flickrPhoto server] ,[_flickrPhoto photoId], [_flickrPhoto secret]
- Response object  contain larger photo.


