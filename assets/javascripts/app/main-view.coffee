define ['jquery', 'knockout', 'templates', './requests-view', './requests-model', './inspector-view', './api', 'modernizr', 'foundation', 'layout' ],\
        ($, ko, templates, RequestsView, RequestsModel, InspectorView, api) ->

  class MainView

    render: ($container) =>
      # main layout
      $elements = $(templates.main({name:'Jade', css:'sass'}))
      $container.append $elements

      [ navBar, layoutContainer ] = $elements
      [ $navBar, $layoutContainer ] = [ $(navBar), $(layoutContainer) ]

      # initialize foundation
      # foundation dom elements that need js support must exist on the page before calling this method
      $(document).foundation()

      @setupLayout $layoutContainer

      @requestsModel = new RequestsModel
      @requestsView = new RequestsView $layoutContainer.find('.requests tbody'), @requestsModel
      @inspectorView = new InspectorView $layoutContainer.find('#inspector.tabs'), @requestsModel

      $elements.find('#set-proxy.button').click @onSetProxy

      ko.applyBindings(@requestsModel);

    setupLayout: (layoutContainer) =>
      # perform ui-layout : http://layout.jquery-dev.net/
      $(layoutContainer).layout
        resizable:              true
        slidable:               true
        livePaneResizing:       true
        west:
          minSize: 0.3
          fxName: "slide"
          fxSpeed: "slow"
          animatePaneSizing: true
          padding: 0

        stateManagement__enabled: true
        showDebugMessages: true

    onSetProxy: () =>
      api.setProxy()

  MainView