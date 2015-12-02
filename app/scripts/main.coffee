# jQuery integration example
$(".jquery-example").daterangepicker(
  showPeriods: true
  expanded: true
  forceUpdate: true
  callback: (startDate, endDate, period) ->
    $(this).val(startDate.format('MMM D, YYYY') + ' – ' + endDate.format('MMM D, YYYY'))

# Knockout integration example
class View
  constructor: ->
    @dateRange = ko.observable([moment().subtract(30, 'days'), moment(), 'day'])

ko.applyBindings(new View())
