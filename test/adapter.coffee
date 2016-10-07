should = require 'should'
{Adapter, TextMessage, Message, Robot, User} = require.main.require 'hubot'

RCSMSBot = require '../src/adapter'

describe 'RingCentral SMS Adapter', ->

  it 'Should initialize with a robot', ->
    @rcsmsbot.robot.should.eql @stubs.robot

  it 'Should have a reference to the RingCentral Client', ->
    @rcsmsbot.should.have.ownProperty('RCSDK')

describe 'Logger', ->

  it 'Should log authentication errors'

describe 'Send a Message', ->

  it 'Should send a message'
    # sentMessage = @rcsmsbot.send {to: '12223334444', from: '15552223333'}, 'message'
    # sentMessage.length.should.equal 1
    # sentMessage[0].should equal 'message'

describe 'Replying to Messages', ->
  # params
  # - envelope: SMS payload defining `to`, `from`, and

  it 'Should reply to valid messages'

  it 'Should not reply to invalid messages'

describe 'Run -- Invokes the bot to run', ->

  it 'Should handle valid bot invokation'
