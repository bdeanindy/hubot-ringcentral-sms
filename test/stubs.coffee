# Attribution for this handy stubs file goes to: https://github.com/slackhq/hubot-slack/blob/master/test/stubs.coffee
# Setup stubs used within other tests

RCSMSBot = require '../src/adapter'
RingCentralClient = require '../src/client'
{EventEmitter} = require 'events'
# Use Hubot's brain in the stubs
{Brain, Robot} = require 'hubot'
_ = require 'lodash'


beforeEach ->
  @stubs = {}

  @stubs.send = (envelope, msg, opts) =>
    @stubs._to = envelope.to
    @stubs._from = envelope.from
    @stubs._opts = opts
    @stubs._msg = msg
    msg

  @stubs.bot =
    name: 'R2D2'
    id: 'r2d2'

  @stubs.self =
    name: 'selfName'
    id: 'U111'
    bot_id: 'RC123'

  @stubs.self_bot =
    name: 'selfBotName'
    id: 'RC123'

  @stubs.user =
    name: 'userName',
    id: 'U123'

  @stubs.robot = do ->
    robot = new EventEmitter
    # noop the logging
    robot.logger =
      logs: {}
      log: (type, message) ->
        @logs[type] ?= []
        @logs[type].push(message)
      info: (message) ->
        @log('info', message)
      debug: (message) ->
        @log('debug', message)
      error: (message) ->
        @log('error', message)
    # record all received messages
    robot.received = []
    robot.receive = (msg) ->
      @received.push msg
    # attach a Hubot Brain to the robot
    robot.brain = new Brain robot
    robot.name = 'bot'
    robot.listeners = []
    #robot.listen = Robot.prototype.listen.bind(robot)
    #robot.react = Robot.prototype.react.bind(robot)
    robot

  @stubs.rcsdk =
    login: =>
      @stubs._connected = true
    on: (event, callback) =>
      console.log '#####'
      console.log event
      console.log callback
      callback event
    removeListener: (eventName) =>
    sendMessage: (evelope, msg) =>
      @stubs.send envelope, msg
    rcOptions:
      server: 'https://platform.devtest.ringcentral.com'
      appKey: 'asoiuvnawiunarlivauni'
      appSecret: 'iuasndvcioaeuwnlaiuwe'
      username: 'myUsername'
      password: 'myPassword'
      extension: 11111

  @stubs.client =

    dataStore:
      getExtensionById: (id) =>
        for user in @stubs.client.dataStore.users
          return user if user.id is id
      getBotById: (id) =>
        for bot in @stubs.client.dataStore.bots
          return bot if bot.id is id
      getUserByName: (name) =>
        for user in @stubs.client.dataStore.users
          return user if user.name is name
      users: [@stubs.user, @stubs.self, @stubs.userperiod, @stubs.userhyphen]
      bots: [@stubs.bot]

  @stubs.callback = do ->
    return 'done'

  @stubs.receiveMock =
    receive: (message, user) =>
      @stubs._received = message

  #console.log('this.stubs: ', @stubs)

  # Generate new instance per test
  @rcsmsbot = new RCSMSBot @stubs.robot
  _.merge @rcsmsbot.client, @stubs.client
  _.merge @rcsmsbot, @stubs.receiveMock
  @rcsmsbot.self = @stubs.self


  # Generate new RingCentral Client per test
  @client = new RingCentralClient {}, @stubs.robot
