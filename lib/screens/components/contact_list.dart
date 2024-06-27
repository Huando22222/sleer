import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleer/blocs/contact_bloc/contact_bloc.dart';
import 'package:sleer/blocs/contact_bloc/contact_state.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    final state = BlocProvider.of<ContactBloc>(context).state;
    if (state is ContactFetchingSuccessState) {
      return Scaffold(
        body: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 20,
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipOval(
                          child: Container(
                            color: Colors.amber,
                            height: 60,
                            width: 60,
                            child: const Icon(Icons.person),
                          ),
                          // Text(state.contacts[index].avatar!.isEmpty
                          //     ? "empty"
                          //     : "anh"),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                state.contacts[index].displayName.toString(),
                              ),
                              Text(
                                overflow: TextOverflow.ellipsis,
                                state.contacts[index].phones![0].value
                                    .toString(),
                              ),
                            ],
                          ),
                        ),
                        ClipOval(
                          child: Container(
                            // color: Colors.amber,
                            height: 60,
                            width: 60,
                            child: Icon(Icons.person),
                          ),
                          // Text(state.contacts[index].avatar!.isEmpty
                          //     ? "empty"
                          //     : "anh"),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: state.contacts.length,
              ),
            ),
          ],
        ),
      );
    } else {
      return const Text("No contact found");
    }
  }
}
