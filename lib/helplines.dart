import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mental_health/mh_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';

class HelplineList extends StatefulWidget {
  const HelplineList({Key? key}) : super(key: key);

  @override
  State<HelplineList> createState() => _HelplineListState();
}

class _HelplineListState extends State<HelplineList> {
  _openNumber(final String num) async {
    final url = "tel:" + num;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Could not open number.",
        ),
      ));
      ;
    }
  }

  _openLink(final String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Could not open link.",
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Helplines"),
      ),
      body: SizedBox.expand(
        child: ListView(
          children: [
            // USA
            HelplineItem(
              text: "United States",
              children: [
                // NSPL
                HelplineItem(
                  text: "Suicide Lifeline",
                  children: [
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Call: 1-800-273-TALK(8255)",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      onTap: () {
                        _openNumber("18002738255");
                      },
                    ),
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "NSPL Site",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      onTap: () {
                        _openLink("https://suicidepreventionlifeline.org/");
                      },
                    ),
                  ],
                ),
                // The Trevor Project
                HelplineItem(
                  text: "The Trevor Project (LGBTQ+ Help)",
                  children: [
                     // Call
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Call: 1-866-488-7386",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      onTap: () {
                        _openNumber("18664887386");
                      },
                    ),
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Site",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      onTap: () {
                        _openLink("https://www.thetrevorproject.org/");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HelplineItem extends StatefulWidget {
  final String text;
  final List<Widget>? children;
  const HelplineItem({required this.text, required this.children, Key? key})
      : super(key: key);

  @override
  State<HelplineItem> createState() => _HelplineItemState();
}

class _HelplineItemState extends State<HelplineItem> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.text),
      children: widget.children ?? const <Widget>[],
    );
  }
}
