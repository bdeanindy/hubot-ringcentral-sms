RingCentralSMSAdapter = require './src/adapter'

exports.use = (robot) ->
  new RingCentralSMSAdapter robot
