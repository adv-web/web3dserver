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

 ## 项目结构和文件说明

### 项目结构

![项目结构](docs/img/dir.PNG)

1. domain, service 和 ExpressServer.coffee主要实现用户登录注册、保存用户信息的功能。

2. game实现了多人游戏的服务端，主要包含

   GameServer.coffee: 处理创建，销毁游戏；玩家加入，离开游戏的请求。

   GameManager.coffee：管理一局游戏内部各种信息同步工作。

   Component/：扩展游戏功能。可在GameServer创建游戏的时候，选择在游戏中加入哪些组件。

   ChatServer.coffee: 实现多人聊天的服务器端，该服务与游戏服务独立开来。之后会考虑将该服务写成组件。

3. app.coffee: 项目启动文件。

4. 其它：无关文件（可删除），考虑以后可能添加功能，故保留这个完整的express项目结构。

### 文件说明及方法说明

1. 每个文件的具体说明，请参考[https://adv-web.github.io/web3dserver/doc/](https://adv-web.github.io/web3dserver/doc/)

## Related Docs

1. [Design Documentation](./docs/design.md)
2. [API DOC](./docs/api_doc.md): how to use apis like login, register and so on.