assert = require('chai').assert
should = require 'should'
{Adapter, TextMessage, Message, Robot, User} = require.main.require 'hubot'

RCSMSBot = require '../src/adapter'

process.env['RINGCENTRAL_APP_SERVER'] = 'http://localhost.ringcentral.com'
process.env['RINGCENTRAL_APP_KEY'] = 'appkey'
process.env['RINGCENTRAL_APP_SECRET'] = 'appSecret'
process.env['RINGCENTRAL_USERNAME'] =  '1234567890'
process.env['RINGCENTRAL_PASSWORD'] = 'myPassword'

describe 'RingCentral SMS Adapter', ->

  it 'Should have a constructor', ->
    @rcsmsbot.should.exist

  constructorProps = ['RINGCENTRAL_APP_SERVER','RINGCENTRAL_APP_KEY','RINGCENTRAL_APP_SECRET','RINGCENTRAL_USERNAME','RINGCENTRAL_PASSWORD']

  for constructorProp in constructorProps
    it "Should throw on construction if #{constructorProp} missing", () ->
      prop = process.env[constructorProp]
      delete process.env[constructorProp]
      assert.throws(RCSMSBot, new RegExp("#{constructorProp} undefined"))
      process.env[constructorProp] = prop


  it 'Should initialize with a robot', ->
    @rcsmsbot.robot.should.eql @stubs.robot

  it 'Should expose the required methods and properties', ->
    @rcsmsbot.should.have.property('run')
    @rcsmsbot.should.have.property('send')
    @rcsmsbot.should.have.property('reply')
    @rcsmsbot.should.have.property('receive')
    @rcsmsbot.should.have.property('users')
    @rcsmsbot.should.have.property('userForId')
    @rcsmsbot.should.have.property('userForName')

  describe 'Login', ->
    it 'Should set the robot name', ->
      @rcsmsbot.robot.name.should.equal 'bot'

  describe 'Logger', ->

    it 'Should log authentication errors'

  describe 'Send a Message', ->

    it 'Should send a message'
      # sentMessage = @rcsmsbot.send {to: '12223334444', from: '15552223333'}, 'message'
      # sentMessage.length.should.equal 1
      # sentMessage[0].should equal 'message'

  describe 'Reply to Messages', ->
    # params
    # - envelope: SMS payload defining `to`, `from`, and

    it 'Should reply to valid messages'

    it 'Should not reply to invalid messages'

  describe 'Run -- Invokes the bot to run', ->

    it 'Should handle valid bot invokation'

    it 'Should authenticate to RingCentral'

    it 'Should message-sync to RingCentral accordingly'

    it 'Should relay inbound SMS messages to Hubot'
