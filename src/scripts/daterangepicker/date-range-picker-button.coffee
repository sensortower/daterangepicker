class DateRangePickerButton
  constructor: (element, options, cb) ->
    $element = $(element)
    $parent = $element.parent()
    $container = $("<div></div>").html(DateRangePickerView.template).appendTo($parent)
    parentOffset =
      top: 0
      left: 0
    parentRightEdge = $(window).width()
    if !$parent.is('body')
      parentOffset =
        top: $parent.offset().top - $parent.scrollTop()
        left: $parent.offset().left - $parent.scrollLeft()
      parentRightEdge = $parent[0].clientWidth + $parent.offset().left

    @view = new DateRangePickerView(options)

    ko.cleanNode($container.get(0))
    ko.applyBindings(@view, $container.get(0))
    $container.css
      top: $element.offset().top + $element.outerHeight() - parentOffset.top
      right: parentRightEdge - $element.offset().left - $element.outerWidth()

    $doc = $(document)
    $doc.on('mousedown.daterangepicker', @outsideClick)
    $doc.on('touchend.daterangepicker', @outsideClick)
    $doc.on('click.daterangepicker', '[data-toggle=dropdown]', @outsideClick)
    $doc.on('focusin.daterangepicker', @outsideClick)

    $element.click =>
      @view.toggle()

    @element = $element.get(0)
    @container = $container.get(0)

  outsideClick: (event) =>
    target = $(event.target)
    unless event.type == 'focusin' || target.closest(@element).length || target.closest(@container).length || target.closest('.calendar').length
      @view.close()
