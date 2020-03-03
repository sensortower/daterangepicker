class View
  constructor: ->
    @dateRange = ko.observable([moment().subtract(29, 'days'), moment()])
    @dateRange2 = ko.observable([moment().subtract(29, 'days'), moment()])
    @dateRange3 = ko.observable([moment().subtract(29, 'days'), moment()])
    @dateRange4 = ko.observable([moment().subtract(29, 'days'), moment()])
    @dateRange5 = ko.observable([moment().subtract(29, 'days'), moment()])

    if $("body").is(".docs")
      parent = []
      @tree = []
      @activeItem = ko.observable()

      self = @

      @originalTop = $("aside").position().top

      $(".content h2, .content h3").each ->
        tagName = $(@).prop("tagName")

        obj =
          name: $(@).text()
          id: '#' + $(@).attr('id')

        $(@).data('anchor', obj)

        if tagName == 'H2'
          parent = [obj]
          self.tree.push(parent)
        else
          obj.parent = parent[0]
          parent.push(obj)

      @updateActiveItem()
      $(window).scroll =>
        @updateActiveItem()

    if $("body").is(".examples")
      $("pre").each ->
        code = $(this).text()
        nodeType =
          if $(this).children("code").is(".language-html")
            "div"
          else
            "script"
        wrapper = "<div class='example-wrapper'></div>"
        content = "<div><#{nodeType}>#{code}</#{nodeType}></div>"
        $(this).wrap(wrapper).parent().prepend(content)


  updateActiveItem: ->
    lastItem = null
    st = $(document.body).scrollTop()
    max = $(".content h2, .content h3").last().offset().top
    wh = $(window).height()
    $(".content h2, .content h3").each (i)->
      top = $(@).offset().top - 5
      if i == 0 || top < st
        lastItem = $(@).data('anchor')
    @activeItem(lastItem)
    $("aside").css(top: Math.max(@originalTop - st, 0))


$ ->
  ko.applyBindings(new View())

do ->
  drawRoundRect = (ctx, x, y, w, h, r, fill) ->
    ctx.beginPath()
    ctx.moveTo(x + r, y)
    ctx.lineTo(x + w - r, y)
    ctx.quadraticCurveTo(x + w, y, x + w, y + r)
    ctx.lineTo(x + w, y + h - r)
    ctx.quadraticCurveTo(x + w, y + h, x + w - r, y + h)
    ctx.lineTo(x + r, y + h)
    ctx.quadraticCurveTo(x, y + h, x, y + h - r)
    ctx.lineTo(x, y + r)
    ctx.quadraticCurveTo(x, y, x + r, y)
    ctx.closePath()
    ctx.fillStyle = fill
    ctx.fill()

  drawRectWithBorder = (ctx, x, y, w, h, r, border, fill, stroke) ->
    drawRoundRect(ctx, x, y, w, h, r, stroke)
    drawRoundRect(ctx, x + border, y + border, w - border * 2, h - border * 2, r - border, fill)

  drawText = (ctx, text, x, y, color) ->
    ctx.textAlign = "center"
    ctx.font = 'bold 9px sans-serif'
    ctx.fillStyle = color
    ctx.fillText(text, x, y, 16)

  canvasToFavicon = (canvas) ->
    link = document.createElement('link')
    link.type = 'image/x-icon'
    link.rel = 'shortcut icon'
    link.href = canvas.toDataURL('image/x-icon')
    document.getElementsByTagName('head')[0].appendChild link

  $ ->
    canvas = document.createElement('canvas')
    canvas.width = 16
    canvas.height = 16
    ctx = canvas.getContext('2d')

    drawRectWithBorder(ctx, 0, 2, 16, 14, 2, 1, '#20aa9c', '#1b8e82')
    drawRoundRect(ctx, 2, 1, 3, 3, 1.5, '#1b8e82')
    drawRoundRect(ctx, 11, 1, 3, 3, 1.5, '#1b8e82')
    drawText(ctx, moment().format('DD'), 8, 12.5, '#146960')
    drawText(ctx, moment().format('DD'), 8, 11.5, '#fff')

    canvasToFavicon(canvas)
