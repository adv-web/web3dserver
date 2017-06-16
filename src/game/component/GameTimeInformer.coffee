# Created by duocai on 2017/6/14.

NetWorkComponent = require('./NetWorkComponent')

# this component inform all clients the server time every second
#
class GameTimeInformer extends NetWorkComponent
  module.exports = @

  # create a game time informer
  constructor: () ->
    super "GameTimeInformer"


  # register the event that inform all clients the server time every seconds
  # You can register this component to the game manager through manager.register(comp)
  # @param [GameManager] manager the manager of this game
  onStartGame: (@manager)=>
    @_initTime()

  # @private
  _initTime: () =>
    @time = 180 # s
    @_updateTime()

  # @private
  _updateTime: () =>
    @time -= 1
    if @time <= 0
      @manager.endGame()
      return # stop inform
    for id, p of @manager.players
      p.send('s.ut.'+@time)
    # next inform
    setTimeout(@_updateTime, 1000)