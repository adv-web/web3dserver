# Created by duocai on 2017/5/13.

# whether to print debug message
verbose = true;

# The express server handles passing our content to the browser,
# As well as routing users where they need to go. This example is bare bones
# and will serve any file the user requests from the root of your web server (where you launch the script from)
# so keep this in mind - this is not a production script but a development teaching tool.
class ExpressServer
  module.exports = @

  constructor: (@app) ->

  start: () =>

    # express router
    @app.get('/', (req, res) ->
      res.sendFile(__dirname + '/index.html');
    )

    # This handler will listen for requests on /*, any file from the root of our server.
    # See expressjs documentation for more info on routing.
    @app.get( '/*' , ( req, res, next ) ->
    # This is the current file they have requested
      file = req.params[0];

      # For debugging, we can track what files are requested.
      console.log('\t :: Express :: file requested : ' + file) if verbose

      # Send the requesting client the file.
      res.sendfile( __dirname + '/' + file )
    )# app.get *
