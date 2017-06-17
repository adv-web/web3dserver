# 服务器说明文档

## 1 环境配置

### 1.1  开发环境

1. IDE：[Webstorm](https://www.jetbrains.com/webstorm/)
2. 开发语言：[CoffeScript](http://coffee-script.org/)

### 1. 2 运行环境

1. 运行平台：[NodeJS](https://nodejs.org/en/)
2. 数据库：[Mysql](https://www.mysql.com/)

### 1.3 运行方法

1. 安装nodejs和mysql。

2. 新建数据库，参考schema.sql文件。

3. 在src/ExpressServer.coffee文件中修该数据库地址：

   ```coffeescript
     # init a express server.
     # init database connector.
     # init other services.
     # @param [Express] app Express app.
     constructor: (@app) ->
       # create database connection
       @app.use(orm.express("mysql://root:123456@localhost:3306/web3d", { # here
         # register models
         define: (db, models, next) =>
           models.User = User.instance?(db)
           next()
       }))
   ```

4. 安装依赖库

   在项目目录下执行: npm install

5. 运行

   在项目目录下执行: npm start

### 1.4 主要依赖库

1. [Express](http://www.expressjs.com.cn/4x/api.html): 一个简单、轻量、可靠的web框架
2. [scoket.io](https://socket.io/docs/): 一个简单、鲁棒的对websocket进行封装的库，同时当客户端不支持websocket时，内部也会以http请求模拟实现。
3. [orm2](https://github.com/dresende/node-orm2)：简单易用的orm框架，鲁棒性不是很好，其开发者提倡使用指定版本的mysql库。
4. [coffee-script](http://coffee-script.org/): 对面向对象有很好实现的基于js的语言，简单易学。

 ## 2 项目结构和文件说明

### 2.1 项目结构

![项目结构](docs/img/dir.PNG)

1. domain, service 和 ExpressServer.coffee主要实现用户登录注册、保存用户信息的功能。

2. game实现了多人游戏的服务端，主要包含

   GameServer.coffee: 处理创建，销毁游戏；玩家加入，离开游戏的请求。

   GameManager.coffee：管理一局游戏内部各种信息同步工作。

   Component/：扩展游戏功能。可在GameServer创建游戏的时候，选择在游戏中加入哪些组件。

   ChatServer.coffee: 实现多人聊天的服务器端，该服务与游戏服务独立开来。之后会考虑将该服务写成组件。

3. app.coffee: 项目启动文件。

4. 其它：无关文件（可删除），考虑以后可能添加功能，故保留这个完整的express项目结构。

### 2.2 文件说明及方法说明

1. 每个文件的具体说明，请参考[https://adv-web.github.io/web3dserver/doc/](https://adv-web.github.io/web3dserver/doc/)

## 3 主要功能实现说明

1. GameServer

   这个类会处理创建游戏，加入游戏，销毁游戏的请求。并且维护现在的游戏数目信息。该类利用socket.io实现非常简单。

2. GameManager

   管理一局游戏内部各种信息同步工作。当GameServer创建一个游戏的时候，服务器就会创建一个GameManager来管理这局游戏的信息同步工作。

   该类定义三个与客户端交流的事件：创建gameObject，更新gameObject的信息，删除gameObject。维护一个游戏的生命周期：现在只有初始化、游戏开始、游戏结束三个状态点。

   该类维护该局游戏所加载的所有组件，并在游戏生命周期的状态点对他们进行调用。

   ```coffeescript
       # It will be too complicated to do all this work in this class
     # this function to let you use a component to listen to message and handle the message
     #
     # @param [NetWorkComponent] the component to listen to message and handle the message
     registerComponent: (comp) =>
       @comps.push(comp) # register this component
       comp.onRegister?(@)

     # start the game
     #
     # this method will inform all clients to start game
     startGame: () =>
       for id, p of @players
         p.send('s.s')

       # start game
       for comp in @comps
         comp.onStartGame?(@)

       @started = true

     # end the game
     #
     # this method will inform all clients to end game
     endGame: () =>
       # inform all clients
       for id, p of @players
         p.send('s.e')

       # end game
       for comp in @comps
         comp.onEndGame?(@)
   ```

   ​

3. Component

   Component利用GameManager提供生命周期状态点扩展游戏功能。他们都继承自NetworkComponent：

   ```coffeescript
   # Base class which should be inherited by scripts which
   # contain networking functionality on the server
   #
   class NetWorkComponent
     module.exports = this

     # @param [String] name the name of this component
     constructor: (@name) ->

     # It will be called when you register this component.
     # You can register this component to the game manager through manager.register(comp)
     # @param [GameManager] manager the manager of this game
     onRegister: (manager) =>

     # It will be called when the game started by the game manager.
     # You can register this component to the game manager through manager.register(comp)
     # @param [GameManager] manager the manager of this game
     onStartGame: (manager)=>

     # It will be called when the game is end.
     # You can register this component to the game manager through manager.register(comp)
     # @param [GameManager] manager the manager of this game
     onEndGame: (manager) =>
   ```

   现在组件提供这三个状态点扩展功能。

   例如现有的TreeLoader组件在游戏开始时决定在场景中生成一些树，GameTimeInformer会在每秒通知客户端游戏进行的时间。NetWorkTransform组件会通知各个玩家其它玩家的位置信息。

   然后GameServer创建游戏的时候可以决定使用哪些组件，如下代码：就装配了一个会同步玩家位置，有游戏计时的游戏。

   ```coffeescript
   	# load the component that automatically synchronize the transform if this player
       game.registerComponent(new NetWorkTransform(player))
       # load game time informer
       game.registerComponent(new GameTimeInformer())
   ```

   以此种方法就可以创建类型多样的游戏，玩家可以定制游戏中的一些会发生的事件。

## 4 数据库设计

​	该实现没有复杂的数据库，只有一张user表已提供登录注册服务和玩家等级、军衔信息的持久化。表结构如下：

​	![databse](docs/img/db.PNG)

## 5 Related Docs

1. [项目文档](https://adv-web.github.io/web3dserver/doc/)
2. [Design Daft](./docs/design.md)
3. [API DOC](./docs/api_doc.md): how to use apis like login, register and so on.

