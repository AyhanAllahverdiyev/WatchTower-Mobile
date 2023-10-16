import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget{
  const LoginPage();

  @override
  Widget build(BuildContext context){
    return Scaffold(  
      backgroundColor: const Color.fromARGB(36,32,50,1000),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(10.0), 
          child: AppBar(
            backgroundColor:const Color.fromARGB(27,23,37,1000),
          )
      ),
      body:
       SafeArea(child: Column(
        children: [
          
          Center(
            child: Container(
                padding: const EdgeInsets.only(top:20,bottom: 8,left: 20,right: 20),
                child: const Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top:8.0),
                        child: Text(
                          'Please sign in to continue.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                          
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top:20.0,bottom:8.0),
                        child: Text(
                          'Username',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                          
                        ),
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'your name',
                        prefixIconColor: Colors.grey,
                        filled: true,
                        fillColor: Color.fromARGB(57, 108, 126, 241),
                        prefixIcon: Icon(Icons.person_rounded),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        )
                      ),
                      
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top:20.0,bottom:8.0),
                        child: Text(
                          'Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                          
                        ),
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'your password',
                        prefixIconColor: Colors.grey,
                        filled: true,
                        fillColor: Color.fromARGB(57, 108, 126, 241),
                        prefixIcon: Icon(Icons.lock),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        )
                      ),
                      
                    ),
                  ],
                ),
                
              ),
          
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.only(top:20,bottom: 8,left: 20,right: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                      }
                      return null; // Use the component's default.
                    },
                  ),
                ),
                child: const Text('LOGIN'),
                onPressed: () {
                  // ...
                },
              ),
            ),
          )
        ]
      ))
    );
        
  }
} 