class CalendarView
  constructor: (mainView, dateSubscribable, type, minBoundary) ->
    @period = mainView.period
    @single = mainView.single
    @edgeMode = mainView.edgeMode
    @timeZone = mainView.timeZone
    @locale = mainView.locale
    @minDate = mainView.minDate
    @maxDate = mainView.maxDate
    @startDate = mainView.startDate
    @endDate = mainView.endDate

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

    @minBoundary = minBoundary || @minDate

    @activeDate.subscribe (newValue) =>
      @currentDate(newValue)

    @headerView = new CalendarHeaderView(@)

  calendar: ->
    new Calendar(@currentDate, @period, @type).calendar

  weekDayNames: ->
    moment.weekdaysMin()

  withinBoundaries: (date) =>
    exclusive = @edgeMode() == 'exclusive'
    date.isBetween(@minBoundary(), @maxDate(), @period()) || (!exclusive && (date.isSame(@minBoundary(), @period()) || date.isSame(@maxDate(), @period())))

  inRange: (date) =>
    date.isAfter(@startDate(), @period()) && date.isBefore(@endDate(), @period()) || (date.isSame(@startDate(), @period()) || date.isSame(@endDate(), @period()))

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
        @activeDate(date) if @withinBoundaries(date)
      mouseenter: =>
        @hoverDate(date) if @withinBoundaries(date)
      mouseleave: =>
        @hoverDate(null)
    }

  cssForDate: (date, periodIsDay) =>
    onRangeEnd = date.isSame(@activeDate(), @period())
    withinBoundaries = @withinBoundaries(date)
    periodIsDay ||= @period() == 'day'
    differentMonth = !date.isSame(@currentDate(), 'month')
    inRange = @inRange(date)
    {
      "in-range": !@single() && (inRange || onRangeEnd)
      "active": onRangeEnd
      "clickable": withinBoundaries
      "out-of-boundaries": !withinBoundaries
      "unavailable": (periodIsDay && differentMonth)
    }
