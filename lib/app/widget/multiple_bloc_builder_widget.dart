import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultiBlocBuilderWidget<
    E,
    S,
    B1 extends Bloc<E, S>,
    B2 extends Bloc<E, S>,
    B3 extends Bloc<E, S>,
    B4 extends Bloc<E, S>,
    B5 extends Bloc<E, S>,
    B6 extends Bloc<E, S>,
    CS extends S> extends StatelessWidget {
  const MultiBlocBuilderWidget({
    super.key,
    required this.builder,
    this.buildWhen,
  });

  final BlocWidgetBuilder<S> builder;
  final BlocBuilderCondition<S>? buildWhen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B1, S>(
      buildWhen: (previous, current) =>
          buildWhen?.call(previous as S, current as S) ?? true,
      builder: (context, state) {
        return BlocBuilder<B2, S>(
          buildWhen: (previous, current) =>
              buildWhen?.call(previous as S, current as S) ?? true,
          builder: (context, state) {
            return BlocBuilder<B3, S>(
              buildWhen: (previous, current) =>
                  buildWhen?.call(previous as S, current as S) ?? true,
              builder: (context, state) {
                return BlocBuilder<B4, S>(
                  buildWhen: (previous, current) =>
                      buildWhen?.call(previous as S, current as S) ?? true,
                  builder: (context, state) {
                    return BlocBuilder<B5, S>(
                      buildWhen: (previous, current) =>
                          buildWhen?.call(previous as S, current as S) ??
                          true,
                      builder: (context, state) {
                        return BlocBuilder<B6, S>(
                          buildWhen: (previous, current) =>
                              buildWhen?.call(previous as S, current as S) ??
                              true,
                          builder: (context, state) {

                            return builder(context, state);
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  S _combineStates<S>(
    S state1,
    S state2,
    S state3,
    S state4,
    S state5,
    S state6,
  ) {
// Combine all states into a single common state
// Customize this logic to suit your application
    return CommonState<S>(
      state1: state1,
      state2: state2,
      state3: state3,
      state4: state4,
      state5: state5,
      state6: state6,
    ) as S;
  }
}

class CommonState<S> {
  final S state1;
  final S state2;
  final S state3;
  final S state4;
  final S state5;
  final S state6;

  CommonState({
    required this.state1,
    required this.state2,
    required this.state3,
    required this.state4,
    required this.state5,
    required this.state6,
  });
}
