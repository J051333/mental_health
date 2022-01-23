import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import "package:path_provider/path_provider.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'mh_colors.dart';

final _defaultPassword = "p(7sb*4165749846516agsg^1223#asd";
late Directory appDataDir;

class NameJournalEntry extends StatefulWidget {
  final Function getJournals;
  const NameJournalEntry(this.getJournals, {Key? key}) : super(key: key);

  @override
  _NameJournalEntryState createState() => _NameJournalEntryState();
}

class _NameJournalEntryState extends State<NameJournalEntry> {
  final tec = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    tec.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passField = TextField(
        obscureText: false,
        controller: tec,
        cursorColor: MHColors.journalCursorColor,
        decoration: const InputDecoration(
          hintText: 'Name',
        ));

    // TODO: CHECK IF FSE EXISTS, IF NOT CREATE IT
    return AlertDialog(
      title: const Text("Journal Name"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          passField,
          Center(
            child: ElevatedButton(
              // TODO: CHECK IF tec.text IS EMPTY FOR NON-ENCRYPTED
              onPressed: () {
                print(tec.text);
                HapticFeedback.lightImpact();
                if (tec.text.isNotEmpty) {
                  // Create new popup and delete old
                  Future.microtask(() {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) =>
                          JournalGetPassword(tec.text, widget.getJournals),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      "Please give the journal a name",
                    ),
                  ));
                }
              },
              child: const Text("Done"),
            ),
          ),
        ],
      ),
    );
  }
}

class JournalGetPassword extends StatefulWidget {
  final Function getJournals;
  final String name;
  const JournalGetPassword(this.name, this.getJournals, {Key? key})
      : super(key: key);

  @override
  _JournalGetPasswordState createState() => _JournalGetPasswordState();
}

class _JournalGetPasswordState extends State<JournalGetPassword> {
  final tec = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    tec.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passField = TextField(
        obscureText: true,
        controller: tec,
        cursorColor: MHColors.journalCursorColor,
        decoration: const InputDecoration(
          hintText: 'Password',
        ));

    // TODO: CHECK IF FSE EXISTS, IF NOT CREATE IT
    return AlertDialog(
      title: Text(
          widget.name.isNotEmpty ? widget.name + "'s Password" : "Password"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          passField,
          Center(
            child: ElevatedButton(
              // TODO: CHECK IF tec.text IS EMPTY FOR NON-ENCRYPTED
              onPressed: () {
                print(tec.text);
                HapticFeedback.lightImpact();

                // Create new popup and delete old
                Future.microtask(() {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        if (tec.text.isNotEmpty) {
                          return WriteJournal(
                              widget.getJournals, widget.name, tec.text);
                        } else {
                          return WriteJournal(widget.getJournals, widget.name,
                              _defaultPassword);
                        }
                      });
                });
              },
              child: const Text("Done"),
            ),
          ),
        ],
      ),
    );
  }
}

class WriteJournal extends StatefulWidget {
  final Function getJournals;
  final String passedName;
  final String password;

  const WriteJournal(this.getJournals, this.passedName, this.password,
      {Key? key})
      : super(key: key);

  @override
  _WriteJournalState createState() => _WriteJournalState();
}

class _WriteJournalState extends State<WriteJournal> {
  late String name;
  late AesCrypt crypt;
  bool nameShown = true;
  final tec = TextEditingController();

  @override
  void initState() {
    super.initState();
    name = widget.passedName;
    crypt = AesCrypt(widget.password);
    crypt.setOverwriteMode(AesCryptOwMode.on);
  }

  @override
  void dispose() {
    super.dispose();
    tec.dispose();
  }

