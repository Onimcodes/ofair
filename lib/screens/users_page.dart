
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofair/common/dependency_injection.dart';
import 'package:ofair/presentation/bloc/users_bloc.dart';
import 'package:ofair/presentation/bloc/users_event.dart';
import 'package:ofair/presentation/bloc/users_state.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)  => getit<UsersBloc>()..add(GetUsersEvent()),
      child: Scaffold(  
        appBar: AppBar(
          title: Text('Users'),
        ),
        body: BlocBuilder<UsersBloc, UserState>
        (
          builder: (context, state) {
          if(state.status == UserStatus.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(state.status == UserStatus.error) {
            return Center(
              child : Text(state.errorMessage ?? '')
            );
          }

          else if(state.status == UserStatus.success) {
            return ListView.builder(itemBuilder: (context, index) {
              return ListTile(
                title: Text(state.users![index].firstName),
                subtitle: Text(state.users![index].email),

              );
            }, itemCount: state.users?.length ?? 0, shrinkWrap: true,);
          }
          // Always return a widget in case none of the above conditions match
          return Container();
        }
        ),
      ),
    );
  }
}