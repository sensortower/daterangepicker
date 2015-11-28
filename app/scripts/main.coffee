ko.applyBindings({})

config =
  single: true
  showPeriods: true
  extended: true
  minDate: [null, 'exclusive']
  maxDate: [null, 'exclusive']
  ranges:
    'Last 30 Days': [moment().subtract(30, 'days'), moment()]
    'Last 90 Days': [moment().subtract(90, 'days'), moment()]
    'Last Year': [moment().subtract(1, 'year'), moment()]
    'All Time': 'all-time'
    'Custom Range': 'custom'

$(".btn").daterangepicker config, (startDate, endDate, period) ->
  console.log(startDate.format('L HH:mm z'), endDate.format('L HH:mm z'), period)
