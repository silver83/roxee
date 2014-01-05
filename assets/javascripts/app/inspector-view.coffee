define ['jquery', 'utils/tabs', 'templates', './inspector-headers-view'], ($, Tabs, templates, HeadersView) ->

  class InspectorView

    #public api
    constructor: ($elem, requestsModel) ->
      @requestsModel = requestsModel
      @elem = $elem
      tabs = new Tabs('#main')
      tabs.selectTab(0)

      headersTab = @elem.find('#inspector-headers.tab')
      @headersView = new HeadersView(headersTab)

    setRequest: (request) ->
      $('.tab.inspector').html('').append(JSON.stringify(request))