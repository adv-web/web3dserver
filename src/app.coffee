# Created by duocai on 2017/4/28.

# init express
app = require('express')()
# create a http server
server = require('http').Server(app)
# get socket io
io = require('socket.io')(server)
# server port
port = process.env.PORT || 5000

verbose = true


#start server (http server)
server.listen(port,()->
  console.log("server started at port: %s", port)
)


# Express server set up
# express router
app.get('/', (req, res) ->
  res.sendFile(__dirname + '/index.html')
)
# set all Access-Control-Allow-Origin
app.all('/*', (req, res, next) ->
  res.header("Access-Control-Allow-Origin", "*")
  res.header('Access-Control-Allow-Methods', 'PUT, GET, POST, DELETE, OPTIONS')
  res.header("Access-Control-Allow-Headers", "X-Requested-With")
  res.header('Access-Control-Allow-Headers', 'Content-Type')
  next()
)
# other specific services
ExpressServer = require('./ExpressServer')
new ExpressServer(app).start()
# This handler will listen for requests on /*, any file from the root of our server.
# See expressjs documentation for more info on routing.
app.get( '/*' , ( req, res) ->
# This is the current file they have requested
  file = req.params[0]

  # For debugging, we can track what files are requested.
  console.log('\t :: Express :: file requested : ' + file) if verbose

  # Send the requesting client the file.
  res.sendfile( __dirname + '/' + file )
)# app.get *
# end of Express Server


# Socket.IO server set up. */
# Express and socket.io can work together to serve the socket.io client files for you.
# This way, when the client requests '/socket.io/' files, socket.io determines what the client needs.

# Enter the game server code. The game server handles
GameServer = require('./game/GameServer')
new GameServer(io).start()

# start a chat server
ChatServer = require('./game/ChatServer')
new ChatServer(io).start()