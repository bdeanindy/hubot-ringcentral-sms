should = require 'should'
try
  {Adapter, TextMessage, User} = require 'hubot'
catch
  prequire = require 'parent-require'
  {Adapter, TextMessage, User} = prerequire 'hubot'

RCSMSBot = require '../src/adapter'

describe 'RingCentral SMS Adapter', ->
  it 'Should initialize with a robot', ->
    @rcsmsbot.robot.should.eql @stubs.robot

  it 'Should be an instance of RingCentral SMS Adapter', ->
    robot = new RCSMSBot()
    robot.should.be.an.instanceOf(RCSMSBot);
