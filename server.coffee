#
# Dynamic DNS updater for sitelutions.com
#

#
# config settings
#
settings = {

	# sitelutions login details
	username: "email@example.com"
	password: "password"
	
	# separate multiple sitelutions dynamic record ids with commas
	records: "1234567"
	
	# external basic site for checking IP - must return just IP address with no extra html formatting
	# alternative providers:
	# http://icanhazip.com
	# http://my-ip.heroku.com
	checker: "http://my-ip.heroku.com"

}

#
# module definitions
#

http = require "http"


#
#
#

req = http.get(settings.checker, (response) ->
  # handle the response
  res_data = ""
  response.on "data", (chunk) ->
    res_data += chunk
  response.on "end", ->
    console.log res_data
)
req.on "error", (err) ->
  console.log "Request error: " + err.message




# https://www.sitelutions.com/dnsup?id=990331&user=myemail@mydomain.com&pass=SecretPass&ip=192.168.10.4

