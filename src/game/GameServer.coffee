# Created by duocai on 2017/5/10.

verbose = true
# Since we are sharing code with the browser, we
# are going to include some values to handle that.
global.window = global.document = global

#Import shared game library code.
GameManager = require('./GameManager')
NetWorkTransformComponent = require('./component/NetWorkTransformComponent')

class GameServer
  module.exports = this

  constructor: () ->
    @games = {}
    @maxPlayer = 2
    @gameCount = 0

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



