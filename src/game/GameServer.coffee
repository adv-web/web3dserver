# Created by duocai on 2017/5/10.

#Import shared game library code.
GameManager = require('./GameManager')
NetWorkTransform = require('./component/NetWorkTransform')
TreeLoader = require('./component/TreeLoader')
GameTimeInformer = require('./component/GameTimeInformer')
# UUID
UUID = require('node-uuid')
verbose = true

# This class handle the message about players create a game, players join
# a game, players leave a game and host start a game and so on. these messages
# are same for all games.
#
# It's namespace is /game
class GameServer
  module.exports = this

  # build a game server
  #
  # @param [SocketIO] a socket io
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
      client.on('user.info.update', (m) => @onMessage(client, m))
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

  # @nodoc
  onMessage: (player,mess) =>
    player.info = mess
    player.game?.updateUserInfo()

  # @private
  _onMessage: (player,mess) =>

  # let the player find a game automatically
  # @param [Socket] player a client socket
  findGame: (player) =>
    joined = false
    for key, game of @games
      if game.playerCount < @maxPlayer
        joined = true
        @_joinGame(player, game)
        game.startGame() if not game.started and game.playerCount == @maxPlayer
        break
    # if there is no proper game, create a new one
    if not joined
      @_createGame(player)
    console.log("we have " + @gameCount + " games")

  # destroy the game
  # @param [Object] the game to ended
  destroyGame: (game) =>
    delete @games[game.id]
    @gameCount--
    console.log("game " + game.id + " was destroyed.")
    console.log("we have " + @gameCount + " games.")


  # let the player join the game
  # @param [Socket] player the player socket that will join the game.
  # @private
  _joinGame: (player, game) =>
    player.send("s.j."+game.id) # tell the player he/she joined a game

    # store the player message
    game.addPlayer(player)
    # load the component that automatically synchronize the transform if this player
    game.registerComponent(new NetWorkTransform(player))
    # log message
    console.log('player ' + player.id + ' joined a game with id ' + player.game.id)

  # create a game
  # @param [Socket] player the player that will host the game
  # @private
  _createGame: (player) =>

    # create a game
    game = new GameManager(player,@)

    #  Store it in the list of game
    @games[game.id] = game
    # Keep track
    @gameCount++

    # load the component that automatically synchronize the transform if this player
    game.registerComponent(new NetWorkTransform(player))
    # load the component that will init tree when the game starts
    game.registerComponent(new TreeLoader())
    # load game time informer
    game.registerComponent(new GameTimeInformer())


    # tell the player that they are now the host
    # s=server message, h=you are hosting
    player.hosting = true
    player.send('s.h.'+ game.id)
    console.log('player ' + player.id + ' created a game with id ' + player.game.id)

    # return it
    return game



