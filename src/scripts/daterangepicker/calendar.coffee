class Calendar
  constructor: (date, period, alignment) ->
    @date = date
    @period = period
    @alignment = alignment
    [cols, rows] = @period.dimentions()
    firstDate = @firstDateForCalendar()
    iterator = new MomentIterator(firstDate, @period())
    @calendar = for row in [1..rows]
      for col in [1..cols]
        if @alignment == 'end'
          iterator.next().endOf(@period())
        else
          iterator.next().startOf(@period())

  firstDateForCalendar: () ->
    firstDate = @date().clone().startOf(@period.scale())
    if @period.scale() == 'month'
      firstDayOfMonth = firstDate.clone()
      firstDate.weekday(0)
      if firstDate.isAfter(firstDayOfMonth) || firstDate.isSame(firstDayOfMonth, 'day')
        firstDate.subtract(1, 'week')
    else if @period() == 'year'
      firstDate = MomentUtil.firstYearOfDecade(firstDate)
    firstDate
