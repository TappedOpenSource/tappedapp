import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/tagging/search/components/taggable_overlay.dart';
import 'package:intheloopapp/ui/tagging/search/components/static_tag_tools.dart';
import 'package:intheloopapp/ui/tagging/taggable_text_field.dart';

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
  bool _showing = false;
  
  SearchOverlay searchOverlay = SearchOverlay();
  void _searchOverlay() {searchOverlay.show(context, widget.controller, _tag);}

  void hideOverlay(SearchOverlay sOverlay) {sOverlay.close();}

  void onHide() {hideOverlay(searchOverlay);}


    @override
    Widget build(BuildContext context) {
      final textField = widget.textField;
      final controller = widget.controller;
      //print('avsz showSearch: $_showSearch');
      //if(_showSearch) _searchOverlay();
      
      return Stack(
        children: [
          textField,
          
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
      //print('searchOverlay.closed: ${searchOverlay.closed} _showing: $_showing _showSearch: $_showSearch');
      final controller = widget.textField.controller ?? null;
      if (controller == null) return;
      final text = controller.text;
      //print('avsz searchOverlay.closed: ${searchOverlay.closed} _showing: $_showing _showSearch: $_showSearch');
      setState(() {
        //show search if isItTaggable returns the type of string
        var tagIt = TagTools.isItTaggable(text, controller);
         if (tagIt.compareTo('') != 0 ) {  _showSearch = true; _tag = tagIt;}
         else { _showSearch = false;}
         if (_showSearch && (!_showing || searchOverlay.closed) ){
          Overlay.of(context).insert(searchOverlay.show(context, controller, _tag));
          _showing = true;
          //print('avsz show');
          }
          if ((!_showSearch & ((_showing) || !searchOverlay.closed))) {
            searchOverlay.closeIt();
             hideOverlay(searchOverlay);
               _showing = false;  
               //print("avsz hideeeeee");
               }

          
      
          
      });
      widget.textField.onChanged?.call(text);
    }
  }