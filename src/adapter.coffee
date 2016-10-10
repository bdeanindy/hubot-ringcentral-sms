Url = require 'url'
Util = require 'util'
{Adapter, TextMessage, Message, Robot, User} = require.main.require 'hubot'
RingCentralClient = require './client'

if process.env.NODE_ENV != 'production' then require('dotenv').load()

class RingCentralSMSAdapter extends Adapter

  # Expects @robot which is a robot instance
  # For more info on Robot: https://github.com/github/hubot/blob/master/src/robot.coffee
  constructor: (robot, @options = {}) ->
    super(robot)

    #throw new Error('RINGCENTRAL_APP_SERVER undefined') unless process.env.RINGCENTRAL_APP_SERVER
    throw new Error('RINGCENTRAL_APP_KEY undefined') unless process.env.RINGCENTRAL_APP_KEY
    throw new Error('RINGCENTRAL_APP_SECRET undefined') unless process.env.RINGCENTRAL_APP_SECRET
    throw new Error('RINGCENTRAL_USERNAME undefined') unless process.env.RINGCENTRAL_USERNAME
    throw new Error('RINGCENTRAL_PASSWORD undefined') unless process.env.RINGCENTRAL_PASSWORD

    @client = new RingCentralClient(@options, @robot)
    # TODO: Add error handling for config param requirements
    @robot.logger.info("Constructor")

  # Public: Method for sending data back to the chat source.
  #
  # envelope - A Object with message metadata.
  # strings  - One or more Strings for each message to send.
  #
  # Returns nothing.
  send: (envelope, strings...) ->
    @robot.logger.info("Start to Send")
    # @robot.logger.info('Envelope: ', envelope)


  # Public: Method for building a reply and sending it back to the chat source
  #
  # envelope - A Object with message, room and user details.
  # strings  - One more more Strings to set as the topic.
  #
  # Returns nothing.
  reply: (envelope, strings...) ->
    @robot.logger.info("Reply")


  # Public: Method for invoking the bot to run
  #
  # Returns nothing
  run: ->
    @robot.logger.info("Initializing RingCentralSMSAdapter")
    @robot.logger.info("Robot Name: ", @robot.name)
    @robot.logger.info("Robot User: ", @robot.user)
    @emit "connected"


  # Public: Dispatch a received message to the robot
  #
  # Returns nothing
  receive: (message) ->
    @robot.logger.info("Receive")
    if message.fromUserId != @robot.userId
      # Lookup user
      @receive message


  # Public: Get an Array of User objects stored in the brain.
  #
  # Returns an Array of User objects.
  users: ->
    @robot.logger.warning '@users() is going to be deprecated in 3.0.0 use @robot.brain.users()'
    @robot.brain.users()
    @robot.logger.info("Brain.Users")


  # Public: Get a User object given a unique identifier.
  #
  # Returns a User instance of the specified user.
  userForId: (id, options) ->
    @robot.logger.warning '@userForId() is going to be deprecated in 3.0.0 use @robot.brain.userForId()'
    @robot.brain.userForId id, options
    @robot.logger.info("Brain.UserForId")


  # Public: Get a User object given a name.
  #
  # Returns a User instance for the user with the specified name.
  userForName: (name) ->
    @robot.logger.warning '@userForName() is going to be deprecated in 3.0.0 use @robot.brain.userForName()'
    @robot.brain.userForName name
    @robot.logger.info("Brain.UserForName")

module.exports = RingCentralSMSAdapter
