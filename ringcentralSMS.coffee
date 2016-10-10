RingCentralSMSAdapter = require './src/adapter'

exports.use = (robot, options = {}) ->
  new RingCentralSMSAdapter robot, options
