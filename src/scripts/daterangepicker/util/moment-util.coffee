class MomentUtil
  @patchCurrentLocale: (obj) ->
    moment.locale(moment.locale(), obj)

  @setFirstDayOfTheWeek: (dow) ->
    if moment.localeData().firstDayOfWeek() != dow
      offset = dow - moment.localeData().firstDayOfWeek()
      @patchCurrentLocale({
        weekdays: ArrayUtils.rotateArray(moment.weekdays(), offset)
        weekdaysMin: ArrayUtils.rotateArray(moment.weekdaysMin(), offset)
        weekdaysShort: ArrayUtils.rotateArray(moment.weekdaysShort(), offset)
        week: {
          dow: dow
          doy: moment.localeData().firstDayOfYear()
        }
      })

  @tz: (input) ->
    args = Array.prototype.slice.call(arguments, 0, -1)
    timeZone = arguments[arguments.length - 1]
    if moment.tz
      moment.tz.apply(null, args.concat([timeZone]))
    else if timeZone && timeZone.toLowerCase() == 'utc'
      moment.utc.apply(null, args)
    else
      moment.apply(null, args)
