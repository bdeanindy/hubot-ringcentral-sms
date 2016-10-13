RingCentral = require 'ringcentral'
async = require 'async'
_ = require 'lodash'
fast_bindall = require 'fast_bindall'
#event_emitter = require 'events'.EventEmitter
https = require 'https'


class RingCentralClient

  constructor: (options = {}, robot) ->
    @robot = robot
    @robot.logger.info "RingCentralClient constructor"
    @options = options

    @appServer = if @options.server? then options.server else process.env.RINGCENTRAL_APP_SERVER
    @appKey = if @options.appKey? then options.appKey else process.env.RINGCENTRAL_APP_KEY
    @appSecret = if @options.appSecret? then options.appSecret else process.env.RINGCENTRAL_APP_SECRET

    # Easy access list of listeners to prevent memory leaks
    listeners = []

    # Initialize the SDK
    sdkOpts =
      server: @appServer
      appKey: @appKey
      appSecret: @appSecret
    @rcsdk = new RingCentral sdkOpts

    # Convenience members
    @platform = @rcsdk.platform()
    @subscription = @rcsdk.createSubscription()
    @bindEventHandlers

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
  login: () ->
    @robot.logger.info "Authenticating to RingCentral"
    username = if options.username? then options.username else process.env.RINGCENTRAL_USERNAME
    password = if options.password? then options.password else process.env.RINGCENTRAL_PASSWORD
    extension = if options.extension? then options.extension else process.env.RINGCENTRAL_EXTENSION
    authOpts =
      username: username
      password: password
      extension: extension
    @platform.login(authOpts)
    .then (authData) ->
      @robot.logger.info "AuthData: ", authData
      @emit 'authenticated'
    .catch (e) ->
      @robot.logger.info e
      throw e

  # Public: sendSMS
  #
  # Returns apiResponse
  sendSMS: (to, from, text) ->
    @robot.logger.info "POST SMS request to RC API"


  # Public: FindUserByExtension
  #
  # Returns RingCentral Extension
  getExtension: (authData) =>
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
    message = new TextMessage(user, record.subject, record.id)
    @robot.receive(message)


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
