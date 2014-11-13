usb = require "usb"
express = require 'express'
express = require('express')
app = express()

class Missile

  productVendor: 0x2123
  productId: 0x1010
  bmRequestType: 0x21
  bRequest: 0x09
  wValue: 0x0
  wIndex: 0x0
  disabled: false

  commands:
    down: { data: 0x03, duration: 400 }
    up: { data: 0x02, duration: 400 }
    left: { data: 0x04, duration: 400 }
    right: { data: 0x08, duration: 400 }
    fire: { data: 0x10, duration: 1600 }
    stop: { data: 0x20 }

  generateCommandBuffers: (command) ->
    for name, config of @commands
      buffer = new Buffer([0x02, config.data, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
      @commands[name].buffer = buffer

  getDevice: ->
    @device = usb.findByIds(@productVendor, @productId)
    @device.open()

  constructor: ->
    @getDevice()
    @generateCommandBuffers()

  stop: (callback) ->
    console.log "DISABLE"
    @disabled = true
    @device.controlTransfer(@bmRequestType, @bRequest, @wValue, @wIndex, @commands['stop'].buffer, =>
      console.log "ENABLE"
      @disabled = false
      callback() if callback?
    )

  test: ->
    @send 'up'

    setTimeout(=>
      @send 'down'
      setTimeout(=>
        @send 'left'
        setTimeout(=>
          @send 'right'
          setTimeout(=>
            @send 'up'
            setTimeout(=>
              @send 'left'
              setTimeout(=>
                @stop()
              , 500)
            , 500)
          , 500)
        , 500)
      , 500)
    , 500)

  send: (command, duration) ->
    unless @disabled
      @stop =>
        console.log "Running #{command}"
        duration = @commands[command].duration unless duration?
        console.log "DISABLE"
        @disabled = true
        @device.controlTransfer(@bmRequestType, @bRequest, @wValue, @wIndex, @commands[command].buffer, =>
          console.log "ENABLE"
          @disabled = false
        )
    else
      console.log "disabled yo"
      @stop =>
        @disabled = false

missile = new Missile()
missile.test()


app.post "/", (req, res) ->
  console.log "Got key #{req.query.key}"
  missile.send('right') if req.query.key == "39"
  missile.send('left') if req.query.key == "37"
  missile.send('fire') if req.query.key == "32"
  missile.send('up') if req.query.key == "38"
  missile.send('down') if req.query.key == "40"
  missile.stop() if req.query.key == "stop"
  res.send "OK"

app.listen(3000);

