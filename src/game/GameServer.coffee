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
    @gameCount = 0

  onMessage: (player,mess) =>

  _onMessage: (player,mess) =>

  findGame: (player) =>
    if @gameCount > 0
      for key, game of @games
        @_joinGame(player, game)
        return;
    else
      @_createGame(player)
    console.log("we have " + @gameCount + " games")

  _joinGame: (player, game) =>
    player.send("s.j."+game.id) # tell the player he/she joined a game

    # tell the player others joined
    for key, player2 of game.players
      player2.send("s.oj."+player.id)
      player.send("s.oj."+player2.id)

    # store the player message
    player.game = game
    game.playerCount++
    game.players[player.id] = player
    game.load(new NetWorkTransformComponent(player))

    # log message
    console.log('player ' + player.userid + ' joined a game with id ' + player.game.id)

  _createGame: (player) =>

    # create a game
    game = new GameManager(player)

    #  Store it in the list of game
    @games[game.id] = game
    # Keep track
    @gameCount++

    game.load(new NetWorkTransformComponent(player))

    # tell the player that they are now the host
    # s=server message, h=you are hosting
    player.send('s.h.'+ game.id)
    console.log('server host at  ' + game?.local_time)
    player.game = game
    player.hosting = true

    console.log('player ' + player.id + ' created a game with id ' + player.game.id)

    # return it
    return game



