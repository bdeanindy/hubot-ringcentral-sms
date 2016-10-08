SDK = require 'ringcentral'
should = require 'should'

describe 'RingCentral Client', ->

  it 'Should require options and robot arguments', ->


  it 'Should initialize with an SDK instance', ->
    (@client.rcsdk instanceof SDK).should.equal true

describe 'start()', ->

  it 'Should be able to start'

describe 'finish()', ->

  it 'Should be able to finish'

describe 'connect()', ->

  it 'Should be able to connect'

describe 'login()', ->

  it 'Should be able to login'

describe 'on()', ->

  it 'Should open with a new connection'

  it 'Should open with a new message connection'

  it 'Should hit a provided callback'

describe 'handleMessage()', ->

  it 'Should be able to handle messages'

describe 'handleError()', ->

  it 'Should be able to handle errors'

describe 'disconnect()', ->

  it 'Should disconnect all connections'

describe 'sendSMS()', ->

  it 'Should send a message over SMS'
