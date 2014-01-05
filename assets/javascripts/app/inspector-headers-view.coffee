define ['jquery'], ($) ->

  class HeadersView

    #public api
    constructor: ($container, inspectorModel) ->
      @inspectorModel = inspectorModel
      $container.layout
        center:
          paneSelector: ".headers-center"
        south:
          paneSelector:   ".headers-south"
          size: "50%"

      @requestElem = $container.find('#headers-request')
      @responseElem = $container.find('#headers-response')