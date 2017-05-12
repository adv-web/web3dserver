# The component of a game object.
#
# A component has its lifecycle, you can alternatively implement these methods as you need:
#
class Component
  module.exports = this

  # Construct a new component.
  # @param name [String] the name of the component
  constructor: (@name) ->
    @gameObject = null
