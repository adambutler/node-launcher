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
  token: process.env.token
  apiSecret: process.env.apiSecret

opentok = new OpenTok(tokbox.apiKey, tokbox.apiSecret)

console.log """
apiKey: #{tokbox.apiKey}
apiSecret: #{tokbox.apiSecret}
token: #{tokbox.token}
"""

# Create a tokbox session
# The session will the OpenTok Media Router:
opentok.createSession
  mediaMode: "routed"
, (err, session) ->
  return console.log(err) if err
  tokbox.sessionId = session.sessionId

  tokbox.token = opentok.generateToken tokbox.sessionId,
    # role: "moderator"
    expireTime: (new Date().getTime() / 1000) + (30 * 24 * 60 * 60) # in 30 days

  app = express()
  app.engine "handlebars", exphbs(defaultLayout: "main")
  app.set "view engine", "handlebars"

  app.get "/", (req, res) =>
    res.render "client", tokbox

  app.get "/server", (req, res) =>
    res.render "server", tokbox

  app.listen process.env.PORT || 5000
