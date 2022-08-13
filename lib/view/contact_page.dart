import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/contact.dart';

class ContactPage extends StatefulWidget {

  final Contact? contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Contact? _editedContact;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {

      _editedContact = Contact();

    } else {

      _editedContact = Contact.fromMap(widget.contact!.toMap());

      _nameController.text = _editedContact!.name ?? "";
      _emailController.text = _editedContact!.email ?? "";
      _phoneController.text = _editedContact!.phone ?? "";

    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact!.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact!.name != null && _editedContact!.name!.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            }

            FocusScope.of(context).requestFocus(_nameFocus);
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.save)
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
                      if (file != null) {
                        setState(() {
                          _editedContact!.imgUrl = file.path;
                        });
                      }
                    });
                  });
                },
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _editedContact!.imgUrl != null ?
                        FileImage(File(_editedContact!.imgUrl!)) :
                        AssetImage("images/person.png") as ImageProvider,
                      )
                  ),
                ),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Name"),
                controller: _nameController,
                focusNode: _nameFocus,
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact!.name = text;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Email"),
                controller: _emailController,
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact!.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Phone"),
                controller: _phoneController,
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact!.phone = text;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    
    if (_userEdited) {

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Descartar Alterações?"),
              content: const Text("Se sair suas alterações seram perdidas!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancelar")
                ),
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text("Sim"))
              ],
            );
          }
      );

      return Future.value(false);

    } else {

      return Future.value(true);

    }
    
  }
  
}
