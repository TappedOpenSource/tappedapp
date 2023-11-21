import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/create_loop/cubit/create_loop_cubit.dart';

class LoopTitleTextField extends StatelessWidget {

   LoopTitleTextField({super.key, TextEditingController? controller}) : controller = controller ?? TextEditingController();
final TextEditingController controller;



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateLoopCubit, CreateLoopState>(
      builder: (context, state) {
         
        var returnThis = TextFormField(
          controller: controller,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          decoration: const InputDecoration.collapsed(
            // prefixIcon: Icon(Icons.title),
            // labelText: 'Title (optional)',
            hintText: 'Title (optional)',
          ),
          maxLength: 56,
          onChanged: (input) => context.read<CreateLoopCubit>().onTitleChange(
                input.trim(),
              ),
        );
        var tagController = returnThis.controller;
        var tagTextField = returnThis; 
        return returnThis; 
        
        //TagDetectorField(Container(child: Text('hello')), tagController);
      },
    );
  }
}
