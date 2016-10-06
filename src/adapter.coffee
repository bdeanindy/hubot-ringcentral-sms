try
  {Robot, Adapter, TextMessage, User} = require 'hubot'
catch
  prequire = require('parent-require')
  {Robot, Adapter, TextMessage, User} = prequire 'hubot'

class RingCentralSMSAdapter extends Adapter

  constructor: ->
    super
    console.log("Constructor")

  send: (envelope, strings...) ->
    console.log("Send")

  reply: (envelope, strings...) ->
    console.log("Reply")

  run: ->
    console.log("Run")
    @emit "connected"
    user = new User 1001, name: 'Sample User'
    message = new TextMessage user, 'Some Sample Message', 'MSG-001'
    @robot.receive message

module.exports = RingCentralSMSAdapter
