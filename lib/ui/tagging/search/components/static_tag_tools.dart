
import 'package:flutter/material.dart';

class TagTools {


static String isItTaggable(String text, TextEditingController controller){
      //start by determining the index of the cursor
      final cursorIndex = controller.selection.baseOffset;
      //print('avsz $cursorIndex');
      //if there's nothing, show no button.
      if (cursorIndex == 0) return '';
      //find the last word before the cursor
      var lastWord = '';
      if(text.contains(' ')) {lastWord = text.substring(0, cursorIndex).split(' ').last;}
      else {lastWord = text;}
      //is the last character an '@'?
      final isAt = lastWord.substring(0, 1).contains('@');
      // if so, if there's nothing before it, it's taggable 
      final isTaggable = isAt;
      //I really had trouble with this so this is the debug
      print('avsz tag: $isTaggable lastWord $lastWord "@" $isAt crsr $cursorIndex');
      if(isTaggable) return lastWord;
      else return '';
    }

}