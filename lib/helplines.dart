import 'package:flutter/material.dart';
import 'package:mental_health/mh_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mental_health/webview.dart';
import 'dart:io';

class HelplineList extends StatefulWidget {
  const HelplineList({Key? key}) : super(key: key);

  @override
  State<HelplineList> createState() => _HelplineListState();
}

class _HelplineListState extends State<HelplineList> {

  /// Attempts to open [num] in the OS's phone app.
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
    }
  }

  /// Attempts to open texts to [num] with the optional text [body].
  _textNumber(final String num, final String? body) async {
    final String queryChar;
    if(Platform.isIOS){
      // ios is weird
      queryChar = '&';
    } else {
      queryChar = '?';
    }

    final url = "sms:" + (body != null ? num + queryChar + "body=" + body : num);

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Could not open number.",
        ),
      ));
    }
  }

  /// Opens [url] in a browser or a webview if a browser isn't available.
  _openLink(final String title, final String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewApp(title: title, url: url),
            maintainState: false,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MHColors.menuBGColor,
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
                    // Call
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Call the NSPL: 1-800-273-TALK(8255)",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: MHColors.helplineLinkColor,
                          ),
                        ),
                      ),
                      onTap: () {
                        _openNumber("18002738255");
                      },
                    ),
                    // Call Spanish
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Comuníquese con la Línea Nacional de Prevención del Suicidio (español): 1-888-628-9454",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: MHColors.helplineLinkColor,
                          ),
                        ),
                      ),
                      onTap: () {
                        _openNumber("18886289454");
                      },
                    ),
                    // Site
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "National Suicide Prevention Lifeline Site",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: MHColors.helplineLinkColor,
                          ),
                        ),
                      ),
                      onTap: () {
                        _openLink("NSPL", "https://suicidepreventionlifeline.org/");
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
                        child: Text(
                          "Call The Trevor Project: 1-866-488-7386",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: MHColors.helplineLinkColor,
                          ),
                        ),
                      ),
                      onTap: () {
                        _openNumber("18664887386");
                      },
                    ),
                    // Text
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Text The Trevor Project (START to 678-678)",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: MHColors.helplineLinkColor,
                          ),
                        ),
                      ),
                      onTap: () {
                        _textNumber("678678", "START");
                      },
                    ),
                    // Site
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "The Trevor Project's Site",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: MHColors.helplineLinkColor,
                          ),
                        ),
                      ),
                      onTap: () {
                        _openLink("The Trevor Project", "https://www.thetrevorproject.org/");
                      },
                    ),
                  ],
                ),
                // 911 & 211
                HelplineItem(
                  text: "Official Services",
                  children: [
                    // Call
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Call Emergency Services: 911",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: MHColors.helplineLinkColor,
                          ),
                        ),
                      ),
                      onTap: () {
                        _openNumber("911");
                      },
                    ),
                    // Site
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Call the Local Resource Line: 211",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: MHColors.helplineLinkColor,
                          ),
                        ),
                      ),
                      onTap: () {
                        _openNumber("211");
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
      textColor: MHColors.helplineTextColor,
      title: Text(widget.text),
      children: widget.children ?? const <Widget>[],
    );
  }
}
