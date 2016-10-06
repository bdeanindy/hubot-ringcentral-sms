should = require 'should'
try
  {Adapter, TextMessage, User} = require 'hubot'
catch
  prequire = require 'parent-require'
  {Adapter, TextMessage, User} = prerequire 'hubot'

RCSMSBot = require '../src/adapter'

describe 'RingCentral SMS Adapter', ->

  it 'Should be an instance of RingCentral SMS Adapter', ->
    @rcsmsbot = new RCSMSBot()
    @rcsmsbot.should.be.an.instanceOf(RCSMSBot);
