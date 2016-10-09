RingCentral = require 'ringcentral'

class RingCentralClient

  constructor: (@options, @robot) ->
    options = options || {}
    robot = robot

    _rcAppServer = if options.server? then options.server else process.env.RINGCENTRAL_APP_SERVER
    _rcAppKey = if options.appKey? then options.appKey else process.env.RINGCENTRAL_APP_KEY
    _rcAppSecret = if options.appSecret? then options.appSecret else process.env.RINGCENTRAL_APP_SECRET
    _rcUsername = if options.username? then options.username else process.env.RINGCENTRAL_USERNAME
    _rcPassword = if options.password? then options.password else process.env.RINGCENTRAL_PASSWORD
    _rcExtension = if options.extension? then options.extension else process.env.RINGCENTRAL_EXTENSION

    # Define instance variables
    instanceVars =
      appServer:
        get: ->
          _rcAppServer
        set: (val) ->
          _rcAppServer = val
      appKey:
        get: ->
          _rcAppKey
        set: (val) ->
          _rcAppKey = val
      appSecret:
        get: ->
          _rcAppSecret
        set: (val) ->
          _rcAppSeret = val
      username:
        get: ->
          _rcUsername
        set: (val) ->
          _rcUsername = val
        configurable: true
      password:
        get: ->
          _rcPassword
        set: (val) ->
          _rcPassword = val
        configurable: true
      extension:
        get: ->
          _rcExtension
        set: (val) ->
          _rcExtension = val
        configurable: true

    Object.defineProperties @, instanceVars

    # Easy access list of listeners to prevent memory leaks
    listeners = []

    # Initialize the SDK
    @rcsdk = @instantiateSDK

    # Convenience members
    @platform = @setPlatform
    @subscription = @setSubscription
    @bindEventHandlers

    # Authenticate to RingCentral
    @login

    # @robot.logger.info "RingCentralClient has been initiated"


  # Private Members
  instantiateSDK = ->
    sdkOpts =
      server: @appServer
      appKey: @appKey
      appSecret: @appSecret
    @rcsdk = new RingCentral sdkOpts
    @robot.logger.info "RingCentral SDK has been instantiated"

  setPlatform = ->
    @platform = @rcsdk.platform()
    @robot.logger.info "RingCentralClient.platform is set"

  setSubscription = ->
    @subscription = @rcsdk.createSubscription()
    @robot.logger.info "RingCentralClient.subscription is set"

  bindEventHandlers = ->
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
    @robot.logger.info "RingCentralClient event handlers have been bound"



  # Public Members
  login: (options) ->
    @robot.logger.info "Authenticating to RingCentral"
    @.username =
    authOpts =
      username: process.env.RINGCENTRAL_USERNAME
      password: process.env.RINGCENTRAL_PASSWORD
      extension: process.env.RINGCENTRAL_EXTENSION
    @platform.login authOpts
    .catch (e) ->
      @robot.logger.info e
      throw e

  start: ->

  finish: ->

  connect: ->

  on: ->

  handleMessage: ->

  handleError: ->

  disconnect: ->

  sendSMS: ->



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



# RCSDK Event Handlers
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



module.exports = RingCentralClient
