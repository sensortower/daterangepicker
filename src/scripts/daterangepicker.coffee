#= require "./daterangepicker/util/moment-util.coffee"
#= require "./daterangepicker/util/moment-iterator.coffee"
#= require "./daterangepicker/util/array-utils.coffee"
#= require "./daterangepicker/util/jquery.coffee"
#= require "./daterangepicker/util/knockout.coffee"
#= require "./daterangepicker/date-range.coffee"
#= require "./daterangepicker/period.coffee"
#= require "./daterangepicker/config.coffee"
#= require "./daterangepicker/calendar-header-view.coffee"
#= require "./daterangepicker/calendar-view.coffee"
#= require "./daterangepicker/date-range-picker-view.coffee"
#= require "./daterangepicker/jquery-wrapper.coffee"

DateRangePickerView.template = '
  #= require "./../templates/daterangepicker.html"
'

# Simplifies monkey-patching
$.extend $.fn.daterangepicker,
  ArrayUtils: ArrayUtils
  MomentIterator: MomentIterator
  MomentUtil: MomentUtil
  Period: Period
  Config: Config
  DateRange: DateRange
  AllTimeDateRange: AllTimeDateRange
  CustomDateRange: CustomDateRange
  DateRangePickerView: DateRangePickerView
  CalendarView: CalendarView
  CalendarHeaderView: CalendarHeaderView
