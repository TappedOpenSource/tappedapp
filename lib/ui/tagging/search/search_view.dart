    import 'package:flutter/material.dart';
    import 'package:flutter_bloc/flutter_bloc.dart';
    import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
    import 'package:intheloopapp/ui/tagging/search/components/by_username_results_list.dart';
    import 'package:intheloopapp/ui/tagging/search/components/cancel_icon.dart';
    import 'package:intheloopapp/ui/tagging/search/components/tapped_search_bar.dart';
    import 'package:intheloopapp/ui/themes.dart';

    class SearchView extends StatefulWidget {
      SearchView({
        FocusNode? searchFocusNode,
        required this.tag,
        //required TextEditingController tagController,
        required VoidCallback this.onClear,
        Key? key, required this.tagController,
      })  : searchFocusNode = searchFocusNode ?? FocusNode(),
            super(key: key);

      final FocusNode searchFocusNode;
      final VoidCallback onClear;
      TextEditingController tagController;
      String tag;

      @override
      // ignore: library_private_types_in_public_api
      _SearchViewState createState() => _SearchViewState();
    }

    class _SearchViewState extends State<SearchView>
        with TickerProviderStateMixin {
      @override
      void initState() {
        super.initState();
        _searchController = TextEditingController();
        
      }

      @override
      void dispose() {
        super.dispose();
        _searchController.dispose();
      }

      List<Widget> _buildActions() {
        return [
          CancelIcon(
            focusNode: widget.searchFocusNode,
            searchController: _searchController,
            onClear: widget.onClear,
          ),
        ];
      }

      late final TextEditingController _searchController;
      TextEditingController getSearchController() {_searchController.text = widget.tag.substring(1); return _searchController;}

      @override
      Widget build(BuildContext context) {
        final theme = Theme.of(context);
        //set the text controller's text to the tag
        //then set the state
        

        return Scaffold(
          //backgroundColor: theme.colorScheme.background,
          backgroundColor: Colors.red,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.5,
            backgroundColor: theme.colorScheme.background,
            title: TappedSearchBar(
              tagController: widget.tagController,
              searchFocusNode: widget.searchFocusNode,
              searchController: getSearchController(),
            ),
            actions: _buildActions(),
          ),
          body: ByUsernameResultsList(
            tagController: widget.tagController, 
            onClear: widget.onClear,),
        );
      }
    }
     