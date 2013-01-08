#
# Module dependencies.
#

request = require "request"

#
# settings
#
settings = require "./settings"

console.log settings.username

# alternative providers:
# http://icanhazip.com
# http://my-ip.heroku.com

request "http://my-ip.heroku.com", (error, response, body) ->
  console.log body  if not error and response.statusCode is 200 # Retrieve IP address via external page provider


# https://www.sitelutions.com/dnsup?id=990331&user=myemail@mydomain.com&pass=SecretPass&ip=192.168.10.4

