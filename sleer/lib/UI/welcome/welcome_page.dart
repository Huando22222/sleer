import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sleer/blocs/contact_bloc/contact_bloc.dart';
import 'package:sleer/blocs/contact_bloc/contact_event.dart';
import 'package:sleer/blocs/contact_bloc/contact_state.dart';

class WelComePage extends StatefulWidget {
  const WelComePage({super.key});

  @override
  State<WelComePage> createState() => _WelComePageState();
}

class _WelComePageState extends State<WelComePage> {
  // final ContactBloc contactBloc = ContactBloc();

  @override
  void initState() {
    // contactBloc.add(ContactInitialEvent());
    context.read<ContactBloc>().add(ContactInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactBloc, ContactState>(
      buildWhen: (previous, current) => true,
      builder: (context, state) {
        if (state is ContactFetchingLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ContactFetchingSuccessState) {
          return Center(
            child:
                Text(state.contacts[0].phones?[0].value ?? 'No contact found'),
          );
        } else if (state is ContactFetchingErrorState)
          return Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                Text("Error when get permission to get access to contact")
              ],
            ),
          );
        else {
          return Center(child: Text('Error fetching contacts'));
        }
      },
    );
  }
}
