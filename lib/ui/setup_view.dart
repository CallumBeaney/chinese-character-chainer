import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

// This pops up when the user first opens the app.

class PopupPage extends StatelessWidget {
  final bool error;

  const PopupPage({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new WillPopScope(
      onWillPop: () async => false, //
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // hide 'back' button
          title: const Text('First-Time Setup'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (error) ...[
                Padding(
                  padding: const EdgeInsets.all(60),
                  child: Text.rich(
                    TextSpan(
                      text:
                          "ERROR: unable to download language models. This may be due to a connectivity issue. Please try again later. To review the source code or report an issue, visit the ",
                      style: const TextStyle(fontSize: 18),
                      children: [
                        TextSpan(
                          text: "Github repository",
                          style: const TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            color: Color.fromARGB(255, 173, 30, 30),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Uri url = Uri.parse("https://github.com/CallumBeaney/rensou-kanji-hinge-flutter");
                              launchUrl(url);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const ExitButton(),
              ] else ...[
                const Padding(
                  padding: EdgeInsets.all(60),
                  child: Text(
                    "Downloading language models. This may take several seconds to a minute. Once downloaded, this app will thereafter operate fully-offline.",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const CircularProgressIndicator(),
              ],
              //
            ],
          ),
        ),
      ),
    );
  }
}

class ExitButton extends StatelessWidget {
  const ExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 50,
      color: const Color.fromARGB(255, 0, 0, 0),
      margin: const EdgeInsets.all(1.0),
      child: TextButton(
        child: const Text(
          "Exit",
          style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 209, 209, 209)),
        ),
        onPressed: () {
          // SystemNavigator.pop(); // doesn't work.
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
      ),
    );
  }
}
