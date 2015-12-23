fs = require 'fs'
express = require 'express'
app = express!
logger = require 'morgan'
request = require 'request'
bodyParser = require 'body-parser'
YouTube = require 'youtube-node'
_ = require 'prelude-ls'

# Load keys from the kesy.ls file
#
youtubeKey = require('./key').youtubeKey
giflayerKey = require('./key').giflayerKey

# Setup yoitube connection
#
youTube = new YouTube!
youTube.setKey youtubeKey
youTube.addParam 'order', 'viewCount'
youTube.addParam 'type', 'video' 

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
glRequest = "#{base}&#{url_parm}&#{start_parm}&#{duration_parm}"
app.post '/api/update', (req, res) ->
   # Check if the update has been run today
   # and return if it has been run already
   #

   # Search youtube for the 9 new videos with the
   # most hits
   #
   youTube.search '', 9, (error, result) ->
      if error
         console.log error
         res.send error
      else
         #console.log JSON.stringify result, null, 2
         result.items
            |> _.each (item)->
               console.log '---------------------'
               console.log "#{item.id.videoId} - #{item.snippet.title}"
               console.log "#{item.snippet.description}"

               #request(glRequest)
               #   .pipe(fs.createWriteStream("./public/data/#{item.id.videoId}.gif"))

         res.send JSON.stringify result, null, 2

   #console.log "Giflayer get image [#{glRequest}]"
   #request.get(glRequest).pipe(res)

app.get '/api/load', (req, res) ->
   # Load today's (YYYYDDMM) ranking file
   #
   #fs.read './data', (err, data) ->
      #if ?err
      #   console.log err
      #   res.send JSON.stringify { err:err }, null, 2
      #else
         #lines = data.split '\n'
         #items = lines
         #   |> _.map (line) ->
         #      line.split ','
         #      do
         #         gif:


         # Send the list to the fe
         #
         res.send JSON.stringify ranking, null, 2

server = app.listen 3000, ->
  host = server.address!.address
  port = server.address!.port


  console.log "Example app listening at http://#{host}:#{port}"
  console.log "youtubeKey  [#{youtubeKey}]"
  console.log "giflayerKey [#{giflayerKey}]"
