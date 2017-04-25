class DateRangePickerView
  constructor: (options = {}) ->
    new Config(options).extend(@)

    @startCalendar = new CalendarView(@, @startDate, 'start')
    @endCalendar = new CalendarView(@, @endDate, 'end')

    @startDateInput = @startCalendar.inputDate
    @endDateInput = @endCalendar.inputDate
    @dateRange = ko.observable([@startDate(), @endDate()])

    @startDate.subscribe (newValue) =>
      if @single()
        @endDate(newValue.clone().endOf(@period()))
        @updateDateRange()
        @close()
      else
        if @endDate().isSame(newValue)
          @endDate(@endDate().clone().endOf(@period()))
        if @standalone()
          @updateDateRange()

    @style = ko.observable({})

    if @callback
      @dateRange.subscribe (newValue) =>
        [startDate, endDate] = newValue
        @callback(startDate.clone(), endDate.clone(), @period())
      if @forceUpdate
        [startDate, endDate] = @dateRange()
        @callback(startDate.clone(), endDate.clone(), @period())

    if @anchorElement
      wrapper = $("<div data-bind=\"stopBinding: true\"></div>").appendTo(@parentElement)
      @containerElement = $(@constructor.template).appendTo(wrapper)
      ko.applyBindings(@, @containerElement.get(0))
      @anchorElement.click =>
        @updatePosition()
        @toggle()
      unless @standalone()
        $(document)
          .on('mousedown.daterangepicker', @outsideClick)
          .on('touchend.daterangepicker', @outsideClick)
          .on('click.daterangepicker', '[data-toggle=dropdown]', @outsideClick)
          .on('focusin.daterangepicker', @outsideClick)

    if @opened()
      @updatePosition()

  periodProxy: Period

  calendars: () ->
    if @single()
      [@startCalendar]
    else
      [@startCalendar, @endCalendar]

  updateDateRange: () ->
    @dateRange([@startDate(), @endDate()])

  cssClasses: () ->
    obj = {
      single: @single()
      opened: @standalone() || @opened()
      expanded: @standalone() || @single() || @expanded()
      standalone: @standalone()
      'hide-weekdays': @hideWeekdays()
      'hide-periods': (@periods().length + @customPeriodRanges.length) == 1
      'orientation-left': @orientation() == 'left'
      'orientation-right': @orientation() == 'right'
    }
    for period in Period.allPeriods
      obj["#{period}-period"] = period == @period()
    obj

  isActivePeriod: (period) ->
    @period() == period

  isActiveDateRange: (dateRange) ->
    if dateRange.constructor == CustomDateRange
      for dr in @ranges
        if dr.constructor != CustomDateRange && @isActiveDateRange(dr)
          return false
      true
    else
      @startDate().isSame(dateRange.startDate, 'day') && @endDate().isSame(dateRange.endDate, 'day')

  isActiveCustomPeriodRange: (customPeriodRange) ->
    @isActiveDateRange(customPeriodRange) && @isCustomPeriodRangeActive()

  inputFocus: () ->
    @expanded(true)

  setPeriod: (period) ->
    @isCustomPeriodRangeActive(false)
    @period(period)
    @expanded(true)

  setDateRange: (dateRange) =>
    if dateRange.constructor == CustomDateRange
      @expanded(true)
    else
      @expanded(false)
      @close()
      @period('day')
      @startDate(dateRange.startDate)
      @endDate(dateRange.endDate)
      @updateDateRange()

  setCustomPeriodRange: (customPeriodRange) =>
    @isCustomPeriodRangeActive(true)
    @setDateRange(customPeriodRange)

  applyChanges: () ->
    @close()
    @updateDateRange()

  cancelChanges: () ->
    @close()

  open: () ->
    @opened(true)

  close: () ->
    @opened(false) unless @standalone()

  toggle: () ->
    if @opened() then @close() else @open()

  updatePosition: () ->
    return if @standalone()
    parentOffset =
      top: 0
      left: 0
    parentRightEdge = $(window).width()
    if !@parentElement.is('body')
      parentOffset =
        top: @parentElement.offset().top - @parentElement.scrollTop()
        left: @parentElement.offset().left - @parentElement.scrollLeft()
      parentRightEdge = @parentElement.get(0).clientWidth + @parentElement.offset().left

    style =
      top: (@anchorElement.offset().top + @anchorElement.outerHeight() - (parentOffset.top)) + 'px'
      left: 'auto'
      right: 'auto'

    switch @orientation()
      when 'left'
        if @containerElement.offset().left < 0
          style.left = '9px'
        else
          style.right = (parentRightEdge - (@anchorElement.offset().left) - @anchorElement.outerWidth()) + 'px'
      else
        if @containerElement.offset().left + @containerElement.outerWidth() > $(window).width()
          style.right = '0'
        else
          style.left = (@anchorElement.offset().left - (parentOffset.left)) + 'px'

    @style(style)

  outsideClick: (event) =>
    target = $(event.target)
    unless event.type == 'focusin' || target.closest(@anchorElement).length || target.closest(@containerElement).length || target.closest('.calendar').length
      @close()
