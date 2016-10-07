should = require 'should'
{Adapter, TextMessage, Message, Robot, User} = require.main.require 'hubot'

RCSMSBot = require '../src/adapter'

describe 'RingCentral SMS Adapter', ->

  it 'Should initialize with a robot', ->
    @rcsmsbot.robot.should.eql @stubs.robot

describe 'Logger', ->

  it 'Should log authentication errors'

describe 'Send a Message', ->

  it 'Should send a message', ->
    sentMessage = @rcsmsbot.send {to: '12223334444', from: '15552223333'}, 'message'
    sentMessage.length.should.equal 1
    sentMessage[0].should equal 'message'
