class Period
  @allPeriods: [
    'day'
    'week'
    'month'
    'quarter'
    'year'
  ]

  @scale: (period) ->
    if period in ['day', 'week'] then 'month' else 'year'

  @showWeekDayNames: (period) ->
    if period in ['day', 'week'] then true else false

  @nextPageArguments: (period) ->
    amount = if period == 'year' then 9 else 1
    scale = @scale(period)
    [amount, scale]

  @format: (period) ->
    switch period
      when 'day', 'week'
        'D'
      when 'month'
        'MMM'
      when 'quarter'
        '\\QQ'
      when 'year'
        'YYYY'

  @title: (period) ->
    switch period
      when 'day'
        'Day'
      when 'week'
        'Week'
      when 'month'
        'Month'
      when 'quarter'
        'Quarter'
      when 'year'
        'Year'

  @dimentions: (period) ->
    switch period
      when 'day'
        [7, 6]
      when 'week'
        [1, 6]
      when 'month'
        [3, 4]
      when 'quarter'
        [2, 2]
      when 'year'
        [3, 3]

  @methods: [
    'scale',
    'showWeekDayNames',
    'nextPageArguments',
    'format',
    'title',
    'dimentions'
  ]

  @extendObservable: (observable) ->
    @methods.forEach (method) ->
      observable[method] = -> Period[method](observable())
    observable
