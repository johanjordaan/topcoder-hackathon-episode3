express = require 'express'
app = express!
logger = require 'morgan'
bodyParser = require 'body-parser'
YouTube = require 'youtube-node'
key = require('./key').key

youTube = new YouTube!
youTube.setKey key

#https://www.youtube.com/watch?v=DqRXahtDX7o

app.use express.static __dirname + '/public'
app.use logger 'dev'
app.use bodyParser.json!
app.use bodyParser.urlencoded {extended:true}

app.post '/api/search', (req, res) ->
   youTube.search 'Blutengel', 3, (error, result) ->
      if error
         console.log error
         res.send error
      else
         console.log JSON.stringify result, null, 2
         res.send  JSON.stringify result, null, 2


server = app.listen 3000, ->
  host = server.address!.address
  port = server.address!.port


  console.log "Example app listening at http://#{host}:#{port}"
  console.log key
