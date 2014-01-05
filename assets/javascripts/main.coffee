require
  #urlArgs: "b=#{(new Date()).getTime()}"
  paths:
    jquery: 'vendor/jquery/jquery'
    _: 'vendor/underscore/underscore'
    backbone: 'vendor/backbone/backbone'
    jquery_ui: 'vendor/jquery-ui/jquery-ui'
    knockout: 'vendor/knockout/knockout'
    foundation: 'vendor/foundation/foundation'
    modernizr: 'vendor/modernizr/modernizr'
    layout: 'vendor/jquery.layout/jquery.layout-latest'

  shim:
    'backbone':
      deps : ['_', 'jquery']
      exports : 'Backbone'
    '_':
      exports : '_'

  map:
    '*':
      'css': 'vendor/require-css/css'

  , ['jquery', 'jquery_ui']
  , ($)->
    require [ 'app/main-view', 'app/engine']
      , (MainView, engine) ->

        $(()->
          engine.connect(3001)

          view = new MainView()
          view.render $('body')
        )
