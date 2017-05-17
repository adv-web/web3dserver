# Created by duocai on 2017/4/28.

# init express
app = require('express')()
# create a http server
server = require('http').Server(app)
# get socket io
io = require('socket.io')(server)
# server port
port = process.env.PORT || 5000



#start server (http server)
server.listen(port,()->
  console.log("server started at port: %s", port)
)


# Express server set up
ExpressServer = require('./ExpressServer')
new ExpressServer(app).start()
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