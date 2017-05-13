#  Multiplayer Design

## Server

This implement uses a weak server, most authority work are done in client for the server does not run the game. And this server just do some message synchronization work. hmmm, maybe  it's not so useless. it will check which one will work as well if there are 2 or more clients send the same action request. For example, if 2 players shoot at the same bottle at almost the same time, the request that reaches our server firstly will be accepted and the bottle will be removed, so the latter will shoot at nothing.

### GameServer

This class handle the message about players create a game, players join a game, players leave a game and host start a game and so on. these messages are same for all games.

### GameManager

There is a 'game manager' for each game lobby.  And it's work is focused on handle messages about this game, such as spawn object in the scene, destroy the object, update the status of the object and so on. 

some methods are as follows:

1. **constructor(host)**:

   initialize the Network Manager

   register object.update listener for the host

2.  **_registerObjectUpdate (player)**:
   register the event:

   socket.on("object.update", (data)=>

   ​	\# data.action 

   ​	\# 1. s

   ​		return spawn(data) \# body message should specify the position and rotation message.

   ​	\# 2. d

   ​		return destrody(data)

   ​        \# 3. u

   ​		update the status of the object

   )

3. **spawn(data)**: 

   \# some codes to decide whether this operation is legal

   \# if legal

   objectId = UUID() \# and store it

   \# add to data

   data.objectId = objectId

   allsockets.emit("object.update", data)

4. **destrody(data)**:

   \# some codes to decide whether this operation is legal

   \# if legal

   \# remove id from the storage pool

   allsockets.destroy("object.update", data)

5. **update(data)**:

   check whether it's legal

   update the status if it's legal

6. **addPlayer(player)**: 

   store this socket and regieter the object.update listener

7. **removePlayer(player)**

   remove the object.update listener for this player

   update host if player is host

   destroy this game if there is no player in the game

It will be too complicated to do all this work in this class, so here I provide a load(component) function to let you definite a component to listen to message and handle the message

### Components

some events are registered and handle in the specific component

1. **NetWorkTransfromComponent**: synchronize the transform of the game object that changed frequently such as player object

   ​

## Client

Each client will run the game locally and they will send synchronization message to each other through our server. And the synchronization  will only be done in the following classes. 

### Network Manager

**Network Manager** is unique in the client. It will do many works that are simply classified as follows:

1. It will connect to the server. Besides, it will receive and handle message about that other players join and leave the game, and send message to server if we leave the game. Mostly important, it will store and maintain the socket. and other class can use this socket to register event or emit message
2. It will store and maintain the prefabs of game objects. Recall **GameManager** on the server, this class will receive the spawn or destroy message from **GameManager**. And then it will do the work of spawn objects to the scene. And then it will store theses objects in order to destroy them later

### Components

These Components are totally different from the **Components** on the server although the names of some components may be the same. These components are designed according to the core concept 'Component' of our web3d framework and so, they will be easily to used in our game codes. they will do these works.

1. NetworkComponent: this component distinguish the local player from others. To use it, you the to create a component to extends it.
2. NetworkTransformCompnent: synchronize the transform of the game object that changed frequently such as player object.



