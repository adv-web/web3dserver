# Created by duocai on 2017/5/13.

# whether to print debug message
verbose = true;
# orm
orm = require('orm')
User = require('./entity/User')
bodyParser = require('body-parser')
session = require('express-session')
cookieParser = require('cookie-parser')

# The express server handles passing our content to the browser,
# As well as routing users where they need to go. This example is bare bones
# and will serve any file the user requests from the root of your web server (where you launch the script from)
# so keep this in mind - this is not a production script but a development teaching tool.
class ExpressServer
  module.exports = @

  # init a express server
  #   init database connector
  #   init other servers
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
  start: () =>

    # get message of user[id]
    @app.get('/user/:id', (req, res) ->
      res.send({
        id : req.params.id
      })
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
        if user.length > 0
          result.success = false
          result.err = "The username is already existed."
          res.send(result)
        else
          req.models.User.create(
            {
              username: req.body.username
              password: req.body.password
            },
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
                result.user = user
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
        if user.length > 0
          if user[0].password == req.body.username
            req.session.user == user
            result.success = true
            result.user = user
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
      if req.session.user isnt (undefined  or null)
        result.success = true
        req.session.user == null
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
      if req.session.user isnt (undefined  or null)
        if req.params.id isnt req.session.id
          result.success = false
          req.err = "permission denied."
        else
          result.success = true
          req.session.user == null
      else
        result.success = false
        result.err = "You have never login in."
      res.send(result)
    )

    # express router
    @app.get('/', (req, res) ->
      res.sendFile(__dirname + '/index.html')
    )

    # This handler will listen for requests on /*, any file from the root of our server.
    # See expressjs documentation for more info on routing.
    @app.get( '/*' , ( req, res) ->
    # This is the current file they have requested
      file = req.params[0]

      # For debugging, we can track what files are requested.
      console.log('\t :: Express :: file requested : ' + file) if verbose

      # Send the requesting client the file.
      res.sendfile( __dirname + '/' + file )
    )# app.get *
