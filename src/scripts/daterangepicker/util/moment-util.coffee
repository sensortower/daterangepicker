class MomentUtil
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
    timeZone = date.tz && date.tz()
    # we use current year here so that it's always in the middle of the calendar
    currentYear =
      if timeZone
        moment().tz(timeZone).year()
      else
        moment().year()

    firstYear = currentYear - 4
    offset = Math.floor((date.year() - firstYear) / 9)
    year = firstYear + offset * 9
    @tz([year], timeZone)

  @tz: (input) ->
    args = Array.prototype.slice.call(arguments, 0, -1)
    timeZone = arguments[arguments.length - 1]
    if moment.tz
      moment.tz.apply(null, args.concat([timeZone]))
    else if timeZone == 'UTC'
      moment.utc.apply(null, args)
    else
      moment.apply(null, args)

