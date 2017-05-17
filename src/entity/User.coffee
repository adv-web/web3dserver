# Created by duocai on 2017/5/17.

class User
  module.exports = User

  @instance: (db) =>
    db.define('User',{
      username: String
      password: String
    },{})