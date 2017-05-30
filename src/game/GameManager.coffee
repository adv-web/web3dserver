# Created by duocai on 2017/5/2.
UUID = require('node-uuid')

# There is a 'game manager' for each game lobby.  And it's work is
# focused on handle messages about this game, such as spawn object in
# the scene, destroy the object, update the status of the object and so on.
class GameManager
  module.exports = this

  # initialize the Network Manager
  #   @param player [object] the socket of the first player of this lobby, and he will be the host
  constructor: (@host,@server) ->
      @id = UUID()
      @objectUpdateEvent = "object.update"
      @players = {}
      @playerCount = 0
      @objects ={}
      @addPlayer(@host)
      @_registerObjectUpdate(@host)

  startGame: () =>
    for id, p of @players
      p.send('s.s')
    @loadTree();

  loadTree: () =>
    # tree
    for i in [9..14]
      for j in [9..14]
        data = {
          action: 's'
          message:{}
          prefab: "loadTree"
        }
        data.message.x = i * 0.48 - 5.76 + Math.random() * 0.3 - 0.15
        data.message.y = j * 0.48 - 5.76 + Math.random() * 0.3 - 0.15
        @spawn(data, {id: 'server'})

  # some codes to decide whether this operation is legal
  # if legal
  # objectId = UUID() # and store it add to data
  # data.objectId = objectId
  # allsockets.emit("object.update", data)
  #   @param [Object] data.action, and others are about the position
  #     and rotation of the object to be spawned
  spawn: (data, reqPlayer) =>
    data.objectId = UUID();
    # store it
    @objects[data.objectId] = data
    data.reqPlayerId = reqPlayer.id
    # send message to all clients
    for id, p of @players
      p.emit(@objectUpdateEvent,data)

  # some codes to decide whether this operation is legal
  # if legal
  # remove id from the storage pool
  # allsockets.destroy("object.update", data)
  #   @param data Object
  destroy: (data, reqPlayer) =>
    # destroy success
    if @objects[data.objectId] isnt undefined
      delete @objects[data.objectId]
      reqPlayer.emit(data.callback,true)
      for id, p of @players
        p.emit(@objectUpdateEvent,data) if id isnt reqPlayer.id
    else
      reqPlayer.emit(data.callback,false)

  # check whether it's legal
  # update the status if it's legal
  #   @param [Object] data.action is same as above, and other is some
  #     messages that need to be updated
  update: (data, reqPlayer) =>
    # some checks may be done in the future
    for id, p of @players
      p.emit(@objectUpdateEvent,data) if id isnt reqPlayer.id

  # It will be too complicated to do all this work in this class
  # this function to let you use a component to listen to message and handle the message
  #   @param [NetWorkComponent] the component to listen to message and handle the message
  load: (comp) =>
    comp.onStartServerPlayer?()

  # register the event that update the status of the GameObject in the scene
  # socket.on("object.update", (data)=>
  #   data.action structure:
  #    1. s
  #  return spawn(data) # body message should specify the position and rotation message.
  #    2. d
  #  return destrody(data)
  #    3. u
  #  update the status of the object
  # )
  #   @param player [Socket] a client socket
  _registerObjectUpdate: (player) =>
    player.on(@objectUpdateEvent, (data) =>
      switch data.action
        when 's' then @spawn(data, player)
        when 'd' then @destroy(data, player)
        when 'u' then @update(data, player)
    )

  addPlayer: (player) =>
    @players[player.id] = player
    @playerCount++
    player.game = @
    @_registerObjectUpdate(player)

  removePlayer: (player) =>
    delete @players[player.id]
    # tell other players this player left their game
    for id, p of @players
      p.send('s.ol.'+player.id)
    player.game == null
    @playerCount--
    @server.endGame(@) if @playerCount == 0