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
	# my-ip.heroku.com
	# icanhazip.com
	# whats-my-ip.herokuapp.com/text
	# ipfacts.info
	checker: "my-ip.heroku.com"

	# length of time between IP checks, in seconds
	time: 60

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
	constructor: (@username, @password, @records, @checker, time) ->
		@repeatTime = parseInt time
		@cachedIP = ""
		# data response from checker 
		@on "checkResponseSuccess", @_extractIP
		# IP address found from checker
		@on "extractIPSuccess", @_submitIP
		# IP address submitted to sitelutions for update
		@on "submitSuccess", @_submitCheck

	# PUBLIC METHODS

	checkIP: ->	
		# first call continuousCheck to set next check
		@_continuousCheck()

		# check IP
		req = http.get("http://"+settings.checker, (response) =>
			# handle the response
			res_data = ""
			response.on "data", (chunk) ->
				res_data += chunk
			response.on "end", => @emit "checkResponseSuccess", res_data
		)
		req.on "error", (err) ->
			console.log "IP address site request error: " + err.message

	# PRIVATE METHODS

	_continuousCheck: ->
		if @repeatTime > 0
			# schedule next IP check
			setTimeout (=>
				@checkIP()
			), (@repeatTime * 1000)	

	_extractIP: (response) -> 
		# IPv4 regex
		regex = /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
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
				# record set successfully, can now update cached IP so won't update again until our checked IP changes
				@cachedIP = IP
			else
				console.log "record #{record} was not updated to #{IP}; reason given was \"#{res}\""






#
# main code
#		

fetcher = new Fetcher settings.username, settings.password, settings.records, settings.checker, settings.time

fetcher.checkIP() 


