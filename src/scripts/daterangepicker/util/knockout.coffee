# http://www.knockmeout.net/2012/05/quick-tip-skip-binding.html
ko.bindingHandlers.stopBinding = init: ->
  { controlsDescendantBindings: true }

ko.virtualElements.allowedBindings.stopBinding = true

ko.bindingHandlers.daterangepicker = do ->
  $.extend @,
    _optionsKey: 'daterangepickerOptions'
    _formatKey: 'daterangepickerFormat'

    init: (element, valueAccessor, allBindings) ->
      observable = valueAccessor()
      options = ko.unwrap(allBindings.get(@_optionsKey)) || {}
      $(element).daterangepicker(options, (startDate, endDate, period) ->
        observable([startDate, endDate, allEvents])
      )

    update: (element, valueAccessor, allBindings) ->
      $element = $(element)
      [startDate, endDate, allEvents] = valueAccessor()()
      dateFormat = ko.unwrap(allBindings.get(@_formatKey)) || 'MMM D, YYYY'
      startDateText = moment(startDate).format(dateFormat)
      endDateText = moment(endDate).format(dateFormat)
      ko.ignoreDependencies ->
        unless $element.data('daterangepicker').standalone()
          text =
            if $element.data('daterangepicker').single()
              startDateText
            else
              "#{startDateText} – #{endDateText}"
          $element.val(text).text(text)

        $element.data('daterangepicker').startDate(startDate)
        $element.data('daterangepicker').endDate(endDate)
        $element.data('daterangepicker').allEvents(allEvents)

ko.bindingHandlers.fireChange =
  update: (element, valueAccessor, allBindings) ->
    selectorValue = ko.unwrap(allBindings.get('value'))
    if selectorValue
      $(element).change()
