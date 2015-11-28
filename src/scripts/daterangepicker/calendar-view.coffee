class CalendarView
  constructor: (mainView, dateSubscribable, type) ->
    @period = mainView.period
    @single = mainView.single
    @timeZone = mainView.timeZone
    @locale = mainView.locale
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
      pure: true

    @activeDate.subscribe (newValue) =>
      @currentDate(newValue)

    @headerView = new CalendarHeaderView(@)

  calendar: ->
    new Calendar(@currentDate, @period, @type).calendar

  weekDayNames: ->
    moment.weekdaysMin()

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
        @activeDate(date) if @activeDate.isWithinBoundaries(date)
      mouseenter: =>
        @hoverDate(date) if @activeDate.isWithinBoundaries(date)
      mouseleave: =>
        @hoverDate(null)
    }

  cssForDate: (date, periodIsDay) =>
    onRangeEnd = date.isSame(@activeDate(), @period())
    withinBoundaries = @activeDate.isWithinBoundaries(date)
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
