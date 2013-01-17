Dynamic DNS updater for sitelutions.com
=======================================

This is a simple coffeescript that runs regularly to check your 'real' external IP address, and then update your hosted domain DNS records
on sitelutions.com as and when it updates. Tested on OSX and linux.

Quick start
------------

- install [node.js](http://nodejs.org)
- install [coffeescript](http://coffeescript.org) for node.js using `npm install -g coffee-script` as root
- download server.coffee from this repo
- edit the script with your login and password for sitelutions, and the dynamic DNS record numbers for the DNS records you wish to update
- run server.coffee with `coffee server.coffee`
- optional: download [forever](http://github.com/nodejitsu/forever) using `npm install -g forever` as root
- optional: then run `forever start -c coffee server.coffee`
- optional: `forever list` will show the script running in the background, and the log file status updates are written to

MIT Licence
-----------

Copyright (C) 2013 James Gater

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.