  Future<bool> _promptCloseCheck(BuildContext ctx) async {
    return await showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
            "Close?",
            "Any unsaved progress will be lost.",
            (context) {
              Navigator.pop(ctx, true);
              Navigator.pop(context, true);
              print("Continue");
            },
            (context) {
              Navigator.pop(context, false);
            },
          ),
        ) ??
        Future<bool>.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return _promptCloseCheck(context);
        },
        child: Scaffold(
          backgroundColor: MHColors.menuBGColor,
          appBar: AppBar(
            title: Text(
              nameShown ? name : "•" * name.length,
            ),
            actions: [
              IconButton(
                onPressed: () => setState(() {
                  if (nameShown) {
                    nameShown = false;
                  } else {
                    nameShown = true;
                  }
                }),
                icon: nameShown
                    ? const Icon(Icons.visibility_rounded)
                    : const Icon(Icons.visibility_off_rounded),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    decoration: const InputDecoration.collapsed(
                      hintText: "Start your journal here . . .",
                    ),
                    cursorColor: MHColors.journalCursorColor,
                    controller: tec,
                    scrollPadding: const EdgeInsets.all(20.0),
                    autofocus: true,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (tec.text.isNotEmpty) {
                crypt.encryptTextToFileSync(
                    tec.text, "${appDataDir.path}/data/journals/$name.jour");
                widget.getJournals();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    "Saved",
                  ),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    "Empty journals can't be saved",
                  ),
                ));
              }
            },
            child: const Icon(Icons.save),
          ),
        ));
  }
}

/// Instantiation asks the user for a password. Attempts to
/// decrypt passed FileSystemEntity's content and passes it to
/// an opener.
class JournalPassDecode extends StatefulWidget {
  final Function getJournals;
  final String journalName;
  const JournalPassDecode(this.getJournals, this.journalName, {Key? key})
      : super(key: key);

  @override
  _JournalPassDecodeState createState() => _JournalPassDecodeState();
}

class _JournalPassDecodeState extends State<JournalPassDecode> {
  final tec = TextEditingController();
  late String password;
  late AesCrypt crypt;

  @override
  void initState() {
    super.initState();
    password = "";
    crypt = AesCrypt(password);
    crypt.setOverwriteMode(AesCryptOwMode.on);
  }

  @override
  void dispose() {
    tec.dispose();
    super.dispose();
  }

  void decrypt() {
    try {
      if (password.isNotEmpty) {
        crypt.setPassword(password);
      } else {
        crypt.setPassword(_defaultPassword);
      }

      String decText = crypt.decryptTextFromFileSync(
          "${appDataDir.path}/data/journals/${widget.journalName}.jour");

      print(decText);

      Future.microtask(() {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JournalRead(widget.journalName, decText),
            maintainState: false,
          ),
        );
      });
      widget.getJournals();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Wrong password",
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final passField = TextField(
        obscureText: true,
        cursorColor: MHColors.journalCursorColor,
        controller: tec,
        decoration: const InputDecoration(
          hintText: 'Password',
        ));

    // TODO: CHECK IF FSE EXISTS, IF NOT CREATE IT
    return AlertDialog(
      title: const Text("Journal Password"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          passField,
          Center(
            child: ElevatedButton(
              // TODO: CHECK IF tec.text IS EMPTY FOR NON-ENCRYPTED
              onPressed: () {
                print(tec.text);
                HapticFeedback.lightImpact();
                password = tec.text;
                decrypt();
              },
              child: const Text("Done"),
            ),
          ),
        ],
      ),
    );
  }
}

class JournalRead extends StatefulWidget {
  final String journalName;
  final String journalText;
  const JournalRead(this.journalName, this.journalText, {Key? key})
      : super(key: key);

  @override
  _JournalReadState createState() => _JournalReadState();
}

class _JournalReadState extends State<JournalRead> {
  bool nameShown = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MHColors.menuBGColor,
      appBar: AppBar(
        title: Text(
          nameShown ? widget.journalName : "•" * widget.journalName.length,
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() {
              if (nameShown) {
                nameShown = false;
              } else {
                nameShown = true;
              }
            }),
            icon: nameShown
                ? const Icon(Icons.visibility_rounded)
                : const Icon(Icons.visibility_off_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Text(widget.journalText),
            ),
          ],
        ),
      ),
    );
  }
}

