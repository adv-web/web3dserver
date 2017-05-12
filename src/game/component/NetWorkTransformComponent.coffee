# Created by duocai on 2017/5/11.

NetWorkComponent = require('./NetWorkComponent')

class NetWorkTransformComponent extends NetWorkComponent
  module.exports = @

  constructor: (@player) ->
    super "NetWorkTransformComponent"
    @networkSendRate = 1000

  onStartServerPlayer: () =>
    @player.on("nwtc", (data) =>
      for id, p of @player.game.players
        p.emit(data.event, data) if @player.id  != id
    )