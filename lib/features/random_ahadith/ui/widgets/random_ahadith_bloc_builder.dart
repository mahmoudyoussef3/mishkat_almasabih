import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat_almasabih/features/random_ahadith/logic/cubit/random_ahadith_cubit.dart';

class RandomAhadithBlocBuilder extends StatelessWidget {
  const RandomAhadithBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RandomAhadithCubit, RandomAhadithState>(
      builder: (context, state) {
        if (state is RandomAhadithLoading) {
          return CircularProgressIndicator();
        } else if (state is RandomAhadithSuccess) {
          return ListTile(
            title: Text(state.randomAhadithResponse.hadiths!.length.toString()),
          );
        } else if (state is RandomAhaditFailure) {
          return ListTile(title: Text(state.errMessage.toString()));
        }
        return SizedBox.shrink();
      },
    );
  }
}
