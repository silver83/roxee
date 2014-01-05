define [ 'jquery' ], ($) ->

  class API
    setProxy: ()->
      $.ajax
        url: "api/setProxy"
      .then (result, textStatus, jqXHR) ->
        alert(result.result)

  return new API()
