class Config
  constructor: (options = {}) ->
    @firstDayOfWeek = @_firstDayOfWeek(options.firstDayOfWeek)
    @showPeriods = @_showPeriods(options.showPeriods)
    @timeZone = @_timeZone(options.timeZone)
    @edgeMode = @_edgeMode(options.edgeMode)
    @period = @_period(options.period)
    @periods = @_periods(options.periods)
    @single = @_single(options.single)
    @opened = @_opened(options.opened)
    @expanded = @_expanded(options.expanded)
    @locale = @_locale(options.locale)
    @opens = @_opens(options.opens)

    @minDate = @_minDate(options.minDate)
    @maxDate = @_maxDate(options.maxDate)
    @startDate = @_startDate(options.startDate)
    @endDate = @_endDate(options.endDate)

    @ranges = @_ranges(options.ranges)

    @anchorElement = @_anchorElement(options.anchorElement)
    @parentElement = @_parentElement(options.parentElement)
    @callback = @_callback(options.callback)

    @firstDayOfWeek.subscribe (newValue) ->
      MomentUtil.setFirstDayOfTheWeek(newValue)
    MomentUtil.setFirstDayOfTheWeek(@firstDayOfWeek())

  extend: (obj) ->
    obj[k] = v for k, v of @ when @.hasOwnProperty(k) && k[0] != '_'

  _firstDayOfWeek: (val) ->
    ko.observable(if val then val else 0) # default to Sunday (0)

  _timeZone: (val) ->
    ko.observable(val || 'UTC')

  _showPeriods: (val) ->
    ko.observable(val || false)

  _period: (val) ->
    val = 'day' unless val in ['day', 'week', 'month', 'quarter', 'year']
    Period.extendObservable(ko.observable(val))

  _periods: (val) ->
    ko.observableArray(val || Period.allPeriods)

  _single: (val) ->
    ko.observable(val || false)

  _opened: (val) ->
    ko.observable(val || false)

  _expanded: (val) ->
    ko.observable(val || false)

  _minDate: (val) ->
    val ||= moment().subtract(30, 'year')
    @_dateObservable(val)

  _maxDate: (val) ->
    val ||= moment()
    @_dateObservable(val)

  _startDate: (val) ->
    val ||= moment().subtract(30, 'days')
    @_dateObservable(val, @minDate, @maxDate)

  _endDate: (val) ->
    val ||= moment()
    @_dateObservable(val, @startDate, @maxDate)

  _ranges: (obj) ->
    obj ||= {}
    for title, value of obj
      switch value
        when 'all-time'
          new AllTimeDateRange(title, @minDate().clone(), @maxDate().clone())
        when 'custom'
          new CustomDateRange(title)
        else
          [startDate, endDate] = value
          from = MomentUtil.tz(startDate, @timeZone())
          to = MomentUtil.tz(endDate, @timeZone())
          new DateRange(title, from, to)

  _edgeMode: (val) ->
    val = 'inclusive' unless val in ['exclusive', 'inclisuve', 'extended']
    ko.observable(val)

  _locale: (val) ->
    val || {
      applyButtonTitle: 'Apply'
      cancelButtonTitle: 'Cancel'
      inputFormat: 'L'
      startLabel: 'Start'
      endLabel: 'End'
    }

  _opens: (val) ->
    val = 'right' unless val in ['right', 'left']
    ko.observable(val)

  _dateObservable: (val, minBoundary, maxBoundary) ->
    observable = ko.observable()
    computed = ko.computed
      read: ->
        observable()
      write: (newValue) =>
        newValue = MomentUtil.tz(newValue, @timeZone())
        if minBoundary
          min = minBoundary()
          min = min.clone().startOf(@period()) if @edgeMode() == 'extended'
          newValue = moment.max(min, newValue)
        if maxBoundary
          max = maxBoundary()
          max = max.clone().endOf(@period()) if @edgeMode() == 'extended'
          newValue = moment.min(max, newValue)
        currentValue = observable()
        unless currentValue && currentValue.isSame(newValue)
          observable(newValue)
    computed.clone = =>
      @_dateObservable(observable(), minBoundary, maxBoundary)
    computed(val)
    if minBoundary
      minBoundary.subscribe -> computed(observable())
    if maxBoundary
      maxBoundary.subscribe -> computed(observable())
    computed

  _anchorElement: (val) ->
    $(val)

  _parentElement: (val) ->
    $(val || 'body') if @anchorElement

  _callback: (val) ->
    val
