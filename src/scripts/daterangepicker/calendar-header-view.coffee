class CalendarHeaderView
  constructor: (calendarView) ->
    @currentDate = calendarView.currentDate
    @period = calendarView.period
    @config = calendarView.config
    @withinBoundaries = calendarView.withinBoundaries
    @fitWithinBoundaries = calendarView.fitWithinBoundaries

    @prevDate = ko.computed =>
      [amount, period] = @period.nextPageArguments()
      @currentDate().clone().subtract(amount, period)

    @nextDate = ko.computed =>
      [amount, period] = @period.nextPageArguments()
      @currentDate().clone().add(amount, period)

    @selectedMonth = ko.computed
      read: =>
        @currentDate().month()
      write: (newValue) =>
        newDate = @currentDate().clone().month(newValue)
        # TODO: don't write if the year is not in options
        unless newDate.isSame(@currentDate(), 'month')
          @currentDate(@fitWithinBoundaries(newDate))
      pure: true

    @selectedYear = ko.computed
      read: =>
        @currentDate().year()
      write: (newValue) =>
        newDate = @currentDate().clone().year(newValue)
        # TODO: don't write if the year is not in options
        unless newDate.isSame(@currentDate(), 'year')
          @currentDate(@fitWithinBoundaries(newDate))
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
          @currentDate(@fitWithinBoundaries(newDate))
      pure: true

  clickPrevButton: =>
    @currentDate(@fitWithinBoundaries(@prevDate()))

  clickNextButton: =>
    @currentDate(@fitWithinBoundaries(@nextDate()))

  prevAvailable: ->
    @withinBoundaries(@prevDate().clone().endOf(@period.scale()), true)

  nextAvailable: ->
    @withinBoundaries(@nextDate().clone().startOf(@period.scale()), true)



  monthOptions: ->
    month for month in [0..11] when @withinBoundaries(@currentDate().clone().month(month), true)

  yearOptions: ->
    [@config.minDate().year()..@config.maxDate().year()]

  decadeOptions: ->
    uniqArray( @yearOptions().map (year) =>
      MomentUtil.firstYearOfDecade(moment.tz([year], @config.timeZone())).year()
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
