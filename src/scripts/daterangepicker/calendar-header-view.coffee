class CalendarHeaderView
  constructor: (calendarView) ->
    @currentDate = calendarView.currentDate
    @period = calendarView.period
    @timeZone = calendarView.timeZone

    @prevDate = ko.pureComputed =>
      [amount, period] = @period.nextPageArguments()
      @currentDate().clone().subtract(amount, period)

    @nextDate = ko.pureComputed =>
      [amount, period] = @period.nextPageArguments()
      @currentDate().clone().add(amount, period)

    @selectedMonth = ko.computed
      read: =>
        @currentDate().month()
      write: (newValue) =>
        newDate = @currentDate().clone().month(newValue)
        # TODO: don't write if the year is not in options
        unless newDate.isSame(@currentDate(), 'month')
          @currentDate(newDate)
      pure: true

    @selectedYear = ko.computed
      read: =>
        @currentDate().year()
      write: (newValue) =>
        newDate = @currentDate().clone().year(newValue)
        # TODO: don't write if the year is not in options
        unless newDate.isSame(@currentDate(), 'year')
          @currentDate(newDate)
      pure: true

    @selectedDecade = ko.computed
      read: =>
        MomentUtil.firstYearOfDecade(@currentDate()).year()
      write: (newValue) =>
        offset = (@currentDate().year() - @selectedDecade()) % 9
        newYear = newValue + offset
        newDate = @currentDate().clone().year(newYear)
        # TODO: don't write if the year is not in options
        unless newDate.isSame(@currentDate(), 'year')
          @currentDate(newDate)
      pure: true

  clickPrevButton: =>
    @currentDate(@prevDate())

  clickNextButton: =>
    @currentDate(@nextDate())

  prevArrowCss: ->
    date = @prevDate().clone().endOf(@period.scale())
    # TODO: handle decade properly
    {'arrow-hidden': !@currentDate.isWithinBoundaries(date)}

  nextArrowCss: ->
    date = @nextDate().clone().startOf(@period.scale())
    # TODO: handle decade properly
    {'arrow-hidden': !@currentDate.isWithinBoundaries(date)}



  monthOptions: ->
    minMonth = if @currentDate.minBoundary().isSame(@currentDate(), 'year') then @currentDate.minBoundary().month() else 0
    maxMonth = if @currentDate.maxBoundary().isSame(@currentDate(), 'year') then @currentDate.maxBoundary().month() else 11
    [minMonth..maxMonth]

  yearOptions: ->
    [@currentDate.minBoundary().year()..@currentDate.maxBoundary().year()]

  decadeOptions: ->
    uniqArray( @yearOptions().map (year) =>
      momentObj = MomentUtil.tz([year], @timeZone())
      MomentUtil.firstYearOfDecade(momentObj).year()
    )

  monthSelectorAvailable: ->
    @period() in ['day', 'week']

  yearSelectorAvailable: ->
    @period() != 'year'

  decadeSelectorAvailable: ->
    @period() == 'year'

  monthFormatter: (x) ->
    moment.utc([2015, x]).format('MMM')

  yearFormatter: (x) ->
    moment.utc([x]).format('YYYY')

  decadeFormatter: (from) ->
    [cols, rows] = Period.dimentions('year')
    to = from + cols * rows - 1
    "#{from} – #{to}"
