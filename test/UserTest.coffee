# Created by duocai on 2017/5/25.

http = require('http')
qs = require('querystring')

options =
  hostname: '127.0.0.1',
  port: 5000,
  path: '', # to be defined
  method: '', # to be defined
  headers:
    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'

# define test function
testRegister = (user, pass) ->
  data =
    username: user,
    password: pass

  jsonData = qs.stringify(data)

  options.path = '/user/'
  options.method = "POST"

  req = http.request(options, (res) ->
    res.setEncoding('utf8')
    res.on('data', (user) ->
      console.log("Register: ok.")
      console.log('BODY: ' + user)
    )
  )
  req.on('error',(e) ->
    console.error('Register error:\n problem with request: ' + e.message)
  )
  # write data to request body
  req.write(jsonData)
  req.end()


# start test
testRegister("admin", "ada")

username = "23333"
testRegister(username, "666666")

