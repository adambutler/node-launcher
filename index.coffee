env = require "node-env-file"

express   = require 'express'
exphbs    = require 'express-handlebars'
basicAuth = require 'basic-auth-connect'

try
  env "#{__dirname}/.env"
catch error
  console.log error

app = express()

if process.env.user? and process.env.password?
  app.use basicAuth(process.env.user, process.env.password)

app.engine "handlebars", exphbs(defaultLayout: "main")
app.set "view engine", "handlebars"

app.get "/", (req, res) =>
  res.render "client"

app.get "/server", (req, res) =>
  res.render "server"

app.listen process.env.PORT || 3000
