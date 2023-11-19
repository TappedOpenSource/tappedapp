import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intheloopapp/ui/tagging/search/components/search_bar_widget.dart';



class SearchOverlay {

late String tag;
late OverlayEntry _overlayEntry;
late TextEditingController controller;
bool closed = false;


  SearchOverlay() {
    closed = false;
    _overlayEntry = OverlayEntry(

      builder: (BuildContext context) {


        var screenSize = MediaQuery.of(context).size;
        return Positioned(
            
          //top: screenSize.height * 0.45,
          top: screenSize.height * 0.1,
          left: screenSize.width * 0.1,

          child: SizedBox(    //height: screenSize.height *.8, width: screenSize.width * .8, 
          height: 600, width: 300,

          child: Container(
            child: Stack(
              children: [
                SearchBarWidget(controller, close),
                Positioned(child:
                closeButton(),
                right: 0,
                
                
                )
              ],
            ),
          )),
        );
            
         
        
      },
    );
  
  }

//FROM CHATGPT
  Widget closeButton(){
    return Container(
      height: 60,
      width: 60,
      color: Colors.red,
      child: GestureDetector(
                        onTap: () {
                          print('avsz close');
                          closed = true;
                          //close the entire overlay
                          close();
                        },
                        child: Icon(Icons.close, color: Colors.black, size: 25,),
                      ),
    );
  }
  

  OverlayEntry show(BuildContext context, TextEditingController controller, String tag) {
    this.controller = controller;
    this.tag = tag;

    return  _overlayEntry;
  }

  void closeIt(){
    closed = true;
  }

  void close() {
      
    _overlayEntry.remove();
  }
}

