import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_interface/contact.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController descController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  List<Contact> contacts = List.empty(growable: true);

  int selectedIndex = -1;
  String? type;
  SharedPreferences? sp;

  saveIntoSp() {
    //
    List<String> contactListString =
        contacts.map((contact) => jsonEncode(contact.toJson())).toList();
    sp?.setStringList('myData', contactListString);
    //
  }

  readFromSp() {
    //
    List<String>? contactListString = sp?.getStringList('myData');
    if (contactListString != null) {
      contacts = contactListString
          .map((contact) => Contact.fromJson(json.decode(contact)))
          .toList();
    }
    setState(() {});
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 15, 43, 27),
              Color.fromARGB(255, 42, 204, 171)
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Home "),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Card(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    contacts.isEmpty
                        ? const Text(
                            'No messages yet..',
                            style: TextStyle(fontSize: 22),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: contacts.length,
                              itemBuilder: (context, index) => getRows(index),
                            ),
                          )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    // prefixIcon: Icon(Icons.lock),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Digite Seu Texto",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                  onSubmitted: (value) {
                    print(value);

                    if (type == 'edit') {
                      if (descController.text.isNotEmpty) {
                        setState(() {
                          // descController.text = '';

                          contacts[selectedIndex].descripion =
                              descController.text;
                          // contacts[selectedIndex].contact = contact;
                          descController.text = "";
                          selectedIndex = -1;
                        });
                        // Saving contacts list into Shared Prefrences
                        saveIntoSp();
                        type = "";
                      }
                    } else {
                      if (descController.text.isNotEmpty) {
                        setState(() {
                          // descController.text = '';

                          contacts
                              .add(Contact(descripion: descController.text));
                          descController.text = "";
                        });
                        // Saving contacts list into Shared Prefrences
                        saveIntoSp();
                      }
                    }

                    //value is entered text after ENTER press
                    //you can also call any function here or make setState() to assign value to other variable
                  },
                  textInputAction: TextInputAction.search,
                )),
          ],
        ),
      ),
    );
  }

  Widget getRows(int index) {
    return Card(
      child: Container(
        height: 150,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Texto Digitado $index",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        descController.text = contacts[index].descripion;

                        setState(() {
                          selectedIndex = index;
                          type = "edit";
                        });
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          contacts.removeAt(index);
                        });
                        saveIntoSp();
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                contacts[index].descripion,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRow(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
          foregroundColor: Colors.white,
          child: Text(
            contacts[index].descripion[0],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contacts[index].descripion,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // Text(contacts[index].contact),
          ],
        ),
        trailing: SizedBox(
          width: 70,
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    //
                    descController.text = contacts[index].descripion;

                    setState(() {
                      selectedIndex = index;
                    });
                    //
                  },
                  child: const Icon(Icons.edit)),
              InkWell(
                  onTap: (() {
                    //
                    setState(() {
                      contacts.removeAt(index);
                    });
                    // Saving contacts list into Shared Prefrences
                    saveIntoSp();
                    //
                  }),
                  child: const Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }
}
