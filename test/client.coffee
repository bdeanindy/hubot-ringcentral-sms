{SDK} = require 'ringcentral'
should = require 'should'

describe 'RingCentral Client', ->

  it 'Should initialize with a RingCentral API access_token'

  it 'Should initialize with a new RingCentral Subscription'

  it 'Should initialize with a RingCentral SMS Formatter'

  describe 'login()', ->

    it 'Should be able to authenticate'

    it 'Should relay authentication failure messages'

  describe 'on()', ->

    it 'Should open with a new connection'

    it 'Should open with a new session message'

    it 'Should hit a provided callback'

    it 'Should hit a provided callback for non-message messages'

  describe 'disconnect()', ->

    it 'Should disconnect all connections'

  describe 'send()', ->

    it 'TODO'
