import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/storage_service.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;
  final int? index;

  AddEditNoteScreen({this.note, this.index});

  @override
  _AddEditNoteScreenState createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      titleController.text = widget.note!.title;
      descController.text = widget.note!.description;
    }
  }

  void saveNote() async {
    List<Note> notes = await StorageService.getNotes();

    if (widget.note == null) {
      notes.add(
        Note(
          title: titleController.text,
          description: descController.text,
          createdAt: DateTime.now(),
          modifiedAt: DateTime.now(),
        ),
      );
    } else {
      notes[widget.index!] = Note(
        title: titleController.text,
        description: descController.text,
        createdAt: widget.note!.createdAt,
        modifiedAt: DateTime.now(),
      );
    }

    await StorageService.saveNotes(notes);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Note"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Title",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),

            SizedBox(height: 10),

            TextField(
              controller: descController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Description",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveNote,
              child: Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}