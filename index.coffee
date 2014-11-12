env = require "node-env-file"

express = require 'express'
exphbs  = require 'express-handlebars'

try
  env "#{__dirname}/.env"
catch error
  console.log error

tokbox =
  key: process.env.apiKey
  session: process.env.sessionId
  token: process.env.token

app = express()
app.engine "handlebars", exphbs(defaultLayout: "main")
app.set "view engine", "handlebars"

app.get "/", (req, res) =>
  res.render "client",
    key: tokbox.key
    session: tokbox.sessionID
    token: tokbox.token

app.get "/server", (req, res) =>
  res.render "server",
    key: tokbox.key
    session: tokbox.sessionID
    token: tokbox.token

app.listen process.env.PORT || 5000
