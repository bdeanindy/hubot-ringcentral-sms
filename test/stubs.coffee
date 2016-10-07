# Setup stubs used within other tests

RCSMSBot = require '../src/adapter'
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
    name: 'self'
    id: 'U111'
    bot_id: 'RC123'

  @stubs.self_bot =
    name: 'self'
    id: 'RC123'

  @stubs.user =
    name: 'name',
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

  @stubs.callback = do ->
    return 'done'

  #console.log('this.stubs: ', @stubs)

  # Generate new instance per test
  @rcsmsbot = new RCSMSBot @stubs.robot
  @rcsmsbot.self = @stubs.self
