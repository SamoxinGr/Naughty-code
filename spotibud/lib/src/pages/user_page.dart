import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotibud/src/utils/url_launch.dart';
import 'package:spotibud/src/widgets/lastNews_cards/last_news_widget.dart';
import 'package:spotibud/src/models/user_info.dart' as user;
import 'package:spotibud/src/widgets/userPage_cards/user_page_widget.dart';

import '../pages/cubit/userPage/user_page_cubit.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserCubit(),
      child: const _UserState(),
    );
  }
}

class _UserState extends StatelessWidget {
  const _UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is UserInitial) {
        context.read<UserCubit>().informInitial();
        context
            .read<UserCubit>()
            .loadUser(); // run Circular progress bar while news is loading
        return const Center(
          child: CircularProgressIndicator(backgroundColor: Colors.greenAccent),
        );
      }

      if (state is UserLoadedState) {
        return RefreshIndicator(
          child: Scaffold(
            appBar: GetAppBar(context),
            body: GetBody(state),
            backgroundColor: Colors.black,
          ),
          backgroundColor: Colors.black87,
          onRefresh: () => context.read<UserCubit>().reloadUser(),
        );
      }
      return Container();
    });
  }

  PreferredSizeWidget GetAppBar(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      toolbarHeight: height / 13,
      title: Padding(
        padding: const EdgeInsets.only(
          left: 5,
          right: 5,
          top: 40,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [],
        ),
      ),
    );
  }

  Widget GetBody(state) {
    return ListView.builder(
      itemCount: state.UserList.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: UserInfoWidget(state.UserList[index], context, state),
        );
      },
    );
  }
}
