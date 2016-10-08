{Adapter, TextMessage, Message, Robot, User} = require.main.require 'hubot'

if process.env.NODE_ENV != 'production' then require('dotenv').load()

RingCentral = require 'ringcentral'

class RingCentralSMSAdapter extends Adapter

  # Expects @robot which is a robot instance
  # For more info on Robot: https://github.com/github/hubot/blob/master/src/robot.coffee
  constructor: (@robot, @options) ->
    super
    @robot.logger.info("Constructor")
    rcConfig =
      server: process.env.HUBOT_RINGCENTRAL_APP_SERVER,
      appKey: process.env.HUBOT_RINGCENTRAL_APP_KEY,
      appSecret: process.env.HUBOT_RINGCENTRAL_APP_SECRET
    @RCSDK = new RingCentral rcConfig
    @platform = @RCSDK.platform()
    @subscription = @RCSDK.createSubscription()
    @lastSyncToken = null
    @dateTo = null

    # Bind platform event listeners
    @platform.on(@platform.events.loginSuccess, @handleLoginSuccess)
    @platform.on(@platform.events.loginError, @handleLoginError)
    @platform.on(@platform.events.refreshSuccess, @handleRefreshSuccess)
    @platform.on(@platform.events.refreshError, @handleRefreshError)
    @platform.on(@platform.events.logoutSuccess, @handleLogoutSuccess)

    # Bind subscription event listeners
    @subscription.on(@subscription.events.notification, @handleSubscriptionNotification)
    @subscription.on(@subscription.events.subscribeError, @handleSubscribeError)
    @subscription.on(@subscription.events.subscribeSuccess, @handleSubscribeSuccess)

  # Public: Method for sending data back to the chat source.
  #
  # envelope - A Object with message metadata.
  # strings  - One or more Strings for each message to send.
  #
  # Returns nothing.
  send: (envelope, strings...) ->
    @robot.logger.info("Start to Send")
    @robot.logger.info('Envelope: ', envelope)

    # TODO: Add some sanity checks first...?
    sendPostPayload =
      from:
        phoneNumber: process.env.HUBOT_RINGCENTRAL_USERNAME
      to: [
        {
          phoneNumber: envelope.to
        }
      ]
      text: strings[0]
    @platform.post('/account/~/extension/~/sms', sendPostPayload)
    .then (result) =>
      @robot.logger.info("Send")
    .catch (e) =>
      @robot.logger.error e.message
      throw e


  # Public: Method for building a reply and sending it back to the chat source
  #
  # envelope - A Object with message, room and user details.
  # strings  - One more more Strings to set as the topic.
  #
  # Returns nothing.
  reply: (envelope, strings...) ->
    @robot.logger.info("Reply")
    replyPostPayload =
      from:
        phoneNumber: process.env.HUBOT_RINGCENTRAL_USERNAME
      to: [
        {
          phoneNumber: envelope.user.id
        }
      ]
      text: strings[0]
    @platform.post('/account/~/extension/~/sms', replyPostPayload)
    .then (result) =>
      @robot.logger.info("Reply")
    .catch (e) =>
      @robot.logger.error e.message
      throw e


  # Public: Method for invoking the bot to run
  #
  # Returns nothing
  run: ->
    @robot.logger.info("Run")
    userConfig =
      username: process.env.HUBOT_RINGCENTRAL_USERNAME,
      password: process.env.HUBOT_RINGCENTRAL_PASSWORD,
      extension: process.env.HUBOT_RINGCENTRAL_EXTENSION
    @platform.login userConfig
    .then @findUserById
    .then (ext) =>
      @robot.emit "connected"
      # @robot.logger.info('Owner: ', ext)
      user = new User ext.id, name: ext['name']
      message = new TextMessage user, 'Some Sample Message', 'MSG-001'
      @robot.receive message
    .catch (e) =>
      @robot.logger.error(e)
      throw e


  # Public: FindUserByExtension
  #
  # Returns RingCentral Extension
  findUserById: (authData) =>
    ownerId = if authData.json().owner_id then authData.json().owner_id else '~'
    # @robot.logger.info('findUserbyExtension')
    @platform.get('/account/~/extension/' + ownerId + '/')
    .then (extension) ->
      # @robot.logger.info('Extension: ', extension.json())
      extension.json()
    .catch (e) =>
      @robot.logger.error(e)
      throw e


  # Public: Platform Login Success Handler
  #
  # Returns RingCentral API Token
  handleLoginSuccess: (msg) =>
    @robot.logger.info('RingCentral authentication successful', msg.json())
    @subscription.setEventFilters(['/account/~/extension/~/message-store/instant?type=SMS']).register()


  # Public: Platform Login Error Handler
  #
  # Returns nothing
  handleLoginError: (msg) =>
    @robot.logger.error('RingCentral authentication failed', msg)


  # Public: Platform Refresh Error Handler
  #
  # Returns nothing
  handleRefreshError: (msg) =>
    @robot.logger.error('RingCentral failed to refresh', msg)


  # Public: Platform Refresh Success Handler
  #
  # Returns RingCentral API Token
  handleRefreshSuccess: (msg) =>
    @robot.logger.info('RingCentral refreshed successfully', msg.json())
    # TODO: Lookup extension and user info to assign below
    # user = new User(record.from.phoneNumber)


  # Public: Platform Logout Success Handler
  #
  # Returns nothing
  handleLogoutSuccess: (msg) =>
    @robot.logger.info('RingCentral logged out successfully', msg.json())
    # TODO: Lookup extension and user info to deregister below
    # user = new User(record.from.phoneNumber)


  # Public: Subscription Event Notification Handler
  #
  # Returns nothing
  handleSubscriptionNotification: (msg) =>
    @robot.logger.info('New Inbound SMS: ', msg)
    # user = new User(record.from.phoneNumber)
    # message = new TextMessage(user, record.subject, record.id)
    # @robot.receive(message)


  # Public: Subscribe Error Handler
  #
  # Returns nothing
  handleSubscribeError: (msg) =>
    @robot.logger.error(msg)


  # Public: Subscribe Success Handler
  #
  # Returns nothing
  handleSubscribeSuccess: (msg) =>
    @robot.logger.info('Subscribed', msg.json())


  # Public: Dispatch a received message to the robot
  #
  # Returns nothing
  receive: (message) ->
    @robot.logger.info("Receive")
    @robot.receive message


  # Public: Get an Array of User objects stored in the brain.
  #
  # Returns an Array of User objects.
  # users: ->
  # @robot.logger.warning '@users() is going to be deprecated in 3.0.0 use @robot.brain.users()'
  # @robot.brain.users()
  # @robot.logger.info("Brain.Users")


  # Public: Get a User object given a unique identifier.
  #
  # Returns a User instance of the specified user.
  # userForId: (id, options) ->
  # @robot.logger.warning '@userForId() is going to be deprecated in 3.0.0 use @robot.brain.userForId()'
  # @robot.brain.userForId id, options
  # @robot.logger.info("Brain.UserForId")


  # Public: Get a User object given a name.
  #
  # Returns a User instance for the user with the specified name.
  # userForName: (name) ->
  # @robot.logger.warning '@userForName() is going to be deprecated in 3.0.0 use @robot.brain.userForName()'
  # @robot.brain.userForName name
  #  @robot.logger.info("Brain.UserForName")


  # Public: Get all users whose names match fuzzyName. Currently, match
  # means 'starts with', but this could be extended to match initials,
  # nicknames, etc.
  #
  # Returns an Array of User instances matching the fuzzy name.
  # usersForRawFuzzyName: (fuzzyName) ->
  # @robot.logger.warning '@userForRawFuzzyName() is going to be deprecated in 3.0.0 use @robot.brain.userForRawFuzzyName()'
  # @robot.brain.usersForRawFuzzyName fuzzyName
  # @robot.logger.info("Brain.UserForRawFuzzyName")


  # Public: If fuzzyName is an exact match for a user, returns an array with
  # just that user. Otherwise, returns an array of all users for which
  # fuzzyName is a raw fuzzy match (see usersForRawFuzzyName).
  #
  # Returns an Array of User instances matching the fuzzy name.
  # usersForFuzzyName: (fuzzyName) ->
  # @robot.logger.warning '@userForFuzzyName() is going to be deprecated in 3.0.0 use @robot.brain.userForFuzzyName()'
  # @robot.brain.usersForFuzzyName fuzzyName


  # Public: Creates a scoped http client with chainable methods for
  # modifying the request. This doesn't actually make a request though.
  # Once your request is assembled, you can call `get()`/`post()`/etc to
  # send the request.
  #
  # Returns a ScopedClient instance.
  # http: (url) ->
  # @robot.logger.warning '@http() is going to be deprecated in 3.0.0 use @robot.http()'
  # @robot.http(url)

module.exports = RingCentralSMSAdapter
