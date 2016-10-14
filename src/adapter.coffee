RingCentralClient = require './client'
{Adapter, TextMessage, Message, Robot, User} = require.main.require 'hubot'

if process.env.NODE_ENV != 'production' then require('dotenv').load()

class RingCentralSMSAdapter extends Adapter

  # Expects @robot which is a robot instance
  # For more info on Robot: https://github.com/github/hubot/blob/master/src/robot.coffee
  constructor: (robot, options = {}) ->
    super robot
    @robot.logger.info("Adapter Constructor")

    # Returns RingCentral SDK Instance
    @client = new RingCentralClient(options, @robot)
    #@robot.logger.info "Adapter.client: ", @client
    @client.login()

  # Public: Method for sending data back to the chat source.
  #
  # envelope - A Object with message metadata.
  # strings  - One or more Strings for each message to send.
  #
  # Returns nothing.
  send: (envelope, strings...) ->
    @robot.logger.info("Start to Send")
    # TODO: Add some sanity checks and invalidations
    # GET Robot User ID (phone number of authenticated user)


  # Public: Method for building a reply and sending it back to the chat source
  #
  # envelope - A Object with message, room and user details.
  # strings  - One more more Strings to set as the topic.
  #
  # Returns nothing.
  reply: (envelope, strings...) ->
    @robot.logger.info("Start to Reply")
    # TODO: Add some sanity checks and invalidations
    # GET Robot User ID (phone number of authenticated user)


  # Public: Method for invoking the bot to run
  #
  # Returns nothing
  run: ->
    @robot.logger.info("Initializing RingCentralSMSAdapter")

    @robot.on 'authenticated', =>
      @robot.logger.info "Client Authenticated"
      @robot.user = @client.botUser
      @robot.logger.info("Robot Name: ", @robot.name)
      @robot.logger.info("Robot User: ", @robot.user)
      @emit "connected"

    @robot.router.post "/webhooks", (req, res) ->
      # @robot.logger.info "Webhook.headers.validationToken: ", req.headers['validation-token']
      validationToken = req.headers['validation-token']
      if 'POST' != req.method or req.url != '/webhooks?auth_token=' + process.env.WEBHOOK_TOKEN
        res.statusCode = 403
        res.end()
      else
        body = []
        req.on 'data', (chunk) ->
          body.push chunk
        req.on 'end', ->
          body = Buffer.concat(body).toString()
          @robot.logger.info body
        res.statusCode = 200
        if validationToken?
          res.setHeader 'Validation-Token', validationToken
        res.statusCode = 200
        res.end()


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
