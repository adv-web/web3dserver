# Created by duocai on 2017/5/11.

NetWorkComponent = require('./NetWorkComponent')

# this component will automatically synchronize the transform of the game object
# it binds to.
#
# recall Network transform in the client. If you use NetworkTransform in the client.
# You must use this in the server.
class NetWorkTransform extends NetWorkComponent
  module.exports = @

  # @param [Socket] player a client socket
  constructor: (@player) ->
    super "NetWorkTransform"
    @networkSendRate = 1000


  # register the handler to handle the transform synchronization work.
  onRegister: () =>
    @player.on("nwtc", (data) =>
      for id, p of @player.game.players
        p.emit(data.event, data) if @player.id  != id
    )