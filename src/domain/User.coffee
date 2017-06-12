# Created by duocai on 2017/5/17.


# this class mainly definite the entity user.
# it's properties is exactly mapping to the filed name
# in the table User of database.
# although it is just a object, it will return a user DAO.
# we use the lib orm2 implement this.
class User
  module.exports = @

  # return a User DAO that provides
  # find, get, create methods and so on(this implemented by orm2)
  # @param [Object] a orm2 database object
  @instance: (db) =>
    db.define('User',{
      username: String
      nickname: String
      password: String
      level: Number
      battle_number: Number
      win_rate: Number
      equipment: String
      power: Number
      rank: String
    },{})

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