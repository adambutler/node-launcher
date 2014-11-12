express = require 'express'
exphbs  = require 'express-handlebars'

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
    session: "1_MX40NTA4Mzg0Mn5-MTQxNTcwOTA0NzUxMn5ucXZjR2hYV3JpSjVYc2I0VXFORnBBd21-fg"
    token: tokbox.token

app.get "/server", (req, res) =>
  res.render "server",
    key: tokbox.key
    session: "1_MX40NTA4Mzg0Mn5-MTQxNTcwOTA0NzUxMn5ucXZjR2hYV3JpSjVYc2I0VXFORnBBd21-fg"
    token: tokbox.token

app.listen process.env.PORT || 3000
