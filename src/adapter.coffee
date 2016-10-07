{Adapter, TextMessage, Message, Robot, User} = require.main.require 'hubot'

class RingCentralSMSAdapter extends Adapter

  # Expects @robot which is a robot instance
  # For more info on Robot: https://github.com/github/hubot/blob/master/src/robot.coffee
  constructor: (@robot, @options) ->
    #super
    @robot.logger.info("Constructor")
    # console.log("Constructor")
    @RCSDK = null

  # Public: Method for sending data back to the chat source.
  #
  # envelope - A Object with message, room and user details.
  # strings  - One or more Strings for each message to send.
  #
  # Returns nothing.
  send: (envelope, strings...) ->
    @robot.logger.info("Send")

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
    @emit "connected"
    user = new User 1001, name: 'Sample User'
    message = new TextMessage user, 'Some Sample Message', 'MSG-001'
    @robot.receive message

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
    @robot.logger.info("Brain.Users")

  # Public: Get a User object given a unique identifier.
  #
  # Returns a User instance of the specified user.
  # userForId: (id, options) ->
  # @robot.logger.warning '@userForId() is going to be deprecated in 3.0.0 use @robot.brain.userForId()'
  # @robot.brain.userForId id, options
    @robot.logger.info("Brain.UserForId")

  # Public: Get a User object given a name.
  #
  # Returns a User instance for the user with the specified name.
  # userForName: (name) ->
  # @robot.logger.warning '@userForName() is going to be deprecated in 3.0.0 use @robot.brain.userForName()'
  # @robot.brain.userForName name
    @robot.logger.info("Brain.UserForName")

  # Public: Get all users whose names match fuzzyName. Currently, match
  # means 'starts with', but this could be extended to match initials,
  # nicknames, etc.
  #
  # Returns an Array of User instances matching the fuzzy name.
  # usersForRawFuzzyName: (fuzzyName) ->
  # @robot.logger.warning '@userForRawFuzzyName() is going to be deprecated in 3.0.0 use @robot.brain.userForRawFuzzyName()'
  # @robot.brain.usersForRawFuzzyName fuzzyName
    @robot.logger.info("Brain.UserForRawFuzzyName")

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
