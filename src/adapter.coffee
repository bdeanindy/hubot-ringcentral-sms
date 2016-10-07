{Adapter, TextMessage, Message, Robot, User} = require.main.require 'hubot'

class RingCentralSMSAdapter extends Adapter

  # Expects @robot which is a robot instance
  constructor: (@robot, @options) ->
    #super
    console.log("Constructor")

  # Public: Method for sending data back to the chat source.
  send: (envelope, strings...) ->
    console.log("Send")

  # Public: Method for building a reply and sending it back to the chat source
  reply: (envelope, strings...) ->
    console.log("Reply")

  # Public: Method for invoking the bot to run
  run: ->
    console.log("Run")
    @emit "connected"
    user = new User 1001, name: 'Sample User'
    message = new TextMessage user, 'Some Sample Message', 'MSG-001'
    @robot.receive message

module.exports = RingCentralSMSAdapter
