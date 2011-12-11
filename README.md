This is the Facebook plugin for [SiriProxy](https://github.com/shabbirv/SiriProxy-Facebookstatus). Please follow the instructions in the config-info.yml file.


# Setup

1. Copy the contents of `config-info.yml` into your `~/.siriproxy/config.yml`
2. Fill in the required auth info (See below)
3. restart SiriProxy

# Usage
**Say:** Facebook status *message*

It will ask if you want to post to Facebook

# Obtaining auth info

To get your access_token and username use the link below.

https://graph.facebook.com/oauth/authorize?type=user_agent&client_id=324246447603930&redirect_uri=http%3A%2F%2Fshabz.co%2Faccess_token.html&scope=publish_stream

^^ Once you click the link you will be prompted to login and allow for publishing permissions. Once you have accepted that you will be redirected to http://shabz.co/access_token.html

The link will look something like this: 
http://shabz.co/access_token.html#access_token=*YOU WILL COPY WHAT YOU SEE HERE*&expires_in=5959&code=*THIS PART IS IRRELEVANT*

Your username is what you see at the end of your Facebook link, for instance mine is http://facebook.com/shabbirv

None of your information is stored or shared. If you know how to set up your own Facebook app feel free to do so and get a access_token from there.