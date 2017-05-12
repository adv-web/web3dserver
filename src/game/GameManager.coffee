# Created by duocai on 2017/5/2.

UUID = require('node-uuid')
class GameManager
  module.exports = this
  constructor: (@player) ->
    @id = UUID()
    @host = @player
    @players = {}
    @players[@player.id] = @player
    @playerCount = 1

  load: (comp) =>
    comp.onStartServerPlayer?()