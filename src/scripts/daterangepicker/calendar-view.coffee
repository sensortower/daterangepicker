class CalendarView
  constructor: (config, dateSubscribable, alignment, label, minBoundary) ->
    @config = config
    @period = config.period
    @alignment = alignment
    @label = label

    @hoverDate = ko.observable(null)
    @activeDate = dateSubscribable
    @currentDate = ko.observable(@activeDate().clone())

    @inputDate = ko.computed
      read: =>
        (@hoverDate() || @activeDate()).format(@config.locale.inputFormat)
      write: (newValue) =>
        newDate = moment(newValue, @config.locale.inputFormat)
        if newDate.isValid()
          @activeDate(@fitWithinBoundaries(newDate))

    @minBoundary = ko.pureComputed =>
      if minBoundary
        minBoundary()
      else
        @config.minDate()

    @activeDate.subscribe (newValue) =>
      @currentDate(newValue)

    @minBoundary.subscribe (newValue) =>
      if @currentDate().isBefore(newValue)
        @currentDate(newValue.clone())

    @headerView = new CalendarHeaderView(@)

  calendar: ->
    new Calendar(@currentDate, @period, @alignment).calendar

  weekDayNames: ->
    moment.weekdaysMin()

  withinBoundaries: (date, inclusive) =>
    date.isBetween(@minBoundary(), @config.maxDate(), @period()) || (inclusive && (date.isSame(@minBoundary(), @period()) || date.isSame(@config.maxDate(), @period())))

  fitWithinBoundaries: (date) =>
    MomentUtil.fit(date, @minBoundary(), @config.maxDate())

  inRange: (date) =>
    date.isAfter(@config.startDate(), @period()) && date.isBefore(@config.endDate(), @period()) || (date.isSame(@config.startDate(), @period()) || date.isSame(@config.endDate(), @period()))

  formatDate: (date) =>
    format = @period.format()
    switch @period()
      when 'day', 'month', 'year'
        "<div class='table-value'>
          #{date.format(format)}
        </div>"
      when 'week'
        date = date.clone().startOf(@period())
        MomentIterator.array(date, 7, 'day').map( (date) =>
          clazz = "week-day"
          clazz += " unavailable" if @cssForDate(date, true).unavailable
          "<div class='table-value #{clazz}'>
            #{date.format(format)}
          </div>"
        ).join("")
      when 'quarter'
        quarter = date.format(format)
        date = date.clone().startOf('quarter')
        months = MomentIterator.array(date, 3, 'month').map (date) ->
          date.format('MMM')
        "<div class='table-value'>
          #{quarter}
          <br>
          <span class='months'>
            #{months.join(", ")}
          </span>
        </div>"

  formatDateTemplate: (date) =>
    { nodes: $("<div>#{@formatDate(date)}</div>").children() }

  eventsForDate: (date) =>
    {
      click: =>
        @activeDate(@fitWithinBoundaries(date)) if @withinBoundaries(date, true)
      mouseenter: =>
        @hoverDate(@fitWithinBoundaries(date)) if @withinBoundaries(date, true)
      mouseleave: =>
        @hoverDate(null)
    }

  cssForDate: (date, periodIsDay) =>
    onRangeEnd = date.isSame(@activeDate(), @period())
    withinBoundaries = @withinBoundaries(date, true)
    periodIsDay ||= @period() == 'day'
    differentMonth = !date.isSame(@currentDate(), 'month')
    inRange = @inRange(date)
    {
      "in-range": !@config.single() && (inRange || onRangeEnd)
      "active": onRangeEnd
      "clickable": withinBoundaries
      "out-of-boundaries": !withinBoundaries
      "unavailable": (periodIsDay && differentMonth)
    }
