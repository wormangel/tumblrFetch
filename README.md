# tumblrFetch
A simple Sinatra app that given a Tumblr post URL, downloads the original photo for the user. 
It will even zip the photos if it's a photoset! :)

I've created it to be able to use it in a IFTTT recipe (for example, whenever I like a photo in Tumblr, save it to my dropbox). 

You will need to host the app somewhere if you want to do that.

## Pre-requisites
Aside from Ruby itself (teste on Ruby 2.1.1), the following gems are needed:

- [tumblr_client](https://github.com/tumblr/tumblr_client)
- [rubyzip](https://github.com/rubyzip/rubyzip)
- [curb](https://github.com/taf2/curb)
- [sinatra](http://www.sinatrarb.com/)

If you have [RubyGems](https://github.com/rubygems/rubygems), you can install them by typing `gem install <gem_name>`

You also need to obtain a Tumblr API Key to use the script. 
You can register an application and obtain that key by visiting [Tumblr API](http://www.tumblr.com/oauth/register) 

## Configuration
Set an Environment Variable called `TUMBLR_CONSUMER_KEY` with your API consumer key.

## Usage
1- Just execute the script.

`ruby tumblrFetch.rb`

Sinatra will fire and listen to requests (tipically in http://localhost:4567)

2- Open a browser window and access

`http://localhost:4567/tumblrFetch?url=<a_tumblr_post_url>`

Replacing `<a_tumblr_post_url>` with the Tumblr post URL.

3- The browser will download a photo (or a zip containing the photos, if it's a photoset).

## Limitations
It only work for posts with type = 'photo'.
