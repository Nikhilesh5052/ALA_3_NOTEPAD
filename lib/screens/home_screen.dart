import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/storage_service.dart';
import 'add_edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Note> notes = [];
  List<Note> deletedNotes = [];

  bool showRecycleBin = false;
  bool isDark = true;

  void loadNotes() async {
    notes = await StorageService.getNotes();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  // 🔥 DELETE → MOVE TO BIN
  void deleteNote(int index) {
    deletedNotes.add(notes[index]);
    notes.removeAt(index);

    StorageService.saveNotes(notes);
    setState(() {});
  }

  // 🔥 RESTORE
  void restoreNote(int index) {
    notes.add(deletedNotes[index]);
    deletedNotes.removeAt(index);
    setState(() {});
  }

  // 🔥 DELETE FOREVER
  void deleteForever(int index) {
    deletedNotes.removeAt(index);
    setState(() {});
  }

  // 🔥 SIDE MENU
  void openMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  setState(() => showRecycleBin = false);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: !showRecycleBin ? Colors.grey[800] : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.note, color: Colors.white),
                      SizedBox(width: 10),
                      Text("All notes", style: TextStyle(fontSize: 18)),
                      Spacer(),
                      Text("${notes.length}",
                          style: TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  setState(() => showRecycleBin = true);
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Recycle bin", style: TextStyle(fontSize: 18)),
                    Spacer(),
                    Text("${deletedNotes.length}",
                        style: TextStyle(color: Colors.grey))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 📅 DATE FORMAT
  String formatDate(DateTime date) {
    return "${date.day} ${getMonth(date.month)}";
  }

  String getMonth(int m) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {

    List<Note> displayList = showRecycleBin ? deletedNotes : notes;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            SizedBox(height: 20),

            // TITLE
            Center(
              child: Column(
                children: [
                  Text(
                    showRecycleBin ? "Recycle bin" : "All notes",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text("${displayList.length} notes",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            SizedBox(height: 20),

            // TOP BAR
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  IconButton(
                    icon: Icon(Icons.menu,
                        color: isDark ? Colors.white : Colors.black),
                    onPressed: openMenu,
                  ),

                  Row(
                    children: [

                      // 🌙 DARK MODE
                      IconButton(
                        icon: Icon(
                          isDark ? Icons.dark_mode : Icons.light_mode,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            isDark = !isDark;
                          });
                        },
                      ),

                      Icon(Icons.search,
                          color: isDark ? Colors.white : Colors.black),

                      SizedBox(width: 10),

                      Icon(Icons.more_vert,
                          color: isDark ? Colors.white : Colors.black),
                    ],
                  )
                ],
              ),
            ),

            SizedBox(height: 20),

            // LIST WITH SWIPE
            Expanded(
              child: ListView.builder(
                itemCount: displayList.length,
                itemBuilder: (context, index) {

                  return Dismissible(
                    key: Key(displayList[index].title + index.toString()),
                    direction: showRecycleBin
                        ? DismissDirection.none
                        : DismissDirection.endToStart,

                    onDismissed: (direction) {
                      deleteNote(index);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Note deleted"),
                          action: SnackBarAction(
                            label: "UNDO",
                            onPressed: () {
                              restoreNote(deletedNotes.length - 1);
                            },
                          ),
                        ),
                      );
                    },

                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),

                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[900] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [

                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),

                          SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  displayList[index].title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),

                                SizedBox(height: 5),

                                Text(
                                  displayList[index].description,
                                  style: TextStyle(color: Colors.grey),
                                  maxLines: 1,
                                ),

                                SizedBox(height: 5),

                                Text(
                                  formatDate(displayList[index].modifiedAt),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),

                          // 🔥 RECYCLE BIN OPTIONS
                          if (showRecycleBin)
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.restore,
                                      color: Colors.green),
                                  onPressed: () {
                                    restoreNote(index);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_forever,
                                      color: Colors.red),
                                  onPressed: () {
                                    deleteForever(index);
                                  },
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[800],
        child: Icon(Icons.edit, color: Colors.redAccent),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditNoteScreen(),
            ),
          );
          loadNotes();
        },
      ),
    );
  }
}