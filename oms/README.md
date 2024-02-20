# order_management_system

Order Management System for Disasters

# Firebase registration steps

- First we need to npm package. If you dont have you need to install it.
- Run `npm install -g firebase-tools` to install firebase tools
- Run `dart pub global activate flutterfire_cli`
- Run `firebase login` to login firebase
- Run `flutterfire configure` to configure.

# API Usage
First you don't need to create a object to use APIs. You can directly use which API you want.
## Return Values 
I am trying to return a map for all of them. Some of the returns boolean values for now. It will be changed. Let's have a look an exapmle and seee what returns functions;
`result = {"result":false,"info":"Update object cannot be empty! Use clear order!","error":UpdateEmptyInputError()};`
As you can see we have a map. And this map contains result,info and error keys. The 'result' is false, so we can understand that we have an error! And there is an information about what could be the reason of this error. Also we have an error key that return actual error.

`result={"result":true,"info":"Orders succesfully cleared"};`

Here we have a successfull process. As you can see we don't have any 'error' key at successfull processes.

So you need to check what is the result and if it is false then you can use info as your message to inform user. If it is true then you can make sure about everything goes as it should.
# Database construction
![Database Schema](/design/backend/instruction.png)
