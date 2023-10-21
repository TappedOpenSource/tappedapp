import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/tagging/search/search_overlay.dart';

class TagDetectorField extends StatefulWidget {
  final TextField textField;

  const TagDetectorField({Key? key, required this.textField}) : super(key: key);

  @override
  _TagDetectorFieldState createState() => _TagDetectorFieldState();
}

class _TagDetectorFieldState extends State<TagDetectorField> {
  bool _showSearch = false;

  @override
  Widget build(BuildContext context) {
    final _searchOverlay = SearchOverlay().show(context);
    return Stack(
      children: [
        widget.textField,
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
    
    
    
    
    //for every @ symbol, check if the previous character is a space
    //start by determining the index of the cursor
    final cursorIndex = controller.selection.baseOffset;
    
    //find the last space before the cursor
    final spIndex = text.substring(0, cursorIndex).lastIndexOf(' ');
    //find the last @ before the cursor
    final atIndex = text.indexOf('@');
    //if the @ is right after the space, then we can show the search
    final isTaggable = atIndex >= spIndex + 1;
    //I really had trouble with this so this is the debug
    print('avsz $isTaggable sp $spIndex @ $atIndex  crsr $cursorIndex');
    
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
