# Created by duocai on 2017/5/10.

# Base class which should be inherited by scripts which
# contain networking functionality on the server
#
class NetWorkComponent
  module.exports = this

  # @param [String] name the name of this component
  constructor: (@name) ->

  # It will be called when you register this component.
  # You can register this component to the game manager through manager.register(comp)
  # @param [GameManager] manager the manager of this game
  onRegister: (manager) =>

  # It will be called when the game started by the game manager.
  # You can register this component to the game manager through manager.register(comp)
  # @param [GameManager] manager the manager of this game
  onStartGame: (manager)=>


  # It will be called when the game is end.
  # You can register this component to the game manager through manager.register(comp)
  # @param [GameManager] manager the manager of this game
  onEndGame: (manager) =>