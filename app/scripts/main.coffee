ko.applyBindings({})

config =
  # single: true
  edgeMode: 'extended'
  ranges:
    'Last 30 Days': [moment().subtract(30, 'days'), moment()]
    'Last 90 Days': [moment().subtract(90, 'days'), moment()]
    'Last Year': [moment().subtract(1, 'year'), moment()]
    'All Time': 'all-time'
    'Custom Range': 'custom'

$(".btn").daterangepicker config, (startDate, endDate, period) ->
  console.log(startDate.format('L'), endDate.format('L'), period)
