# Created by duocai on 2017/5/26.
User = require('../domain/User')

# the user service that provide service like create a user, login and so on.
#
class UserService
  module.exports = @

  # create a user service
  # @param [Object] db the db connection of orm framework
  constructor: (db) ->
    @userDao = User.instance(db)

  # create a user
  # @param [String] username the name of the user, this name is used to login in the game
  # @param [String] nickname the name of the user, this name will be display in the game
  # @param [String] password
  @createUser: (username, nickname, password,
    level=1, battle_number=0, win_rate=100,
    equipment="中坦", power=300, rank="新兵",
    hp=1, type='MT', exp=0) =>
    user = {
      username: username,
      nickname: nickname,
      password: password
      level: level
      battle_number: battle_number
      win_rate: win_rate
      equipment: equipment
      power: power
      rank: rank
      hp: hp
      type: type
      exp: exp
    }
    return user