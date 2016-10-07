should = require 'should'
{Adapter, TextMessage, Message, Robot, User} = require.main.require 'hubot'

RCSMSBot = require '../src/adapter'

describe 'RingCentral SMS Adapter', ->

  it 'Should initialize with a robot', ->
    @rcsmsbot.robot.should.eql @stubs.robot
