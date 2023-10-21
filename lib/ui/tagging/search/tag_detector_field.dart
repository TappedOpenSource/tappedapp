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

    @override
    Widget build(BuildContext context) {
      final textField = widget.textField;
      final controller = widget.controller;
      final _searchOverlay = SearchOverlay().show(context, controller);
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


    bool isItTaggable(String text, TextEditingController controller){
      //start by determining the index of the cursor
      final cursorIndex = controller.selection.baseOffset;
      print('avsz $cursorIndex');
      //if there's nothing, show no button.
      if (cursorIndex == 0) return false;
      //is the last character an '@'?
      final isAt = text.substring(cursorIndex - 1) == '@';
      // if so, if there's nothing before it, it's taggable 
      if (isAt && cursorIndex == 1) return true;
      //is the character before the '@' a space?
      final isSP = text.substring(cursorIndex - 2, cursorIndex - 1) == ' ';
      //if the @ is right after a space, then we can show the search
      final isTaggable = isAt && isSP;
      //I really had trouble with this so this is the debug
      //print('avsz tag: $isTaggable "@" $isAt " " $isSP crsr $cursorIndex');
      
      return isTaggable;
    }


    void _onTextChanged() {
      
      final controller = widget.textField.controller ?? null;
      if (controller == null) return;
      final text = controller.text;
      
      setState(() {
        _showSearch = isItTaggable(text, controller);
      });
      widget.textField.onChanged?.call(text);
    }
  }
