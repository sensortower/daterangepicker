$.fn.daterangepicker = (options, cb) ->
  @each ->
    el = $(this)
    unless el.data('daterangepicker')
      el.data('daterangepicker', new DateRangePickerButton(el, options, cb))
  this
