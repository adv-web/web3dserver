# API DOC

# User API

some data type declarations

  ```javascript
  // userobject
  userObject = {
    id: number
    username: string
    password: string
    // other properties
  }
  ```
1. /session POST

   ```javascript
   // this is the api for login

   // parameters
   {
   	username: string
   	password: string
   }

   // return
   // if success
   {
   	success: true
   	user: userObject 
   }
   // else err
   {
   	success: false
   	err: "username or password is wrong"
   }
   ```

2. /session DELETE

   ```javascript
   // this the api for log out
   // not implemented now
   ```

3. /user POST

   ```javascript
   // this is api for register

   // parameters
   {
     username: string,
     password: string,
     // other properties
   }
   ```

4. /user/:id PUT

   ```javascript
   // update the user message

   //parameters
   userObejct
   ```

5. /user/:id DELETE

   ```javascript
   // delete the user

   // parameters
   {
     username: string
     password: string
   }
   ```

6. /users GET

   ```javascript
   // get all users
   return
   [
   	userobject1,
   	userobject2,
   	...
   	userobejctN
   ]
   ```

7. /user/:id GET

   ```javascript
   // get one user

   return
   // if the user is existed
   userObject
   //else
   null
   ```

   ​