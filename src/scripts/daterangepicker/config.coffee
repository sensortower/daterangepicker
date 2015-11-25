class Config
  constructor: (options = {}) ->
    @firstDayOfWeek = @_firstDayOfWeek(options.firstDayOfWeek)
    @timeZone = @_timeZone(options.timeZone)
    @period = @_period(options.period)
    @periods = @_periods(options.periods)
    @single = @_single(options.single)
    @opened = @_opened(options.opened)
    @expanded = @_expanded(options.expanded)

    @minDate = @_minDate(options.minDate)
    @maxDate = @_maxDate(options.maxDate)
    @startDate = @_startDate(options.startDate)
    @endDate = @_endDate(options.endDate)

    @ranges = @_ranges(options.ranges)
    @edgeMode = @_edgeMode(options.edgeMode)
    @locale = @_locale(options.locale)
    @opens = @_opens(options.opens)

    @firstDayOfWeek.subscribe (newValue) ->
      MomentUtil.setFirstDayOfTheWeek(newValue)
    MomentUtil.setFirstDayOfTheWeek(@firstDayOfWeek())

  _firstDayOfWeek: (val) ->
    ko.observable(if val then val else 0) # default to Sunday (0)

  _timeZone: (val) ->
    ko.observable(val || 'UTC')

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
    ko.observable(moment.tz(val, @timeZone()))

  _maxDate: (val) ->
    val ||= moment()
    ko.observable(moment.tz(val, @timeZone()))

  _startDate: (val) ->
    val ||= moment().subtract(30, 'days')
    val = moment.tz(val, @timeZone())
    ko.observable(MomentUtil.fit(val, @minDate(), @maxDate()))

  _endDate: (val) ->
    val ||= moment()
    val = moment.tz(val, @timeZone())
    ko.observable(MomentUtil.fit(val, @minDate(), @maxDate()))

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
    val
