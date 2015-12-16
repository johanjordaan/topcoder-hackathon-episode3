express = require 'express'
app = express!
morgan = require 'morgan'
bodyParser = require 'body-parser'

app.use express.static __dirname + '/public'
app.use morgan 'dev'
app.use bodyParser.urlencoded {'extended':'true'}
app.use bodyParser.json

app.get '*', (req, res) ->
   res.sendfile './public/index.html'

server = app.listen 3000, ->
  host = server.address!.address
  port = server.address!.port


  console.log "Example app listening at http://#{host}:#{port}"
