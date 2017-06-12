# Created by duocai on 2017/5/2.
UUID = require('node-uuid')

# There is a 'game manager' for each game lobby.  And it's work is
# focused on handle messages about this game, such as spawn object in
# the scene, destroy the object, update the status of the object and so on.
class GameManager
  module.exports = this

  # initialize the Network Manager
  # @param [Socket] host the socket of the first player of this lobby, and he will be the host
  # @param [GameServer] the game server
  constructor: (@host,@server) ->
      @id = UUID()
      @objectUpdateEvent = "object.update"
      @players = {}
      @playerCount = 0
      @objects ={}
      @started = false
      @serverReq = {id: 'server'}
      @addPlayer(@host)

  # start the game
  #
  # this method will inform all clients to start game
  startGame: () =>
    for id, p of @players
      p.send('s.s')
    @loadTree();
    @started = true

  # @private
  loadTree: () =>
    # tree
    for i in [9..14]
      for j in [9..14]
        data =
          action: 's'
          message: JSON.stringify({
            position: {
              x: i * 0.48 - 5.76 + Math.random() * 0.3 - 0.15,
              y: -0.9,
              z: j * 0.48 - 5.76 + Math.random() * 0.3 - 0.15
            }
          })
          prefab: "tree"
        @spawn(data, @serverReq)

  # decide whether this operation is legal and inform all clients if it's legal
  #
  # @param [Object] data {action: s} and others are about the position
  #   and rotation of the object to be spawned
  # @param [Socket] the client that send this request
  spawn: (data, reqPlayer) =>
    data.objectId = UUID();
    # store it
    if reqPlayer.id is 'server'
      @objects[data.objectId] = data
    data.reqPlayerId = reqPlayer.id
    # send message to all clients
    for id, p of @players
      p.emit(@objectUpdateEvent,data)

  # Some codes to decide whether this operation is legal.
  # And remove id from the storage pool if it is legal.
  # then inform all clients
  #
  # @param [Object] data {objectID: uuid}
  # @param [Socket] the client that send this request
  destroy: (data, reqPlayer) =>
    # destroy success
    if @objects[data.objectId] isnt undefined
      delete @objects[data.objectId]
      reqPlayer.emit(data.callback,true)
      for id, p of @players
        p.emit(@objectUpdateEvent,data) if id isnt reqPlayer.id
    else
      reqPlayer.emit(data.callback,false)

  # check whether it's legal.
  # update the status if it's legal.
  # @param [Object] data action is u, and other is some
  #     messages that need to be updated
  # @param [Socket] the client that send this request
  update: (data, reqPlayer) =>
    #TODO some checks may be done in the future
    for id, p of @players
      p.emit(@objectUpdateEvent,data) if id isnt reqPlayer.id

  # It will be too complicated to do all this work in this class
  # this function to let you use a component to listen to message and handle the message
  #
  # @param [NetWorkComponent] the component to listen to message and handle the message
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
  #
  # @param [Socket] player a client socket
  # @private
  _registerObjectUpdate: (player) =>
    player.on(@objectUpdateEvent, (data) =>
      switch data.action
        when 's' then @spawn(data, player)
        when 'd' then @destroy(data, player)
        when 'u' then @update(data, player)
    )

  # add the player to this game
  #
  # @param [Socket] player a client socket
  addPlayer: (player) =>
    # tell the player others joined
    for key, player2 of @players
      player2.send("s.oj."+player.info?.nickname)
      player.send("s.oj."+player2.info?.nickname)

    @players[player.id] = player
    @playerCount++
    player.game = @
    @_registerObjectUpdate(player)

    # tell the player game has already started
    # and let it create the game object from the server
    if @started
      player.send('s.s')
      for key, data of @objects
        data.repPlayerId = @serverReq.id
        player.emit(@objectUpdateEvent,data)

  # remove the player from this game. And if then the game number is 0,
  # the game will be destroyed.
  #
  # @param [Socket] player a client socket
  removePlayer: (player) =>
    delete @players[player.id]
    # tell other players this player left their game
    for id, p of @players
      p.send('s.ol.'+player.id)
    player.game == null
    @playerCount--
    @server.destroyGame(@) if @playerCount == 0

  # update the messages of the parameter player
  updateUserInfo: () =>
    mess = []
    for id, p of @players
      mess.push(p.info)
    for id, p of @players
      p.emit("user.info.update", JSON.stringify(mess))