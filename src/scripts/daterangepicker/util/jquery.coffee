$.fn.daterangepicker = (options, callback) ->
  @each ->
    $element = $(this)
    unless $element.data('daterangepicker')
      options.anchorElement = $element
      options.callback = callback if callback
      $element.data('daterangepicker', new DateRangePickerView(options))
  this
