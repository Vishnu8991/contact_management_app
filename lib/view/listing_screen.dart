import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contact_management_app/controller/controller.dart';
import 'package:contact_management_app/view/add_screen.dart';
import 'package:contact_management_app/view/edit_screen.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({Key? key}) : super(key: key);

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ContactProvider>(context, listen: false).fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        title: Text("Contacts", style: TextStyle(color: Colors.white)),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Consumer<ContactProvider>(
            builder: (context, contactProvider, _) {
              List<Map<String, dynamic>> sortedContacts =
                  List.from(contactProvider.contacts);
              sortedContacts.sort((a, b) =>
                  (a['firstname'] as String).compareTo(b['firstname'] as String));
              return sortedContacts.isEmpty
                  ? Center(child: Text("No Contacts"))
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: sortedContacts.length,
                            itemBuilder: (context, index) {
                              final contact = sortedContacts[index];
                              return Dismissible(
                                key: Key(contact['id'].toString()),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Icon(Icons.delete, color: Colors.white),
                                ),
                                confirmDismiss: (direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Confirm"),
                                      content: Text(
                                          "Are you sure you want to delete this contact?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text("Delete"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                onDismissed: (direction) async {
                                  await Provider.of<ContactProvider>(context,
                                          listen: false)
                                      .deleteContact(contact['id']);
                                },
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditScreen(contact: contact)),
                                  ).then((value) => Provider.of<ContactProvider>(
                                          context,
                                          listen: false)
                                      .fetchContacts()),
                                  child: Padding(
                                    padding: EdgeInsets.all(constraints.maxWidth * 0.02),
                                    child: Container(
                                      padding: EdgeInsets.all(constraints.maxWidth * 0.02),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Colors.grey.shade100),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${contact['firstname']}\t',
                                                style: TextStyle(
                                                    fontSize: constraints.maxWidth * 0.05,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                contact['lastname'],
                                                style: TextStyle(
                                                    fontSize: constraints.maxWidth * 0.05,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            contact['number'].toString(),
                                            style: TextStyle(
                                              fontSize: constraints.maxWidth * 0.04,
                                                color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AddScreen(onContactCreated: () {})),
        ).then((value) => Provider.of<ContactProvider>(context, listen: false)
            .fetchContacts()),
        child: Icon(Icons.add),
      ),
    );
  }

  void loadUi() {
    setState(() {});
  }
}
