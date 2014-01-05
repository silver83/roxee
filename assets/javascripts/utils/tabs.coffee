define ['jquery', '_', 'css!/stylesheets/tabs'], ($, _)->
  class Tabs
    constructor: (id) ->
      @prefix = id.replace('#', '')
      @elem = $(id)
      @elem.on 'click', ".header *[data-href^=#{@prefix}]", (evt) =>
        target = $(evt.currentTarget)
        @selectTab target

      @children = {}
      @elem.find('.tabs').each (i, elem)->
        @children[elem.id] = new Tabs("\##{elem.id}")
        @children[elem.id].selectTab 0

    selectTab: (idxOrTab)->
      idxOrTab = idxOrTab[0] if idxOrTab instanceof $

      headers = @elem.find(".header *[data-href^=#{@prefix}]")
      tabs = @elem.find(".tab[id^=#{@prefix}]")

      idx = if $.isNumeric(idxOrTab) then idxOrTab else $.inArray(idxOrTab, headers)
      header = $(headers[idx])
      tabId = $(header).attr('data-href')
      tab = @elem.find("\##{tabId}")

      coll.removeClass 'selected' for coll in [ headers, tabs ]
      elem.addClass 'selected' for elem in [ header, tab]