class JournalList extends StatefulWidget {
  const JournalList({Key? key}) : super(key: key);

  @override
  State<JournalList> createState() => _JournalListState();
}

class _JournalListState extends State<JournalList> {
  final names = <String>[];
  // Only FSEs of type File are added to the list as dictated by the if statement
  final journals = <FileSystemEntity>[];

  @override
  void initState() {
    // Internally calls _setNames()
    _getJournals();
    super.initState();
  }

  _getNames() async {
    final currentJournals = <FileSystemEntity>[];
    currentJournals.addAll(journals);

    for (FileSystemEntity fse in currentJournals) {
      // No need to check if fse is File
      if (await fse.exists()) {
        names.add((fse as File).path.split('/').last.split('.').first);
      }
    }
    setState(() {
      print("getting names $names");
    });
  }

  void _getJournals() async {
    journals.clear();
    names.clear();
    // Get the directory that the journals are stored in
    appDataDir = await getApplicationDocumentsDirectory();
    final dir = Directory("${appDataDir.path}/data/journals");

    if (await dir.exists()) {
      // If dir exists, we add all journals to the list
      // Files in dir should only be journals
      journals.clear();
      dir.list().listen((fse) {
        if (fse is File) journals.add(fse);
      }, onDone: () {
        // Reset the names and set the state after getting all current journals
        _getNames();
      });
    } else {
      // Create /data and /data/journals
      // Should only run once per install
      await dir.create(recursive: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MHColors.menuBGColor,
      appBar: AppBar(
        title: const Text("Journals"),
        actions: [
          IconButton(
              onPressed: () async {
                bool deleteAll = await showDialog(
                    context: context,
                    builder: (context) => ConfirmDialog(
                          "Delete All Journals?",
                          "Are you sure you want to delete all your journals?",
                          (context) => {Navigator.of(context).pop(true)},
                          (context) => {Navigator.of(context).pop(false)},
                        ));
                if (deleteAll) {
                  final delDir = Directory("${appDataDir.path}/data/journals");
                  if (await delDir.exists()) {
                    setState(() {
                      delDir.delete(recursive: true);
                      _getJournals();
                      print("Delete" + journals.toString());
                    });
                  }
                }
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: SizedBox.expand(
        child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ListView.builder(
                itemCount: names.length,
                itemBuilder: (BuildContext itemContext, int index) {
                  print("Building listview ${names.isEmpty}");
                  return names.isEmpty
                      ? const Text("No Journals")
                      : JournalListItem(_getJournals, names[index]);
                })),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Future.microtask(() {
              showDialog(
                context: context,
                builder: (context) => GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Builder(
                      builder: (context) => GestureDetector(
                        onTap: () {},
                        child: NameJournalEntry(_getJournals),
                      ),
                    ),
                  ),
                ),
              );
            });
          },
          child: const Icon(Icons.add_rounded)),
    );
  }
}

class JournalListItem extends StatelessWidget {
  final Function getJournals;
  final String journalName;

  const JournalListItem(this.getJournals, this.journalName, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: MHColors.menuButtonColor,
        // border: Border.all(
        //   color: Colors.blue,
        // ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: TextButton(
          onPressed: () {
            Future.microtask(() {
              showDialog(
                context: context,
                builder: (context) =>
                    JournalPassDecode(getJournals, journalName),
              );
            });
          },
          child: Text(
            journalName,
            style: TextStyle(
              color: MHColors.menuButtonTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class ConfirmDialog extends StatefulWidget {
  final String title;
  final String text;
  final Function(BuildContext) cont;
  final Function(BuildContext) cancel;

  const ConfirmDialog(this.title, this.text, this.cont, this.cancel, {Key? key})
      : super(key: key);

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.text),
      actions: [
        ElevatedButton(
            onPressed: () => widget.cont(context),
            child: const Text("Continue")),
        ElevatedButton(
            onPressed: () => widget.cancel(context),
            child: const Text("Cancel")),
      ],
    );
  }
}
