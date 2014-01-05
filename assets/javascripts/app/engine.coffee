define [ '_', 'backbone' ], (_, backbone) ->

  # not a simple backbone.collection due to relationship between requests and responses
  # emits the 'request.new' and 'response.new' events
  # if response arrived out of order, request.new may emit the request with response already attached.
  # in that case - no 'response.new' event will be emitted.
  # in other words : response.new will only be emitted for responsed which arrived _after_ we saw the request
  class Engine
    _port = 3001
    _requests = []
    _log =
      requests: true
      responses: true

    constructor: () ->
      _.extend(this, backbone.Events)

    connect: () =>
      socket = io.connect ':3001/'

      socket.on 'proxy.request',  @onRequest
      socket.on 'proxy.response', @onResponse
      socket.on 'connect_failed', () -> alert 'connect failed'
      socket.on 'error',          () -> alert 'error'

    parseRequest: (req) =>
      parser = document.createElement('a'); # free url parsing trick
      parser.href = req.url;

      req.protocol = parser.protocol; # => "http:"
      req.hostname = parser.hostname; # => "example.com"
      req.port = parser.port; # => "3000"
      req.pathname = parser.pathname; # => "/pathname/"
      req.search = parser.search; # => "?search=test"
      req.hash = parser.hash; # => "#hash"
      req.host = parser.host; # => "example.com:3000"

    onRequest: (req) =>
      console.log(req) if _log.requests

      @parseRequest req

      # handle out of order response - if response arrived before request - the placeholder will exist. otherwise - it will be a new object
      placeholder = _requests[req.id] || {}

      # which we throw back in to the array... just a trick
      _requests[req.id] = placeholder
      _.extend(placeholder, req)
      @trigger 'request.new', req

    onResponse: (res) =>
      console.log(res) if _log.responses
      req = _requests[res.id]

      # save responses which came out of order in a side buffer, waiting for their requests
      if (!req)
        placeholder = {}
        _requests[res.id] = placeholder
        placeholder.response = res;
        return

      req.response = res
      res.request = req
      @trigger 'response.new', res

  # singleton
  return new Engine()

