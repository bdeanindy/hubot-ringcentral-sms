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
    _rcextension = if options.extension? then options.extension else process.env.RINGCENTRAL_EXTENSION
    _rcSDK = null
    _platform = null
    _subscription = null

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
      rcsdk:
        get: ->
          _rcSDK
        set: (val) ->
          _rcSDK = val
      platform:
        get: ->
          _platform
        set: (val) ->
          _platform = val
      subscription:
        get: ->
          _subscription
        set: (val) ->
          _subscription = val

    Object.defineProperties @, instanceVars

    # Easy access list of listeners to prevent memory leaks
    listeners = []

    # Initialize the SDK
    @rcsdk = @instantiateSDK

    # Set required members
    platform = @setPlatform
    subscription = @setSubscription

    # Authenticate to RingCentral
    # @login()
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


module.exports = RingCentralClient
