# Created by duocai on 2017/5/26.
User = require('../domain/User')

# the user service that provide service like create a user
class UserService
  module.exports = @

  # @nodoc
  constructor: (db) ->
    @userDao = User.instance(db)


  # create a user
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

#
#    // userobject
#  userObject = {
#    id: number
#    username: string
#    nickname: String
#    password: string
#  // other properties
#  level: int
#  battle_number: int
#  win_rate: float
#  equipment: String //
#  power: int
#  }