# web3d multiplayer server

## Introduction

​	this is a server of our  multiplayer game demo based web3d.

​	This implement uses a weak server, most authority work are done in client for the server does not run the game. And this server just do some message synchronization work. hmmm, maybe  it's not so useless. it will check which one will work as well if there are 2 or more clients send the same action request. For example, if 2 players shoot at the same bottle at almost the same time, the request that reaches our server firstly will be accepted and the bottle will be removed, so the latter will shoot at nothing.

​	Details are at [Design Documentation](./doc/design.md)

## How to use

1. install [nodejs](https://nodejs.org/en/) and [npm]()
2. install dependencies
    > npm install
3. start server：
    > npm start

## Documentations

1. [Design Documentation](./docs/design.md)
2. [API DOC](./docs/api_doc.md): how to use apis like login, register and so on.