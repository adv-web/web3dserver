# Created by duocai on 2017/5/10.
Component = require('../Component')

# Base class which should be inherited by scripts which
# contain networking functionality on the server
#
class NetWorkComponent
  module.exports = this

  # @param [String] name the name of this component
  constructor: (@name) ->

  # It will be called when the game started by the game manager.
  # You can register this component to the game manager through manager.load(comp)
  #
  onStartServerPlayer: ()=>