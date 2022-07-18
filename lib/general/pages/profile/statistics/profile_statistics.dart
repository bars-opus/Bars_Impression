import 'package:flutter/material.dart';

class ProfileStatistics extends StatefulWidget {

 static final id = 'ProfileStatistics_screen';

  @override
  _ProfileStatisticsState createState() => _ProfileStatisticsState();
}

class _ProfileStatisticsState extends State<ProfileStatistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
     appBar: AppBar(
       iconTheme: IconThemeData(
         color: Colors.black
       ),
        automaticallyImplyLeading: true,
           elevation: 0,
       backgroundColor: Colors.white,
     title: Text('Statistics',
      style: TextStyle(
                  color: Colors.black, 
                 fontSize: 20, 
                 fontWeight: FontWeight.bold
              ),
     ),
     centerTitle: true,
     ),
       body: ListView(
                         scrollDirection: Axis.vertical,
                              children:<Widget>[
 // first column            
                              Column(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      width: 150.0,
                                      child: Column(children: <Widget>[

                          
     SizedBox(height: 70.0,),

// Second column
                              Container(
                                  width: 150.0,
                                  child: Column(children: <Widget>[
                                  Text('12',
                                   style: TextStyle(
                                     color: Colors.black,
                                     fontSize: 18.0, 
                                     fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text('Following', style: TextStyle(color: Colors.black,
                                  fontSize: 14, fontWeight: FontWeight.bold,),
                                  ),
                                   SizedBox(height: 5.0,),
                                   Text('The number of songs played from your library', style: TextStyle(color: Colors.grey,
                                   fontSize: 12),
                                  )
                            ],
                            ),
                                ),


    // statistics

                                 SizedBox(height: 70.0,),
                        
                         Container(
                                  width: 150.0,
                                  child: Column(children: <Widget>[
                                  Text('12',
                                   style: TextStyle(
                                    color: Colors.black,
                                     fontSize: 18.0, 
                                     fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text('Following', style: TextStyle(color: Colors.black,
                                  fontSize: 14, fontWeight: FontWeight.bold,),
                                  ),
                                   SizedBox(height: 5.0,),
                                   Text('The number of songs played from your library', style: TextStyle(color: Colors.grey,
                                   fontSize: 12),
                                  )
                              ],
                              ),
                                ),

    // statistics

                                 SizedBox(height: 70.0,),
                        
                         Container(
                                  width: 150.0,
                                  child: Column(children: <Widget>[
                                  Text('12',
                                   style: TextStyle(
                                    color: Colors.black,
                                     fontSize: 18.0, 
                                     fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text('Following', style: TextStyle(color: Colors.black,
                                  fontSize: 14, fontWeight: FontWeight.bold,),
                                  ),
                                   SizedBox(height: 5.0,),
                                   Text('The number of songs played from your library', style: TextStyle(color: Colors.grey,
                                   fontSize: 12),
                                  )
                              ],
                              ),
                                ),


    // statistics

                                 SizedBox(height: 70.0,),
                        
                         Container(
                                  width: 150.0,
                                  child: Column(children: <Widget>[
                                  Text('12',
                                   style: TextStyle(
                                    color: Colors.black,
                                     fontSize: 18.0, 
                                     fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text('Following', style: TextStyle(color: Colors.black,
                                  fontSize: 14, fontWeight: FontWeight.bold,),
                                  ),
                                   SizedBox(height: 5.0,),
                                   Text('The number of songs played from your library', style: TextStyle(color: Colors.grey,
                                   fontSize: 12),
                                  )
                              ],
                              ),
                                ),
  

    // statistics

                                 SizedBox(height: 70.0,),
                        
                         Container(
                                  width: 150.0,
                                  child: Column(children: <Widget>[
                                  Text('12',
                                   style: TextStyle(
                                    color: Colors.black,
                                     fontSize: 18.0, 
                                     fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text('Following', style: TextStyle(color: Colors.black,
                                  fontSize: 14, fontWeight: FontWeight.bold,),
                                  ),
                                   SizedBox(height: 5.0,),
                                   Text('The number of songs played from your library', style: TextStyle(color: Colors.grey,
                                   fontSize: 12),
                                  )
                              ],
                              ),
                                ),


    // statistics

                                 SizedBox(height: 70.0,),
                        
                         Container(
                                  width: 150.0,
                                  child: Column(children: <Widget>[
                                  Text('12',
                                   style: TextStyle(
                                    color: Colors.black,
                                     fontSize: 18.0, 
                                     fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text('Following', style: TextStyle(color: Colors.black,
                                  fontSize: 14, fontWeight: FontWeight.bold,),
                                  ),
                                   SizedBox(height: 5.0,),
                                   Text('The number of songs played from your library', style: TextStyle(color: Colors.grey,
                                   fontSize: 12),
                                  )
                              ],
                              ),
                                ),


    // statistics

                                 SizedBox(height: 70.0,),
                        
                         Container(
                                  width: 150.0,
                                  child: Column(children: <Widget>[
                                  Text('12',
                                   style: TextStyle(
                                    color: Colors.black,
                                     fontSize: 18.0, 
                                     fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text('Following', style: TextStyle(color: Colors.black,
                                  fontSize: 14, fontWeight: FontWeight.bold,),
                                  ),
                                   SizedBox(height: 5.0,),
                                   Text('The number of songs played from your library', style: TextStyle(color: Colors.grey,
                                   fontSize: 12),
                                  )
                              ],
                              ),
                                ),


  
                                       
                            ],
                            ),
                                    ),
                                  ],
                                ),


                        
                        

                        ]
                    ),
      

        );
  }
}