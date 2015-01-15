env = require "node-env-file"

express = require 'express'
exphbs  = require 'express-handlebars'
OpenTok = require 'opentok'

try
  env "#{__dirname}/.env"
catch error
  console.log error

tokbox =
  apiKey: process.env.apiKey
  apiSecret: process.env.apiSecret

console.log """
=============================================================
  apiKey: #{tokbox.apiKey}
  apiSecret: #{tokbox.apiSecret}
=============================================================
"""

opentok = new OpenTok(tokbox.apiKey, tokbox.apiSecret)

opentok.createSession {
  mediaMode: "relayed"
}, (err, session) ->
  return console.log(err) if err
  tokbox.sessionId = session.sessionId

  tokbox.token = opentok.generateToken tokbox.sessionId, {
    role: "moderator"
  }

  console.log """
  apiKey: #{tokbox.apiKey}
  apiSecret: #{tokbox.apiSecret}
  sessionId: #{tokbox.sessionId}
  token: #{tokbox.token}
  """

  app = express()

  if process.env.user? and process.env.password?
    app.use express.basicAuth(process.env.user, process.env.password)

  app.engine "handlebars", exphbs(defaultLayout: "main")
  app.set "view engine", "handlebars"

  app.get "/", (req, res) =>
    res.render "client", tokbox

  app.get "/server", (req, res) =>
    res.render "server", tokbox

  app.listen process.env.PORT || 3000
