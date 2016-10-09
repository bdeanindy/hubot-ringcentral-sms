sinon = require 'sinon'
should = require 'should'
RingCentralClient = require '../src/client'

describe 'RingCentral Client', ->

  a = new RingCentralClient()

  it 'Should have a constructor', ->
    a.should.exist
    a.should.be.instanceof(RingCentralClient)
    a.should.be.type('object')

  it 'Should expose the required properties and methods', ->
    a.should.have.ownProperty('robot')
    a.should.have.ownProperty('rcsdk')
    a.should.have.ownProperty('platform')
    a.should.have.ownProperty('subscription')
    a.should.have.property('login')
    a.should.have.property('start')
    a.should.have.property('finish')
    a.should.have.property('connect')
    a.should.have.property('on')
    a.should.have.property('handleMessage')
    a.should.have.property('handleError')
    a.should.have.property('disconnect')
    a.should.have.property('sendSMS')

  it 'Should require two parameters', ->

  it 'Should maintain a reference to the supplied robot', ->
    @client.robot.should.equal @stubs.robot

  describe 'start()', ->

    it 'Should be able to start', ->

  describe 'finish()', ->

    it 'Should be able to finish', ->

  describe 'connect()', ->

    it 'Should be able to connect', ->

  describe 'login()', ->

    it 'Should be able to login', ->

  describe 'on()', ->

    it 'Should open with a new connection', ->

    it 'Should open with a new message connection', ->

    it 'Should hit a provided callback', ->

  describe 'handleMessage()', ->

    it 'Should be able to handle messages', ->

  describe 'handleError()', ->

    it 'Should be able to handle errors', ->

  describe 'disconnect()', ->

    it 'Should disconnect all connections', ->

  describe 'sendSMS()', ->

    it 'Should send a message over SMS', ->
