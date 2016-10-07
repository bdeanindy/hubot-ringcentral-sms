{Adapter, TextMessage, Message, Robot, User} = require.main.require 'hubot'

RingCentral = require 'ringcentral'

class RingCentralSMSAdapter extends Adapter

  # Expects @robot which is a robot instance
  # For more info on Robot: https://github.com/github/hubot/blob/master/src/robot.coffee
  constructor: (@robot, @options) ->
    super
    @robot.logger.info("Constructor")
    rcConfig =
      server: process.env.HUBOT_RINGCENTRAL_SERVER,
      appKey: process.env.HUBOT_RINGCENTRAL_APPKEY,
      appSecret: process.env.HUBOT_RINGCENTRAL_APPSECRET
    @RCSDK = new RingCentral rcConfig
    @lastSyncToken = null
    @dateTo = null


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
    smsPostPayload =
      from:
        phoneNumber: process.env.HUBOT_RINGCENTRAL_USERNAME
      to: [
        {
          phoneNumber: envelope.to
        }
      ]
      text: strings[0]

    @RCSDK.platform().post('/account/~/extension/~/sms', smsPostPayload)
    .then (response) =>
      @robot.logger.info("Send")
      # return response
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


  # Public: Method for invoking the bot to run
  #
  # Returns nothing
  run: ->
    @robot.logger.info("Run")
    @robot.emit "Connecting..."
    userConfig =
      username: process.env.HUBOT_RINGCENTRAL_USERNAME,
      password: process.env.HUBOT_RINGCENTRAL_PASSWORD,
      extension: process.env.HUBOT_RINGCENTRAL_EXTENSION
    return @RCSDK.platform().login userConfig
    .then (result) =>
      @robot.logger.info("Authenticated to RingCentral successfully")
      subscription = @RCSDK.createSubscription()
      @dateTo = (new Date()).toISOString()

      fSyncPayload =
        method: 'Get',
        url: '/account/~/extension/~/message-sync',
        query:
          syncType: 'FSync',
          messageType: 'SMS',
          direction: 'Inbound',
          dateTo: @dateTo
      @RCSDK.platform().send fSyncPayload
      .then (apiResponse) =>
        @lastSyncToken = apiResponse.json().syncInfo.syncToken

    subscription.on(subscription.events.notification, (msg) =>
      @robot.logger.info("New Message Count: " + msg.body.changes[0].newCount)
      currentTime = (new Date()).toISOString()
      iSyncPayload =
        method: 'Get',
        url: '/account/~/extension/~/message-sync',
        query:
          syncType: 'ISync',
          syncToken: @lastSyncToken,
          dateFrom: @dateTo,
          dateTo: currentTime
      @RCSDK.platform().send iSyncPaylod
      )
      .then (iSyncResponse) =>
        @dateTo = currentTime
        @lastSyncToken = iSyncResponse.json().syncInfo.syncToken
        @robot.logger.info('ISync Message Count: ' + iSyncResponse.jsoin().records.length)
        iSyncResponse.json().records.forEach (record) ->
          if 'Inbound' == record.direction
            user = new User(record.from.phoneNumber)
            message = new TextMessage(user, record.subject, record.id)
            @robot.receive(message)
      .catch (e) =>
        @robot.logger.error e.message
        throw e
    subscription.setEventFilters(['/account/~/extension/~/message-store']).register()
    @robot.emit "Connected"
    .catch (e) ->
      console.error e
      throw e
    # user = new User 1001, name: 'Sample User'
    # message = new TextMessage user, 'Some Sample Message', 'MSG-001'
    # @robot.receive message


  # Public: Dispatch a received message to the robot
  #
  # Returns nothing
  # receive: (message) ->
  #   @robot.receive message
    @robot.logger.info("Receive")


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
