import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/tagging/search/search_overlay.dart';

class TagDetectorField extends StatefulWidget {

  const TagDetectorField({required this.textField, required this.controller, super.key});
  final TextField textField;
  final TextEditingController controller;

  

  @override
  _TagDetectorFieldState createState() => _TagDetectorFieldState();
}

class _TagDetectorFieldState extends State<TagDetectorField> {
  bool _showSearch = false; 
  String _tag = '';
    @override
    Widget build(BuildContext context) {
      final textField = widget.textField;
      final controller = widget.controller;
      final _searchOverlay = SearchOverlay().show(context, controller, _tag);
      return Stack(
        children: [
          textField,
          if (_showSearch)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              //on tap show the search overlay
              child: GestureDetector(child:Icon(Icons.alternate_email,), 
              onTap: () => Overlay.of(context).insert(_searchOverlay) ,),
              //
            ),
        ],
      );
    }

    

    @override
    void initState() {
      super.initState();
      widget.textField.controller?.addListener(_onTextChanged);
    }

    @override
    void dispose() {
      widget.textField.controller?.removeListener(_onTextChanged);
      super.dispose();
    }


    String isItTaggable(String text, TextEditingController controller){
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


    void _onTextChanged() {
      
      final controller = widget.textField.controller ?? null;
      if (controller == null) return;
      final text = controller.text;
      
      setState(() {
        //show search if isItTaggable returns the type of string
        var tagIt = isItTaggable(text, controller);
         if (tagIt.compareTo('') != 0 ) {_showSearch = true; _tag = tagIt;}
         else {_showSearch = false;}
      });
      widget.textField.onChanged?.call(text);
    }
  }
