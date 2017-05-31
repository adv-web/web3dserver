# Created by duocai on 2017/5/26.
User = require('../domain/User')

class UserService
  module.exports = @

  constructor: (db) ->
    @userDao = User.instance(db)


  # login: (username, password) = >
