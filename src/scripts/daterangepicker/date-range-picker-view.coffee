class DateRangePickerView
  @defaultPeriods: [
    'day'
    'week'
    'month'
    'quarter'
    'year'
  ]
  @defaultLocale:
    applyButtonTitle: 'Apply'
    cancelButtonTitle: 'Cancel'
    inputFormat: 'L'

  constructor: (options = {}) ->
    config = new ConfigParser(@, options)
    @periodProxy = Period
    MomentUtil.setFirstDayOfTheWeek(@firstDayOfWeek || 0)
    @periods = ko.observableArray(options.periods || @constructor.defaultPeriods)

    @dateRange = ko.observable([@startDate(), @endDate()])

    @locale = options.locale || @constructor.defaultLocale

    @startCalendar = new CalendarView(@, @startDate, 'start', 'Start')
    @endCalendar = new CalendarView(@, @endDate, 'end', 'End', @startDate)

    @expanded = ko.observable(false)
    @period.subscribe (newValue) =>
      @expanded(true)

    @calendars =
      if @single()
        [@startCalendar]
      else
        [@startCalendar, @endCalendar]


    @startDateInput = @startCalendar.inputDate
    @endDateInput = @endCalendar.inputDate

  updateDateRange: () ->
    @dateRange([@startDate(), @endDate()])

  cssClasses: () ->
    obj = {
      single: @single()
      opened: @opened()
      expanded: @single() || @expanded()
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

  inputFocus: () ->
    @expanded(true)

  setPeriod: (period) ->
    @period(period)

  setDateRange: (dateRange) =>
    if dateRange.constructor == CustomDateRange
      @expanded(true)
    else
      @period('day')
      @expanded(false)
      @startDate(dateRange.startDate)
      @endDate(dateRange.endDate)
      @updateDateRange()

  applyChanges: () ->
    @close()
    @updateDateRange()

  cancelChanges: () ->
    @close()

  open: () ->
    @opened(true)

  close: () ->
    @opened(false)

  toggle: () ->
    @opened(!@opened())
