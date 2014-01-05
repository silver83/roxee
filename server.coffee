express =   require 'express'
http    =   require 'http'
engines =   require 'consolidate'
routes  =   require './routes'
sockio  =   require 'socket.io'
url =       require 'url'

sysconf =   require 'node-sysconf'

exports.startProxy = (proxyPort, io)->
  httpProxy = require('http-proxy')

  proxy = new httpProxy.RoutingProxy();
  id = 0
  s = httpProxy.createServer((req, res, proxy) ->
    try
      req.__id = ++id
      console.log [ 'request', req.__id, req.url ]

      io.sockets.emit 'proxy.request',
        id: id
        headers: req.headers
        body: req.body
        url: req.url #can't send entire request object

      buffer = httpProxy.buffer req

      reqParts = url.parse req.url
      proxy.proxyRequest req, res,
        host: reqParts.hostname,
        port: reqParts.port ? 80,
        buffer: buffer
    catch e
      console.error e

  ).listen(proxyPort);

  s.proxy.on 'end', (req, res) ->
    console.log [ 'response', res ]
    try
      io.sockets.emit 'proxy.response',
        id: req.__id
        headers: res._headers
        body: res.body
        statusCode: res.statusCode
    catch e
      console.error e

  s.proxy.on 'middlewareError', (err, req, res) ->
    console.error err
    res.end()


exports.startServer = (config, callback) ->
  port = process.env.PORT or config.server.port
  proxyPort = 8080
  ioLogLevel = 1 # error

  # this setup allows express and socket.io to be served from same port. might be worth revisiting this decision with perf tests.
  app = express()
  server = http.createServer(app)

  # io = sockio.listen(server);
  io = sockio.listen(3001);
  io.sockets.on 'connection', (socket) ->
    console.log('client is here!')

  this.startProxy(proxyPort, io)

  # some custom log config
  io.set('log level', ioLogLevel)

  server.listen port, ->
    console.log "Express server listening on port %d in %s mode", server.address().port, app.settings.env

  app.configure ->
    app.set 'port', port
    app.set 'views', config.server.views.path
    app.engine config.server.views.extension, engines[config.server.views.compileWith]
    app.set 'view engine', config.server.views.extension
    app.use express.favicon()
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.compress()
    app.use config.server.base, app.router
    app.use express.static(config.watch.compiledDir)

  #app.configure 'development', ->
    #app.use express.errorHandler()

  try
    app.get '/', routes.index(config)
    app.get '/api/setProxy', (req, res) ->
      res.type 'application/json'
      result = sysconf.proxySetConfig('127.0.0.1', proxyPort, 1)
      res.json { status: 'ok', result: result }

  catch e
    console.error(e)
    console.log(e.stack)

  callback(server, io)

  # callback(s)




