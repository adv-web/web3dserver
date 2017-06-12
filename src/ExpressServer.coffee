# Created by duocai on 2017/5/13.

# whether to print debug message
verbose = true;
# orm
orm = require('orm')
User = require('./domain/User')
UserService = require('./service/UserService')
bodyParser = require('body-parser')
session = require('express-session')
cookieParser = require('cookie-parser')

# The express server handles passing our content to the browser,
# As well as routing users where they need to go. This example is bare bones
# and will serve any file the user requests from the root of your web server (where you launch the script from)
# so keep this in mind - this is not a production script but a development teaching tool.
class ExpressServer
  module.exports = @

  # init a express server.
  # init database connector.
  # init other services.
  # @param [Express] app Express app.
  constructor: (@app) ->
    # create database connection
    @app.use(orm.express("mysql://root:123456@120.76.125.35:3306/web3d", {
      # register models
      define: (db, models, next) =>
        models.User = User.instance?(db)
        next()
    }))
    @app.use(bodyParser.json({limit: '1mb'}))
    @app.use(bodyParser.urlencoded({extended: false}))
    @app.use(cookieParser())
    @app.use(session({
      secret: "web3d server"
    }))

  # start server
  # set up express router
  # you can register your router in this function
  start: () =>

    # get message of user[id]
    @app.get('/session', (req, res) ->
      if verbose
        console.log("user session: ", req.session.user)
      if req.session.user != undefined
        res.send(req.session.user)
      else
        res.status(404)
        res.send("No such resources")
    )

    # add a new user
    @app.post('/user', (req, res) ->
      if verbose
        console.log("register:", req.body)

      result = {}
      # check valid
      if req.body.username == "" or req.body.password == ""
        result.success = false
        result.err = "username or password can not be empty."
        req.send(result)
        return

      # handle register
      req.models.User.find({username: req.body.username}, (err, user) ->
        if err
          result.success = false
          result.err = err
          res.send(result)
        else
          if user.length > 0
            result.success = false
            result.err = "The username is already existed."
            res.send(result)
          else
            req.models.User.create(
              UserService.createUser(req.body.username,req.body.nickname,req.body.password),
              # results
              (err, user) ->
                result = {}
                if err
                  result.success = false
                  result.err = err
                else
                  # set session
                  req.session.user = user
                  result.success = true
                  result.user = JSON.stringify(user)
                  if verbose
                    console.log(user)
                res.send(result)
          )
      )
    )

    # login in
    @app.post('/session', (req, res) ->
      if verbose
        console.log("Login in:", req.body)
      result = {}
      req.models.User.find({username: req.body.username}, (err, user) ->
        if err
          result.success = false
          result.err = err
        else
          if user.length > 0
            if user[0].password == req.body.username
              req.session.user == user
              result.success = true
              result.user = JSON.stringify(user[0])
            else
              result.success = false
          else
            result.success = false
            result.err = "username or password is wrong."
        res.send(result)
      )
    )

    # logout
    @app.delete('/session', (req, res) ->
      if verbose
        console.log("Login out:", req.ip)
      result = {}
      if req.session.user != undefined
        result.success = true
        req.session.user == undefined
      else
        result.success = false
        result.err = "No such resources."
      res.send(result)
    )

    # delete the user message
    @app.delete('/user/:id', (req, res) ->
      if verbose
        console.log("delete user: ", req.ip)
      result = {}
      if req.session.user != undefined
        if req.params.id isnt req.session.id
          result.success = false
          req.err = "permission denied."
        else
          result.success = true
          req.session.user == undefined
          #TODO delete the user
      else
        result.success = false
        result.err = "You have never login in."
      res.send(result)
    )

    # delete the user message
    @app.put('/user/:id', (req, res) ->
      if verbose
        console.log("update user: ", req.ip)
      result = {}
      if req.session.user != undefined
        if req.params.id isnt req.session.id
          result.success = false
          req.err = "permission denied."
          res.send(result)
        else
          req.models.User.find({id:req.params.id}, (err, users) =>
            user = user[0]
            user.username = req.body.username
            user.password = req.body.password
            user.nickname = req.body.nickname
            user.level = req.body.level
            user.power = req.body.power
            user.equipment = req.body.equipment
            user.rank = req.body.rank
            user.battle_number = req.body.battle_number
            user.win_rate = req.body.win_rate
            user.save((err)=>
              if (err)
                result.success = false
                result.err = err
              else
                result.success = true
                result.user = user
              res.send(result)
            )
          )
      else
        result.success = false
        result.err = "You have never login in."
        res.send(result)
    )
