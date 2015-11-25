$.fn.daterangepicker = (options, cb) ->
  @each ->
    el = $(this)
    unless el.data('daterangepicker')
      el.data('daterangepicker', new JqueryWrapper(el, options, cb))
  this
