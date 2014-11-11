usb = require "usb"
express = require 'express'
exphbs  = require 'express-handlebars'


class Missile

  productVendor: 0x2123
  productId: 0x1010
  bmRequestType: 0x21
  bRequest: 0x09
  wValue: 0x0
  wIndex: 0x0
  commands:
    down: { data: 0x01, duration: 400 }
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

  send: (command, duration) ->
    duration = @commands[command].duration unless duration?
    @device.controlTransfer(@bmRequestType, @bRequest, @wValue, @wIndex, @commands[command].buffer)

    if duration != false
      setTimeout =>
        @send('stop')
      , duration


missile = new Missile()
missile.send('fire')
