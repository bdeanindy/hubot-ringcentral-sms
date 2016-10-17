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

    # Placeholder for auth data
    @authData = null
    @botUser = null

    # Initialize the SDK
    sdkOpts =
      server: @appServer
      appKey: @appKey
      appSecret: @appSecret
    @rcsdk = new RingCentral sdkOpts

    # Convenience members
    @platform = @rcsdk.platform()
    @subscription = @rcsdk.createSubscription()
    @subscriptionId = ""

    # Bind platform event listeners
    @platform.on('loginSuccess', @handleLoginSuccess)
    @platform.on('loginError', @handleLoginError)
    @platform.on('refreshSuccess', @handleRefreshSuccess)
    @platform.on('refreshError', @handleRefreshError)
    @platform.on('logoutSuccess', @handleLogoutSuccess)
    @robot.logger.info "RingCentralClient event handlers have been bound"



  # Public Members
  login: () =>
    @robot.logger.info "Authenticating to RingCentral"
    username = if @options.username? then options.username else process.env.RINGCENTRAL_USERNAME
    password = if @options.password? then options.password else process.env.RINGCENTRAL_PASSWORD
    extension = if @options.extension? then options.extension else process.env.RINGCENTRAL_EXTENSION
    authOpts =
      username: username
      password: password
      extension: extension
    @platform.login(authOpts)
    .then (authData) =>
      @robot.logger.info "AuthData: ", authData.json()
      @authData = authData.json()
      @getExtension()
    .catch (e) ->
      @robot.logger.info e
      throw e

  # Public: sendSMS
  #
  # Returns apiResponse
  sendSMS: (smsTo, smsFrom, smsBody, callback) ->
    @robot.logger.info "POST SMS request to RC API to: ", smsTo
    @robot.logger.info "Message: ", smsBody
    smsOpts =
      to: [{phoneNumber: smsTo}],
      from: {phoneNumber: smsFrom},
      text: smsBody
    @platform.post('/account/~/extension/~/sms', smsOpts)
    .then (response) ->
      callback( response )
    .catch (e) ->
      callback e
      throw e


  # Public: getExtension
  #
  # Returns RingCentral Extension
  getExtension: () =>
    ownerId = if @authData.owner_id then @authData.owner_id else '~'
    # @robot.logger.info('findUserbyExtension')
    @platform.get('/account/~/extension/' + ownerId + '/')
    .then (extension) =>
      # @robot.logger.info('Extension: ', extension.json())
      @botUser = extension.json()
    .catch (e) =>
      @robot.logger.error(e)
      throw e


  # Public: getWebhook
  #
  # Returns RingCentral Webhook Subscription
  getWebhook: () =>
    @robot.logger.info "getWebhook"
    if !@subscriptionId? then return false
    @platform.get('/subscription/' + @subscriptionId)
    .then (myWebhook) =>
      @robot.logger.info "Current Webhook", myWebhook
    .catch (e) =>
      @robot.logger.error e
      throw e


  # Public: createWebhook
  #
  # Returns RingCentral Webhook Subscription
  createWebhook: (filters) =>
    @robot.logger.info "filters passed: ", filters
    webhookConfig =
      eventFilters: filters,
      deliveryMode:
        transportType: process.env.DELIVERY_MODE_TRANSPORT_TYPE,
        # address: process.env.DELIVERY_MODE_ADDRESS + '?auth_token=' + process.env.WEBHOOK_TOKEN
        address: process.env.DELIVERY_MODE_ADDRESS

    @platform.post('/subscription', webhookConfig)
    .then (webhookResponse) =>
      webhookResponse = webhookResponse.json()
      @robot.logger.info "Webhook created", webhookResponse
      @subscriptionId = webhookResponse.id
      @robot.logger.info "Client.subscriptionId: ", @subscriptionId
    .catch (e) =>
      @robot.logger.error e
      throw e


  # Public: deleteSubscription
  #
  # Returns nothing
  deleteWebhook: (subscriptionId) =>
    subscriptionId = if subscriptionId? then subscriptionId else @subscriptionId
    @robot.logger.info "deleteWebhook id: ", subscriptionId
    @platform.delete('/subscription/' + @subscriptionId)
    .then (myWebhook) =>
      @robot.logger.info "Webhook Deleted"
    .catch (e) =>
      @robot.logger.error e
      throw e


# RCSDK Event Handlers
  # Public: Platform Login Success Handler
  #
  # Returns RingCentral API Token
  handleLoginSuccess: (msg) =>
    @robot.logger.info('RingCentral authentication successful', msg.json())
    @createWebhook ['/restapi/v1.0/account/~/extension/~/message-store/instant?type=SMS']
    @robot.emit 'authenticated'


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

module.exports = RingCentralClient
