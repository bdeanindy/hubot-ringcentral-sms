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
    @robot.logger.info "send() envelope: ", envelope
    @robot.logger.info "send() strings: ", strings
    user = envelope.user
    message = strings.join "\n"

    @sendSMS message, user.id, (err, body) ->
      if err or not body?
        @robot.logger.error "Error sending reply SMS: #{err}"


  # Public: Method for building a reply and sending it back to the chat source
  #
  # envelope - A Object with message, room and user details.
  # strings  - One more more Strings to set as the topic.
  #
  # Returns nothing.
  reply: (users, strings...) ->
    @robot.logger.info "reply() user: ", users
    @robot.logger.info "reply() strings: ", strings
    @send users, str for str in strings


  # Public: Respond to chat source
  #
  # envelope - A Object with message, room and user details.
  # strings  - One more more Strings to set as the topic.
  #
  # Returns nothing.
  respond: (regex, callback) ->
    @robot.logger.info "respond() regex: ", regex
    @hear regex, callback

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

    @robot.router.post "/webhooks", (req, res) =>
      validationToken = req.headers['validation-token']
      if 'POST' != req.method or req.url != '/webhooks'
        @robot.logger.info "Request rejected, is not POST method or URL does not match"
        res.statusCode = 403
      else if validationToken?
        @robot.logger.info "Webhook validation"
        res.setHeader 'Validation-Token', validationToken
        res.statusCode = 200
      else
        @robot.logger.info "Valid Webhook notification received, processing"
        body = req.body
        @robot.logger.info body
        res.statusCode = 200
        if @client.subscriptionId == body.subscriptionId
          @receiveSMS(body, req.timestamp)

      res.end()

  # Public: Handle incoming SMS
  receiveSMS: (messageBody, created) ->
    @robot.logger.info "receiveSMS"
    return if messageBody.body.subject.length is 0

    # Get user if known or create new
    userOpts =
      room: @client.subscriptionId
    user = @userForId(messageBody.body.from.phoneNumber, userOpts)
    message = new TextMessage user, messageBody.body.subject, messageBody.body.id
    @receive message


  # Public: Sends the SMS
  #
  # Returns ???
  sendSMS: (message, to, callback) ->
    if message.length > 1600
      message = message.substring(0, 1582) + "...(message is too long)"

    @client.sendSMS(to, process.env.HUBOT_SMS_FROM, message, callback)


  # Public: Get an Array of User objects stored in the brain.
  #
  # Returns an Array of User objects.
  users: ->
    @robot.logger.info("Brain.Users")
    @robot.brain.users()


  # Public: Get a User object given a unique identifier.
  #
  # Returns a User instance of the specified user.
  userForId: (id, options) ->
    @robot.logger.info("Brain.UserForId")
    @robot.brain.userForId(id, options)


  # Public: Get a User object given a name.
  #
  # Returns a User instance for the user with the specified name.
  userForName: (name) ->
    @robot.logger.info("Brain.UserForName")
    @robot.brain.userForName(name)

module.exports = RingCentralSMSAdapter
