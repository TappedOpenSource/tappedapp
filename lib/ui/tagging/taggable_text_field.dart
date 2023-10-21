import 'package:flutter/material.dart';

class TaggableTextField extends TextField {
  

  // ignore: public_member_api_docs
   TaggableTextField({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign textAlign = TextAlign.start,
    TextDirection? textDirection,
    bool autofocus = false,
    bool readOnly = false,
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    bool obscureText = false,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    int? maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    bool maxLengthEnforced = true,
    //on changed, check for an @ symbol, if so, overlay an icon.  if not, execute the regular onChanged

    ValueChanged<String>? onChanged,
    
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onSubmitted,
    //List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    GestureTapCallback? onTap,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    AutovalidateMode? autovalidateMode,
    bool enableIMEPersonalizedLearning = true,
    bool enableSuggestionsForDarkTheme = true,
    bool useTextSelectionControls = true,
    TextSelectionControls? textSelectionControls,
    String? restorationId,
    bool Function(String, TextEditingController?)? checkForAtSymbol,
    
  }) : super(
          key: key,
          controller: controller,
          focusNode: focusNode,
          decoration: decoration,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          autofocus: autofocus,
          readOnly: readOnly,
          toolbarOptions: toolbarOptions,
          showCursor: showCursor,
          obscureText: obscureText,
          autocorrect: autocorrect,
          smartDashesType: smartDashesType,
          smartQuotesType: smartQuotesType,
          enableSuggestions: enableSuggestions,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          maxLength: maxLength,
          //maxLengthEnforced: maxLengthEnforced,
          onChanged: (value) {
            // Call the original onChanged callback
            
            
            // Call your custom function
            if (checkForAtSymbol!(value, controller))
              ;

            
              onChanged?.call(value);
            
          },
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          //inputFormatters: this.inputFormatters,
          enabled: enabled,
          cursorWidth: cursorWidth,
          cursorHeight: cursorHeight,
          cursorRadius: cursorRadius,
          cursorColor: cursorColor,
          keyboardAppearance: keyboardAppearance,
          scrollPadding: scrollPadding,
          enableInteractiveSelection: enableInteractiveSelection,
          onTap: onTap,
          buildCounter: buildCounter,
          scrollPhysics: scrollPhysics,
          autofillHints: autofillHints,
          //autovalidateMode: autovalidateMode,
          enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
          //enableSuggestionsForDarkTheme: enableSuggestionsForDarkTheme,
          //useTextSelectionControls: true,
          //textSelectionControls: textSelectionControls,
          restorationId: restorationId,
        );


Widget build(BuildContext context) {
    return Stack(children: [TaggableTextField(), Icon(Icons.add)]);
  }


  //this function figures out whether or not to display the tag menu
  //if the user types an @ symbol, it will display the tag menu
    bool checkForAtSymbol(String value, TextEditingController? controller) {
    if (value.contains('@')) {
    //check if controller.selection.baseOffset is null and if so return false
    if(controller?.selection.baseOffset == null) {
      return false;
    }
    if(controller?.selection.baseOffset == null) {
      return false;
    }
    //find where the cursor is
    var cursorPosition = controller!.selection.baseOffset;
    //find the text before the cursor
    var textBeforeCursor = value.substring(0, cursorPosition);
    //find the last word before the cursor
    var wordCursorOn = textBeforeCursor.split(' ').last;
    //if the @ symbol is NOT the first character, return false
    if(wordCursorOn.indexOf('@') < 1) return false;
    //hence, we're left with only the instances where there's a ' ' and then an '@' symbol
    return true;
    }
    return false;





  }
}

