class DateRangePickerButton
  constructor: (element, options, cb) ->
    @options = options
    @element = $(element)
    @parent = @element.parent()
    @container = $(DateRangePickerView.template).appendTo(@parent)

    @setPosition()
    @setupMainView()
    @setupEvents()

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
    # @parent.css({ position: 'relative' })
    switch @options.opens
      when 'left'
        @container.css
          top: @element.offset().top + @element.outerHeight() - (parentOffset.top)
          right: parentRightEdge - (@element.offset().left) - @element.outerWidth()
          left: 'auto'
        if @container.offset().left < 0
          @container.css
            right: 'auto'
            left: 9
      else
        @container.css
          top: @element.offset().top + @element.outerHeight() - (parentOffset.top)
          left: @element.offset().left - (parentOffset.left)
          right: 'auto'
        if @container.offset().left + @container.outerWidth() > $(window).width()
          @container.css
            left: 'auto'
            right: 0

  setupMainView: () ->
    @view = new DateRangePickerView(@options)
    ko.cleanNode(@container.get(0))
    ko.applyBindings(@view, @container.get(0))

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
