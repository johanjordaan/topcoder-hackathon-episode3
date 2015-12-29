fs = require 'fs'
express = require 'express'
app = express!
logger = require 'morgan'
request = require 'request'
bodyParser = require 'body-parser'
YouTube = require 'youtube-node'
_ = require 'prelude-ls'
glob = require 'glob'
path = require 'path'

# Load keys from the kesy.ls file
#
youtubeKey = require('./key').youtubeKey
giflayerKey = require('./key').giflayerKey

#https://www.youtube.com/watch?v=DqRXahtDX7o

# Configure express settings
#
app.use express.static __dirname + '/public'
app.use logger 'dev'
app.use bodyParser.json!
app.use bodyParser.urlencoded {extended:true}

# Input in YYYYMMDD
#
fromYYYYMMDD = (dateString) ->
   if !dateString?
      c = new Date!
      dateString = "#{c.getFullYear!}#{c.getMonth! + 1}#{c.getDate!}"

   date = new Date(
      Number(dateString.substring(0,4)),
      Number(dateString.substring(4,6))-1,
      Number(dateString.substring(6,8))
   )public/data

toYYYYMMDD = (date) ->
   date.toISOString().slice(0,10).replace(/-/g,"");

# Hack to get ISO strings into the 3339 format
#
ISO3339 = (date) ->
   # ISO 3339 conversion
   date = date.toISOString!.replace(/....Z$/,'Z')

callYouTube = (publishedAfter) ->
   youTube = new YouTube!
   youTube.setKey youtubeKey
   youTube.addParam 'order', 'viewCount'
   youTube.addParam 'type', 'video'
   youTube.addParam 'publishedAfter', publishedAfter

   new Promise (resolve, reject) ->


buildYTRequest = (publishedAfterDate,publishedBeforeDate) ->
   youTube = new YouTube!
   youTube.setKey youtubeKey
   youTube.addParam 'order', 'viewCount'
   youTube.addParam 'type', 'video'
   youTube.addParam 'publishedAfter', (publishedAfterDate |> ISO3339) |> JSON.stringify
   youTube.addParam 'publishedBefore', (publishedBeforeDate |> ISO3339) |> JSON.stringify
   youTube

buildGLRequest = (id) ->
   url="https://www.youtube.com/watch?v=#{id}"
   start=10
   duration=10
   size="160x100"

   base = "https://apilayer.net/api/capture?access_key=#{giflayerKey}"
   url_parm = "url=#{url}"
   start_parm = "start=#{start}"
   duration_parm = "duration=#{duration}"
   size_param = "size=#{size}"
   glRequest = "#{base}&#{url_parm}&#{start_parm}&#{duration_parm}&#{size_param}"


update = (res, publishedAfterDate) ->
   publishedBeforeDate = new Date(publishedAfterDate)
   publishedBeforeDate.setDate publishedBeforeDate.getDate! + 1

   console.log "Updating [#{publishedAfterDate}] -> [#{publishedBeforeDate}]"

   youTube = buildYTRequest publishedAfterDate, publishedBeforeDate
   dateStr = publishedBeforeDate |> toYYYYMMDD

   youTube.search '', 9, (err, result) ->
      if err
         console.log err
         res.send "{'error':#{err}}"
      else
         items = result.items
            |> _.map (item) ->
               console.log item.id.videoId
               do
                  id: item.id.videoId
                  title: item.snippet.title
                  description: item.snippet.descriptionn
            |> _.each (item) ->
               path = "./public/data/#{item.id}.gif"
               fs.exists path, (exists) ->
                  if exists
                     console.log "Skipping [#{path}], it exists"
                  else
                     glRequest = buildGLRequest(item.id)
                     console.log "Generating [#{path}] using Giflayer [#{glRequest}]"
                     request glRequest
                     .on 'response', (response) ->
                        console.log response.body
                     .on 'error', (err) ->
                        console.log err
                     .pipe fs.createWriteStream(path)

         fs.writeFile "./public/data/#{dateStr}.json", JSON.stringify(items), "UTF-8" (err) ->
            if err?
               console.log err
               res.send "{'error':#{err}}"
            else
               res.send ""

app.post '/api/update/:date', (req, res) ->
   publishedAfterDate = fromYYYYMMDD req.params.date
   update res, publishedAfterDate

app.post '/api/update', (req, res) ->
   publishedAfterDate = fromYYYYMMDD!
   update res, publishedAfterDate

# Load the data for a specific date
#
app.get '/api/load/:date', (req, res) ->
   fs.readFile "public/data/#{req.params.date}.json","UTF-8", (err, text) ->
      if err?
         res.send "{'error':#{err}}"
      else
         res.send text

# Get the list of dates for which we have data
#
app.get '/api/list_dates', (req, res) ->
   glob 'public/data/*.json', (err, files) ->
      if err?
         res.send "{'error':#{err}}"
      else
         files
            |> _.map (file) ->
               path.basename(file).replace(path.extname(file),"")
            |> _.sort
            |> res.send

server = app.listen 3000, ->
   host = server.address!.address
   port = server.address!.port

   console.log "Example app listening at http://#{host}:#{port}"
   console.log "youtubeKey  [#{youtubeKey}]"
   console.log "giflayerKey [#{giflayerKey}]"
