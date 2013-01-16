#
# Dynamic DNS updater for sitelutions.com
#

#
# config settings
#
settings = {

	# sitelutions login details
	username: "email@example.com"
	password: "secret"
	
	# separate multiple sitelutions dynamic record ids with commas
	records: "1234567,1234568"
	
	# external site for checking IPv4 - response must include your IP as the first literal IPv4 address
	# alternative providers:
	# http://my-ip.heroku.com
	# http://icanhazip.com
	# http://whats-my-ip.herokuapp.com/text
	# http://ipfacts.info
	checker: "http://my-ip.heroku.com"

}

# #######################
# Do not edit beyond here
# #######################

#
# module definitions
#

http = require "http"
https = require "https"
{EventEmitter} = require "events" 


#
# class definitions
#

class Fetcher extends EventEmitter
	constructor: (@username, @password, @records, @checker) ->
		@cachedIP = ""
		# data response from checker 
		@on "checkResponseSuccess", @_extractIP
		@on "extractIPSuccess", @_submitIP
		@on "submitSuccess", @_submitCheck

	# PUBLIC METHODS

	checkIP: ->	
		req = http.get(settings.checker, (response) =>
			# handle the response
			res_data = ""
			response.on "data", (chunk) ->
				res_data += chunk
			response.on "end", => @emit "checkResponseSuccess", res_data
		)
		req.on "error", (err) ->
			console.log "IP address site request error: " + err.message

	# PRIVATE METHODS

	_extractIP: (response) -> 
		regex = "(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9‌​]{2}|2[0-4][0-9]|25[0-5])"
		# force response to string type
		response += ""
		result = response.match regex
		@emit "extractIPSuccess", result[0] if result
		console.log "IP address not found from IP address site" unless result

	_submitIP: (IP) ->
		# if IP does not equal previously fetched IP, we need to update sitelutions
		if IP isnt @cachedIP
			# construct sitelutions update page request
			request = "https://www.sitelutions.com/dnsup?id=#{@records}&user=#{@username}&pass=#{@password}&ip=#{IP}"
			req = https.get(request, (response) =>
				# handle the response
				res_data = ""
				response.on "data", (chunk) ->
					res_data += chunk
				response.on "end", => @emit "submitSuccess", res_data, IP
			)
			req.on "error", (err) ->
				console.log "DNS update request error: " + err.message

	_submitCheck: (response,IP) ->
		recordsArr = @records.split ","
		responseArr = response.split "\n"
		for record, index in recordsArr
			res = responseArr[index]
			if res is "success"
				console.log "record #{record} updated successfully to #{IP}" 
			else
				console.log "record #{record} was not updated; reson given was \"#{res}\""






#
# main code
#		

fetcher = new Fetcher settings.username, settings.password, settings.records, settings.checker

fetcher.checkIP() 


