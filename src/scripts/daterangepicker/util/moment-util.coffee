class MomentUtil
  @fit: (date, min, max) ->
    moment.max(moment.min(date, max), min)

  @patchCurrentLocale: (obj) ->
    moment.locale(moment.locale(), obj)

  @setFirstDayOfTheWeek: (dow) ->
    if moment.localeData().firstDayOfWeek() != dow
      offset = dow - moment.localeData().firstDayOfWeek()
      @patchCurrentLocale({
        weekdays: rotateArray(moment.weekdays(), offset)
        weekdaysMin: rotateArray(moment.weekdaysMin(), offset)
        weekdaysShort: rotateArray(moment.weekdaysShort(), offset)
        week: {
          dow: dow
          doy: moment.localeData().firstDayOfYear()
        }
      })

  @firstYearOfDecade: (date) ->
    # tz = @parent.tz()
    tz = 'UTC'
    # we use current year here so that it's always in the middle of the calendar
    currentYear = moment().tz(tz).year()
    firstYear = currentYear - 4
    offset = Math.floor((date.year() - firstYear) / 9)
    year = firstYear + offset * 9
    moment.tz([year], tz)
