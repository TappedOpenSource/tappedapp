import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/comments/comments_cubit.dart';
import 'package:intheloopapp/ui/tagging/search/tag_detector_field.dart';

class CommentsTextField extends StatefulWidget {
  const CommentsTextField({super.key});

  @override
  CommentsTextFieldState createState() => CommentsTextFieldState();
}

class CommentsTextFieldState extends State<CommentsTextField> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lightWhite = Colors.white.withOpacity(0.5);
    return BlocBuilder<CommentsCubit, CommentsState>(
      builder: (context, state) {
        if (state.loop.commentsLocked) {
          return Column(
            children: [
              Divider(
                height: 0,
                thickness: 0.5,
                color: lightWhite,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'comments have been locked for this loop',
                    style: TextStyle(
                      color: lightWhite,
                    ),
                  ),
                  Icon(
                    Icons.lock,
                    color: lightWhite,
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Divider(
                height: 0,
                thickness: 0.5,
                color: lightWhite,
              ),
            ],
          );
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                SizedBox(
                  width: 300,
                  //height: 400,
                  child: TagDetectorField(textField: TextField(
                    onChanged: (value) =>
                        context.read<CommentsCubit>().changeComment(value),
                    controller: _textEditingController,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    minLines: 3,
                    decoration: const InputDecoration.collapsed(
                      // border: OutlineInputBorder(),
                      hintText: 'Add Comment...',
                    ),
                  ),
                  controller: _textEditingController,
                ),
                ),
                IconButton(
                  onPressed: () async {
                    await context.read<CommentsCubit>().addComment();
                    _textEditingController.clear();
                  },
                  icon: state.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.send),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}