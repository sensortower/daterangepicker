# http://www.knockmeout.net/2012/05/quick-tip-skip-binding.html
ko.bindingHandlers.stopBinding = init: ->
  { controlsDescendantBindings: true }

ko.virtualElements.allowedBindings.stopBinding = true

ko.bindingHandlers.daterangepicker =
  init: (element, valueAccessor, allBindings) ->
    observable = valueAccessor()
    options = allBindings.get('daterangepickerOptions') || {}
    $(element).daterangepicker(options, (startDate, endDate, period) ->
      observable([startDate, endDate, period])
    )

  update: (element, valueAccessor, allBindings) ->
    $element = $(element)
    [startDate, endDate, period] = valueAccessor()()
    dateFormat = 'MMM D, YYYY'
    startDateText = moment(startDate).format(dateFormat)
    endDateText = moment(endDate).format(dateFormat)
    ko.ignoreDependencies ->
      if $element.data('daterangepicker').single()
        $element.val(startDateText)
      else
        $element.val("#{startDateText} – #{endDateText}")

      $element.data('daterangepicker').period(period)
      $element.data('daterangepicker').startDate(startDate)
      $element.data('daterangepicker').endDate(endDate)
