define ['jquery', 'knockout', 'app/engine' ], ($, ko, engine) ->

  class RequestsView
    constructor: ($el, requestsModel) ->
      @hover = $('<div class="hovering-row" style="display:none"><img id="copy" src="images/copy.svg"/><img id="open" src="images/open.svg"/><span id="text"></span></div>')
      @hover.prependTo document.body

      @el = $el
      @requestsModel = requestsModel
      @requestsModel.on 'request.onBeforeAdd', @onBeforeAddRequest
      @requestsModel.on 'request.onAdded', @onRequestAdded

      $el.on 'click', 'tr', @onSelect
      $el.on 'mouseenter', 'td.url', @onHover
      $el.on 'mouseleave', 'td.url', @onLeave

    onSelect: (e) =>
      @requestsModel.onRequestSelected ko.dataFor(e.target)

    onHover: (e) =>
      @hover.show()

      $target = $(e.target)
      @hover.find('#text').text($target.text())

      offset = $target.offset()
      @hover.offset({ top: offset.top, left: offset.left - 74 })

    onLeave: (e) =>
      @hover.hide()

    onBeforeAddRequest: (req) =>
      # which element is the viewport restricting the @requests scroll content
      @scrollContainer = @el.offsetParent()

      # make scroller follow new content as it arrives
      @autoscroll = false

      # is at end of scroll ? https://developer.mozilla.org/en-US/docs/Web/API/element.scrollHeight?redirectlocale=en-US&redirectslug=DOM%2Felement.scrollHeight
      @autoscroll = true if @scrollContainer.prop('scrollHeight') - @scrollContainer.scrollTop() == @scrollContainer.prop('clientHeight')

    onRequestAdded: (req) =>
      row = @el.find("tr#r#{req.id}")

      #follow new content as it arrives
      if @autoscroll
        #cache offset().top - shouldn't change
        @scrollContainer._offsetTop = @scrollContainer.offset().top if !@scrollContainer._offsetTop
        @scrollContainer.scrollTop(row.offset().top - @scrollContainer._offsetTop + @scrollContainer.scrollTop())

    onResponse: (res) =>
      row = $("#r#{res.id}")
      row.find('.status').text(res.statusCode)
