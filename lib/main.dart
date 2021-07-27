import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
enum Directions{
  Right,
  Left,
  Up,
  Down
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  List<int> position=[585, 605, 625, 645];
  int verticalCellsNum=0;
  Directions currentDirection=Directions.Down;
  double initialDragHorizontal=0;
  double initialDragVertical=0;

  double distanceDragHorizontal=0;
  double distanceDragVertical=0;
  Random random= Random();
  int food=0;
  int score=0;
  late Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    food=random.nextInt(200);
    addFood();
    updateSnakePosition();
    super.initState();
  }

  void updateSnakePosition(){
   timer= Timer.periodic(Duration(milliseconds: 300), (timer){
      changeDirection();
      setState(() {
      });
    });

  }
  void changeDirection(){
    int totalCellsNum=(verticalCellsNum*20)-20;
    if(currentDirection == Directions.Right ){
      if (verticalCellsNum > 0 && ((position.last+1)%20 ==0)) {
        position.add(position.last - 19);
        position.removeAt(0);
        print("moving change right");
      } else {
        position.add(position.last +1);
        position.removeAt(0);
        print("moving right");
      }
      if(position.last==food){
        position.add(position.last + 1);
        addFood();
      }
    }if(currentDirection == Directions.Left ){
      if (verticalCellsNum > 0 && (position.last%20 ==0)) {
        position.add(position.last + 19);
        position.removeAt(0);
        print("moving change left");
      } else {
        position.add(position.last -1);
        position.removeAt(0);
        print("moving left");
      }
      if(position.last==food){
        position.add(position.last -1);
        addFood();
      }
    }
    if(currentDirection == Directions.Up ){
      if (verticalCellsNum > 0 && (position.last-20 < 0)) {
        position.add(position.last -20  + totalCellsNum);
        position.removeAt(0);
        print("moving change up");
      } else {
        position.add(position.last - 20);
        position.removeAt(0);
        print("moving up");
      }
      if(position.last==food){
        position.add(position.last - 20);
        addFood();
      }
    }if(currentDirection == Directions.Down ){
      if (verticalCellsNum > 0 && (position.last + 20 > totalCellsNum)) {
        position.add(position.last + 20 - totalCellsNum);
        position.removeAt(0);
        print("moving change down");
      } else {
        position.add(position.last + 20);
        position.removeAt(0);
        print("moving down");
      }
      if(position.last==food){
        position.add(position.last + 20);
        addFood();
      }
    }
    for(int i=0;i<position.length-1;i++){
      if(position[i]==position.last){
        timer.cancel();
        showDialog(context: context, builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Game Over"),
            content: new Text("You Died"),
            actions: [
              TextButton(onPressed: (){
                resetTheGame();
                Navigator.of(context).pop();
              }, child: Text("Play Again"))
            ],
          );
        });
      }
    }
  }
  void addFood(){

    if(verticalCellsNum>0){
      score++;
      while(position.contains(food)){
        food = random.nextInt(20*verticalCellsNum-20).abs();
        print("food position $food");
      }
    }

  }
  void resetTheGame(){
     position.clear();
      position=[585, 605, 625, 645];

      currentDirection=Directions.Down;
      initialDragHorizontal=0;
      initialDragVertical=0;

      distanceDragHorizontal=0;
      distanceDragVertical=0;
      score=-1;

     food=random.nextInt(200);
     addFood();
     updateSnakePosition();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height*.95;
    double cellWidth=screenWidth/20;
    double cellHeight=cellWidth;
    verticalCellsNum=(screenHeight/cellHeight).floor();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Container(
           height: MediaQuery.of(context).size.height*.05,

            padding: const EdgeInsets.all(6.0),
            child: Center(child: Text("Score: $score",style: TextStyle(color: Colors.white,fontSize: 20),)),
          ),

          Expanded(
            child: GestureDetector(
              onPanStart: (DragStartDetails details) {
                initialDragHorizontal = details.globalPosition.dx;
                initialDragVertical = details.globalPosition.dy;

              },
              onPanUpdate: (DragUpdateDetails details) {
                distanceDragHorizontal= details.globalPosition.dx - initialDragHorizontal;
                distanceDragVertical= details.globalPosition.dy - initialDragVertical;

              },
              onPanEnd: (DragEndDetails details) {

                print("Drag horizontal by $distanceDragHorizontal");
                print("Drag Vertical by $distanceDragVertical");
                if(distanceDragHorizontal.abs()>distanceDragVertical.abs()){
                  if(distanceDragHorizontal>0){
                    if(currentDirection!=Directions.Left)
                      currentDirection=Directions.Right;

                  }else{
                    if(currentDirection!=Directions.Right)
                      currentDirection=Directions.Left;
                  }
                }else{
                  if(distanceDragVertical>0 ){
                    if(currentDirection!=Directions.Up)
                    currentDirection=Directions.Down;

                  }else{
                    if(currentDirection!=Directions.Down)
                      currentDirection=Directions.Up;

                  }
                }
                initialDragHorizontal = 0.0;
                initialDragVertical=0.0;

              },

              child: GridView.builder(
                  itemCount: (verticalCellsNum*20)-20,

                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 20, ),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: Container(color: position.contains(index)?  Colors.white : food==index?Colors.green:Colors.white24),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
