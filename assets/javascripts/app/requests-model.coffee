define [ 'knockout', 'backbone', 'app/engine' ], (ko, backbone, engine) ->

  class RequestsModel
    constructor: () ->
      @currentRequest = ko.observable(null)
      @currentResponse = ko.observable(null)
      @requests = ko.observableArray([])
      @requestsById = {}

      engine.on 'request.new', @onRequest
      engine.on 'response.new', @onResponse
      _.extend(this, Backbone.Events);

    # when a request is clicked - set the current request
    onRequestSelected: (request) =>
      @currentRequest request
      @currentResponse request.response

    onResponse: (response) =>
      request = @requestsById[response.id]
      request.status response.statusCode
      request.response = response

      if (request.id == @currentRequest()?.id)
        @currentResponse(response)

    onRequest: (request) =>
      request.rid = "r#{request.id}"
      request.status = ko.observable(null)

      this.trigger 'request.onBeforeAdd', request
      @requests.push(request)
      @requestsById[request.id] = request
      this.trigger 'request.onAdded', request
