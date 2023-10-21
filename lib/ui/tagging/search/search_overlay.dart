import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intheloopapp/ui/tagging/search/search_view.dart';


class SearchOverlay {

late OverlayEntry _overlayEntry;

  SearchOverlay() {
    _overlayEntry = OverlayEntry(

      builder: (BuildContext context) {
        return SearchView(onClear: close);
            
         
        
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
                          //close the entire overlay
                          close();
                        },
                        child: Icon(Icons.close, color: Colors.black, size: 25,),
                      ),
    );
  }
  

  OverlayEntry show(BuildContext context) {
    return  _overlayEntry;
  }

  void close() {
    _overlayEntry.remove();
  }
}