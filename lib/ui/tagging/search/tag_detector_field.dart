import 'package:flutter/material.dart';
//import 'package:intheloopapp/ui/tagging/search/search_overlay.dart';
import 'package:intheloopapp/ui/tagging/search/components/static_tag_tools.dart';
import 'package:intheloopapp/ui/tagging/search/components/taggable_overlay.dart';

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
      //final _searchOverlay = SearchOverlay().show(context, controller, _tag); //this is the overlay function
      //final _searchAddition = SearchAddition().show(context, controller, _tag); //this is the addative function
      return Stack(
        children: [
          
          textField, 
          if (_showSearch) TaggableOverlay(textEditingController:controller),
          //if (_showSearch) TaggableOverlay(textEditingController: TextEditingController(text: _tag)),
          if (_showSearch) Positioned(right: 0, top: 0, bottom: 0, child: Icon(Icons.alternate_email)),
            //END positioned
          
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


    


    void _onTextChanged() {
      
      final controller = widget.textField.controller ?? null;
      if (controller == null) return;
      final text = controller.text;
      
      setState(() {
        //show search if isItTaggable returns the type of string
        var tagIt = TagTools.isItTaggable(text, controller);
         if (tagIt.compareTo('') != 0 ) {_showSearch = true; _tag = tagIt;}
         else {_showSearch = false;}
      });
      widget.textField.onChanged?.call(text);
    }
  }