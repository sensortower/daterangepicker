class JqueryWrapper
  constructor: (element, options, cb) ->
    @view = new DateRangePickerView(options)
    @element = $(element)
    @parent = $('body')
    wrapper = $("<div data-bind=\"stopBinding: true\"></div>").appendTo(@parent)
    @container = $(DateRangePickerView.template).appendTo(wrapper)

    @setPosition()
    @setupMainView()
    @setupEvents()

    @view.dateRange.subscribe (newValue) =>
      [startDate, endDate] = newValue
      cb(startDate, endDate, @view.period())

  setPosition: () ->
    parentOffset =
      top: 0
      left: 0
    parentRightEdge = $(window).width()
    if !@parent.is('body')
      parentOffset =
        top: @parent.offset().top - @parent.scrollTop()
        left: @parent.offset().left - @parent.scrollLeft()
      parentRightEdge = @parent[0].clientWidth + @parent.offset().left

    top = (@element.offset().top + @element.outerHeight() - (parentOffset.top)) + 'px'
    left = 'auto'
    right = 'auto'

    switch @view.opens
      when 'left'
        if @container.offset().left < 0
          left = '9px'
        else
          right = (parentRightEdge - (@element.offset().left) - @element.outerWidth()) + 'px'
      else
        if @container.offset().left + @container.outerWidth() > $(window).width()
          right = '0'
        else
          left = (@element.offset().left - (parentOffset.left)) + 'px'

    @view.style
      top: top
      left: left
      right: right

  setupMainView: () ->
    ko.applyBindings(@view, @container.get(0));

  setupEvents: () ->
    $doc = $(document)
    $doc.on('mousedown.daterangepicker', @outsideClick)
    $doc.on('touchend.daterangepicker', @outsideClick)
    $doc.on('click.daterangepicker', '[data-toggle=dropdown]', @outsideClick)
    $doc.on('focusin.daterangepicker', @outsideClick)
    @element.click =>
      @setPosition()
      @view.toggle()

  outsideClick: (event) =>
    target = $(event.target)
    unless event.type == 'focusin' || target.closest(@element).length || target.closest(@container).length || target.closest('.calendar').length
      @view.close()
