express = require 'express'
app = express!
logger = require 'morgan'
request = require 'request'
bodyParser = require 'body-parser'
YouTube = require 'youtube-node'

# Load keys from the kesy.ls file
#
youtubeKey= require('./key').youtubeKey
giflayerKey= require('./key').giflayerKey

# Setup yoitube connection
#
youTube = new YouTube!
youTube.setKey youtubeKey

#https://www.youtube.com/watch?v=DqRXahtDX7o

# Configure express settings
#
app.use express.static __dirname + '/public'
app.use logger 'dev'
app.use bodyParser.json!
app.use bodyParser.urlencoded {extended:true}


url="https://www.youtube.com/watch?v=DqRXahtDX7od"
start=5
duration=10

base = "https://apilayer.net/api/capture?access_key=#{giflayerKey}"
url_parm = "url=#{url}"
start_parm = "start=#{start}"
duration_parm = "duration=#{duration}"
app.get '/api/image.gif', (req, res) ->
   glRequest = "#{base}&#{url_parm}&#{start_parm}&#{duration_parm}"
   console.log "Giflayer get image [#{glRequest}]"
   request.get(glRequest).pipe(res)

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
  console.log "youtubeKey  [#{youtubeKey}]"
  console.log "giflayerKey [#{giflayerKey}]"
