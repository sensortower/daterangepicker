class MomentIterator
  @array: (date, amount, period) ->
    iterator = new @(date, period)
    for i in [0..amount-1]
      iterator.next()

  constructor: (date, period) ->
    @date = date.clone()
    @period = period

  next: () ->
    nextDate = @date
    @date = nextDate.clone().add(1, @period)
    nextDate.clone()
