import 'dart:io';

import 'package:agenda_de_contatos/repository/contact_repository.dart';
import 'package:agenda_de_contatos/view/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domain/contact.dart';

enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  ContactRepository _contactRepository = ContactRepository();

  List<Contact> contactList = [];

  @override
  void initState() {
    super.initState();

    _getAllContacts();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: [PopupMenuButton<OrderOptions>(
            itemBuilder: (context)  => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordernar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordernar de Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
          onSelected: _onderList,
        )],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return _contactCard(context, contactList[index]);
        },
        itemCount: contactList.length,
        padding: const EdgeInsets.all(10.0),),
    );
  }

  Widget _contactCard(BuildContext context, Contact contact) {

    return GestureDetector(
      onTap: () {
        _showOptions(context, contact);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contact.imgUrl != null ?
                      FileImage(File(contact.imgUrl!)) :
                      AssetImage("images/person.png") as ImageProvider,
                  )
                ),
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name ?? "",
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    contact.email ?? "",
                    style: TextStyle(fontSize: 18.0,),
                  ),
                  Text(
                    contact.phone ?? "",
                    style: TextStyle(fontSize: 18.0,),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

  }

  void _showOptions(BuildContext context, Contact? contact) {

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            launch("tel:${contact!.phone ?? ""}");
                          },
                          child: const Text("Ligar",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20.0
                            ),
                          ),
                      ),
                      const SizedBox(width: 10.0),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contact);
                        },
                        child: const Text("Editar",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20.0
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();

                          setState(() {
                            _contactRepository.deleteContact(contact!.idContact!);
                            contactList.remove(contact);
                          });
                        },
                        child: const Text("Excluir",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20.0
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
          );
        });

  }

  void _showContactPage({Contact? contact}) async {

    final Contact? recContact = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact,))
    );

    if (recContact != null) {

      if (recContact.idContact != null) {

        await _contactRepository.updateContact(recContact, recContact.idContact!);

      } else {

        await _contactRepository.saveContact(recContact);

      }

      _getAllContacts();

    }

  }

  void _getAllContacts() {

    setState(() {
      _contactRepository.getAllContact().then((contactList) => this.contactList = contactList);
    });

  }

  void _onderList(OrderOptions orderOptions) {

    switch(orderOptions){

      case OrderOptions.orderaz:
        contactList.sort((a,b) {
          if (a.name == null || b.name == null)
            return -1;
          else
            return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
        });
        break;

      case OrderOptions.orderza:
        contactList.sort((a,b) {
          if (b.name == null || a.name == null)
            return -1;
          else
            return b.name!.toLowerCase().compareTo(a.name!.toLowerCase());
        });
        break;

    }

    setState(() {});

  }
}


