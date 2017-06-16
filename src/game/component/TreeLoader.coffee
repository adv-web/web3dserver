# Created by duocai on 2017/6/14.

NetWorkComponent = require('./NetWorkComponent')

# this component inform all clients to spawn some trees
# when the game start
#
class TreeLoader extends NetWorkComponent
  module.exports = @

  # create a tree loader
  constructor: () ->
    super "TreeLoader"


  # inform all clients to spawn some trees
  #
  # You can register this component to the game manager through manager.register(comp)
  #
  # @param [GameManager] manager the manager of this game
  onStartGame: (@manager)=>
    @_loadTree()

  # @private
  _loadTree: () =>
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
        @manager.spawn(data, @manager.serverReq)