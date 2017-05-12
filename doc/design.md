#  Multiplayer Design

## Server

This implement uses a weak server, most authority work are done in client for the server does not run the game. And this server just do some message synchronization work. hmmm, maybe  it's not so useless. it will check which one will work as well if there are 2 or more clients send the same action request. For example, if 2 players shoot at the same bottle at almost the same time, the request that reaches our server firstly will be accepted and the bottle will be removed, so the latter will shoot at nothing.

### GameServer

This class handle the message about players create a game, players join a game, players leave a game and host start a game and so on. these messages are same for all games.

### GameManager

There is a 'game manager' for each game lobby.  And it's work is focused on handle messages about this game, such as spawn object in the scene, destroy the object, update the status of the object and so on. 

some methods are as follows:

1. **constructor()**:

   initialize the Network Manager

   register the event:

   socket.on("object.update", (data)=>

   ​	\# data.header structure: 

   ​	\# 1. s.prefabId (prefabId is key decided by programmer)

   ​		return spawn(data) \# body message should specify the position and rotation message.

   ​	\# 2. d.objectId (UUID)

   ​		return destrody(data)

   ​        \# 3. u.objectId

   ​		update the status of the object

   )

2. **spawn(data)**: 

   \# some codes to decide whether this operation is legal

   \# if legal

   objectId = UUID() \# and store it

   \# add to data

   data.body.objectId = objectId

   allsockets.emit("object.update", data)

3. **destrody(data)**:

   \# some codes to decide whether this operation is legal

   \# if legal

   \# remove id from the storage pool

   allsockets.destroy("object.update", data)

I will be too complicated to do all this work in this class, so here I provide a load(component) function to let you definite a component to listen to message and handle the message

### Components

some events are registered and handle in the specific component

1. **NetWorkTransfromComponent**: synchronize the transform of the game object that changed frequently such as player object

   ​

## Client

Each client will run the game locally and they will send synchronization message to each other through our server. And the synchronization  will only be done in the following classes. 

### Network Manager



