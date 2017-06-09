# Created by duocai on 2017/5/26.
User = require('../domain/User')

# @nodoc
class UserService
  module.exports = @

  constructor: (db) ->
    @userDao = User.instance(db)


  # login: (username, password) = >
