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
   // no parameter, the server will check whether the session was setted

   // return
   // if success
   {
     success: true
   }
   // else fail
   {
     success: false,
     err: "No such resources." // or something else
   }
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
     
   // return
   // if success
   {
   	success: true
   	user: userObject 
   }
   // else err
   {
   	success: false
   	err: "The username is already existed." //or something else
   }
   ```

4. /user/:id PUT

   ```javascript
   // update the user message

   // parameters
   userObejct

   // if success
   {
     success: true,
     user: userObject // new user
   }

   // falil
   {
     success: false,
     err: err message
   }
   ```

5. /user/:id DELETE

   ```javascript
   // delete the user

   // no parameter, the server will check whether the session was setted

   // return
   // if success
   {
     success: true
   }
   // else fail
   {
     success: false,
     err: "You have never login in." // or "permission denied" for you want to delele other 	user
   }
   ```

6. /user/:id GET

   ```javascript
   // get one user

   return
   // what do you want to be returned??
   ```

   ​