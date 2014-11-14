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
    session: "1_MX40NTA4Mzg0Mn5-MTQxNTkwNTQyMDM0OX5jN1JQT0VqbWF1cnR6dGFxQWhuNWRsaC9-fg"
    token: "T1==cGFydG5lcl9pZD00NTA4Mzg0MiZzaWc9YTgzMTcwNTBlNDM1ZGZlZGI5OTkxY2M1ZmM1MTRiYTBhOGM5ZTViNjpyb2xlPXB1Ymxpc2hlciZzZXNzaW9uX2lkPTFfTVg0ME5UQTRNemcwTW41LU1UUXhOVGt3TlRReU1ETTBPWDVqTjFKUVQwVnFiV0YxY25SNmRHRnhRV2h1TldSc2FDOS1mZyZjcmVhdGVfdGltZT0xNDE1OTA1NTAwJm5vbmNlPTAuOTQyMzUwMDI4MDMzMjk0MyZleHBpcmVfdGltZT0xNDE4NDk3NDE1"

app.get "/server", (req, res) =>
  res.render "server",
    key: tokbox.key
    session: "1_MX40NTA4Mzg0Mn5-MTQxNTkwNTQyMDM0OX5jN1JQT0VqbWF1cnR6dGFxQWhuNWRsaC9-fg"
    token: "T1==cGFydG5lcl9pZD00NTA4Mzg0MiZzaWc9YTgzMTcwNTBlNDM1ZGZlZGI5OTkxY2M1ZmM1MTRiYTBhOGM5ZTViNjpyb2xlPXB1Ymxpc2hlciZzZXNzaW9uX2lkPTFfTVg0ME5UQTRNemcwTW41LU1UUXhOVGt3TlRReU1ETTBPWDVqTjFKUVQwVnFiV0YxY25SNmRHRnhRV2h1TldSc2FDOS1mZyZjcmVhdGVfdGltZT0xNDE1OTA1NTAwJm5vbmNlPTAuOTQyMzUwMDI4MDMzMjk0MyZleHBpcmVfdGltZT0xNDE4NDk3NDE1"

app.listen process.env.PORT || 3000
