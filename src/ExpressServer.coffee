# Created by duocai on 2017/5/13.

# whether to print debug message
verbose = true;
# orm
orm = require('orm')
User = require('./entity/User')
bodyParser = require('body-parser')

# The express server handles passing our content to the browser,
# As well as routing users where they need to go. This example is bare bones
# and will serve any file the user requests from the root of your web server (where you launch the script from)
# so keep this in mind - this is not a production script but a development teaching tool.
class ExpressServer
  module.exports = @

  constructor: (@app) ->
    # create database connection
    @app.use(orm.express("mysql://root:123456@120.76.125.35:3306/web3d", {
      # register models
      define: (db, models, next) =>
        models.user = User.instance?(db)
        next()
    }))
    @app.use(bodyParser.json({limit: '1mb'}))
    @app.use(bodyParser.urlencoded({extended: false}))
  start: () =>

    # get all users
    @app.get('/users',  (req, res) ->
      req.models.user.all({}, (err, users) ->
        res.send(users)
      )
    )

    # get message of user[id]
    @app.get('/user/:id', (req, res) ->
      req.models.user.get(req.params.id, (err,user) ->
        console.log user
        res.send user
      )
    )

    # add a new user
    @app.post('/user', (req, res) ->
      username = req.body.username
      result = {}
      req.models.user.find({username: username}, (err, user) ->
        if user
          result.success = false
          result.err = "The username is already existed."
        else
          result.success = true
          req.models.create(req.body, (err, results) ->

          )
        res.send(result)
      )
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
