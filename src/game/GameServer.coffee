# Created by duocai on 2017/5/10.

# UUID
UUID = require('node-uuid')
verbose = true
# Since we are sharing code with the browser, we
# are going to include some values to handle that.
global.window = global.document = global

#Import shared game library code.
GameManager = require('./GameManager')
NetWorkTransformComponent = require('./component/NetWorkTransformComponent')

class GameServer
  module.exports = this

  constructor: (io) ->
    @games = {} # store all games
    @maxPlayer = 2 # max player number of a game
    @gameCount = 0 #
    @io = io.of('/game') # register namespace to /game

  # client connections looking for a game, creating games,
  # leaving games, joining games and ending games when they leave.
  start: () =>
    # Socket.io will call this function when a client connects,
    # So we can send that client looking for a game to play,
    # as well as give that client a unique ID to use so we can
    # maintain the list if players.
    @io.on('connection', (client) =>
    # here, 'client' is a socket
    # Generate a new UUID, looks something like
    # 5b2ca132-64bd-4513-99da-90e838ca47d1
    # and store this on their socket/connection
      client.id = UUID()

      # tell the player they connected, giving them their id
      client.emit('onconnected', { id: client.id } )

      # Useful to know when someone connects
      console.log('\t socket.io:: player ' + client.id + ' connected')

      # now we can find them a game to play with someone.
      # if no game exists with someone waiting, they create one and wait.
      @findGame(client)

      # Now we want to handle some of the messages that clients will send.
      # They send messages here, and we send them to the gameServer to handle.
      client.on('message', (m) => @onMessage(client, m))
      # 'client.on message' will listen to the message from this l

      # When this client disconnects, we want to tell the game server
      # about that as well, so it can remove them from the game they are
      # in, and make sure the other player knows that they left and so on.
      client.on('disconnect',() =>
        # Useful to know when soomeone disconnects
        console.log('\t socket.io:: client ' + client.id + ' disconnected game  ' + client.game.id)
        # remove the player from his game if he is in some game
        client.game?.removePlayer(client)
      ) #client.on disconnect
    ) # sio.sockets.on connection

  onMessage: (player,mess) =>

  _onMessage: (player,mess) =>

  findGame: (player) =>
    joined = false
    for key, game of @games
      if game.playerCount < @maxPlayer
        joined = true
        @_joinGame(player, game)
        @_startGame(game) if not game.started and game.playerCount == @maxPlayer
        break
    # if there is no proper game, create a new one
    if not joined
      @_createGame(player)
    console.log("we have " + @gameCount + " games")

  endGame: (game) =>
    delete @games[game.id]
    @gameCount--
    console.log("game " + game.id + " was destroyed.")
    console.log("we have " + @gameCount + " games.")

  _startGame:(game) =>
    game.startGame()
    game.started = true

  # join a game
  _joinGame: (player, game) =>
    player.send("s.j."+game.id) # tell the player he/she joined a game

    # tell the player others joined
    for key, player2 of game.players
      player2.send("s.oj."+player.id)
      player.send("s.oj."+player2.id)

    # store the player message
    game.addPlayer(player)
    # load the component that automatically synchronize the transform if this player
    game.load(new NetWorkTransformComponent(player))
    # log message
    console.log('player ' + player.id + ' joined a game with id ' + player.game.id)

  # create a game
  _createGame: (player) =>

    # create a game
    game = new GameManager(player,@)

    #  Store it in the list of game
    @games[game.id] = game
    # Keep track
    @gameCount++

    # load the component that automatically synchronize the transform if this player
    game.load(new NetWorkTransformComponent(player))

    # tell the player that they are now the host
    # s=server message, h=you are hosting
    player.hosting = true
    player.send('s.h.'+ game.id)
    console.log('player ' + player.id + ' created a game with id ' + player.game.id)

    # return it
    return game



