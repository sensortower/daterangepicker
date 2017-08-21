class CalendarView
  constructor: (mainView, dateSubscribable, type) ->
    @allEvents = mainView.allEvents
    @period = mainView.period
    @single = mainView.single
    @timeZone = mainView.timeZone
    @locale = mainView.locale
    @startDate = mainView.startDate
    @endDate = mainView.endDate
    @isCustomPeriodRangeActive = mainView.isCustomPeriodRangeActive

    @type = type
    @label = mainView.locale["#{type}Label"] || ''

    @hoverDate = ko.observable(null)
    @activeDate = dateSubscribable
    @currentDate = dateSubscribable.clone()

    @inputDate = ko.computed
      read: =>
        (@hoverDate() || @activeDate()).format(@locale.inputFormat)
      write: (newValue) =>
        newDate = MomentUtil.tz(newValue, @locale.inputFormat, @timeZone())
        @activeDate(newDate) if newDate.isValid()
      pure: true

    @firstDate = ko.pureComputed () =>
      date = @currentDate().clone().startOf(@period.scale())
      switch @period()
        when 'day', 'week'
          firstDayOfMonth = date.clone()
          date.weekday(0)
          if date.isAfter(firstDayOfMonth) || date.isSame(firstDayOfMonth, 'day')
            date.subtract(1, 'week')
        when 'year'
          date = @firstYearOfDecade(date)
      date

    @lastDate = ko.pureComputed () =>
      date = @currentDate().clone().endOf(@period.scale())
      switch @period()
        when 'day', 'week'
          firstDate = @firstDate().clone()
          date = firstDate.add(6, 'week').subtract(1, 'day')
        when 'year'
          date = @lastYearOfDecade(date)
      date

    @activeDate.subscribe (newValue) =>
      @currentDate(newValue)

    @headerView = new CalendarHeaderView(@)

  calendar: ->
    [cols, rows] = @period.dimentions()
    iterator = new MomentIterator(@firstDate(), @period())
    for row in [1..rows]
      for col in [1..cols]
        date = iterator.next()
        if @type == 'end'
          date.endOf(@period())
        else
          date.startOf(@period())

  weekDayNames: ->
    ArrayUtils.rotateArray(moment.weekdaysMin(), moment.localeData().firstDayOfWeek())

  inRange: (date) =>
    date.isAfter(@startDate(), @period()) && date.isBefore(@endDate(), @period()) || (date.isSame(@startDate(), @period()) || date.isSame(@endDate(), @period()))

  isEvent: (date) =>
    ref = @allEvents()
    for j in ref
      if (date.isSame(j, 'year') && date.isSame(j, 'month') && date.isSame(j, 'day'))
        return true
    return false


  tableValues: (date) =>
    format = @period.format()
    switch @period()
      when 'day', 'month', 'year'
        [{
          html: date.format(format)
        }]
      when 'week'
        date = date.clone().startOf(@period())
        MomentIterator.array(date, 7, 'day').map( (date) =>
          {
            html: date.format(format)
            css:
              'week-day': true
              unavailable: @cssForDate(date, true).unavailable
          }
        )
      when 'quarter'
        quarter = date.format(format)
        date = date.clone().startOf('quarter')
        months = MomentIterator.array(date, 3, 'month').map (date) ->
          date.format('MMM')
        [{
          html: "#{quarter}<br><span class='months'>#{months.join(", ")}</span>"
        }]

  formatDateTemplate: (date) =>
    { nodes: $("<div>#{@formatDate(date)}</div>").children() }

  eventsForDate: (date) =>
    {
      click: =>
        @activeDate(date) if @activeDate.isWithinBoundaries(date)
      mouseenter: =>
        @hoverDate(@activeDate.fit(date)) if @activeDate.isWithinBoundaries(date)
      mouseleave: =>
        @hoverDate(null)
    }

  cssForDate: (date, periodIsDay) =>
    onRangeEnd = date.isSame(@activeDate(), @period())
    withinBoundaries = @activeDate.isWithinBoundaries(date)
    periodIsDay ||= @period() == 'day'
    differentMonth = !date.isSame(@currentDate(), 'month')
    inRange = @inRange(date)
    isEvent = @isEvent(date)
    {
      "in-range": !@single() && (inRange || onRangeEnd)
      "#{@type}-date": onRangeEnd
      "allEvents": !@single() && (inRange || onRangeEnd) && isEvent
      "clickable": withinBoundaries && !@isCustomPeriodRangeActive()
      "out-of-boundaries": !withinBoundaries || @isCustomPeriodRangeActive()
      "unavailable": (periodIsDay && differentMonth)
    }

  firstYearOfDecade: (date) ->
    # we use current year here so that it's always in the middle of the calendar
    currentYear = MomentUtil.tz(moment(), @timeZone()).year()
    firstYear = currentYear - 4
    offset = Math.floor((date.year() - firstYear) / 9)
    year = firstYear + offset * 9
    MomentUtil.tz([year], @timeZone()).startOf('year')

  lastYearOfDecade: (date) ->
    # we use current year here so that it's always in the middle of the calendar
    currentYear = MomentUtil.tz(moment(), @timeZone()).year()
    lastYear = currentYear + 4
    offset = Math.ceil((date.year() - lastYear) / 9)
    year = lastYear + offset * 9
    MomentUtil.tz([year], @timeZone()).endOf('year')