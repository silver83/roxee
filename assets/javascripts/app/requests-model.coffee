define [ 'knockout', 'backbone', 'app/engine' ], (ko, backbone, engine) ->

  class RequestsModel
    constructor: () ->
      @currentRequest = ko.observable(null)
      @requests = ko.observableArray([])
      @requestsById = {}

      engine.on 'request.new', @onRequest
      engine.on 'response.new', @onResponse
      _.extend(this, Backbone.Events);

    # when a request is clicked - set the current request
    onRequestSelected: (request) =>
      @currentRequest request

    onResponse: (response) =>
      request = @requestsById[response.id]
      request.status response.statusCode

    onRequest: (request) =>
      request.rid = "r#{request.id}"
      request.status = ko.observable(null)

      this.trigger 'request.onBeforeAdd', request
      @requests.push(request)
      @requestsById[request.id] = request
      this.trigger 'request.onAdded', request
