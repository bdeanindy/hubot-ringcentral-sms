assert = require('chai').assert
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
    a.should.have.property('sendSMS')
    a.should.have.property('getExtension')

  it 'Should maintain a reference to the supplied robot', ->
    @client.robot.should.equal @stubs.robot

  describe 'login()', ->

    it 'Should return auth data', ->

  describe 'sendSMS()', ->

    it 'Should send a message over SMS', ->

  describe 'getExtension()', ->

    it 'Should return a RingCentral Extension'
