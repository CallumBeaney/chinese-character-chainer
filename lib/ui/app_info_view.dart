import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:character_chainer/ui/app_theme_data.dart';
import 'package:ruby_text/ruby_text.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoView extends StatelessWidget {
  const AppInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Theme(
      data: infoViewTheme,
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text("INFO"),
        //   toolbarHeight: 50,
        // ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 40, 10, 5),
                child: RubyText(
                  [
                    RubyTextData(
                      '漢 ',
                      ruby: 'かん',
                    ),
                    RubyTextData(
                      '字 ',
                      ruby: 'ㄗ˙',
                    ),
                    RubyTextData(
                      '連 ',
                      ruby: ' lián',
                    ),
                    RubyTextData(
                      '鎖 ',
                      ruby: 'サ',
                    ),
                  ],
                  rubyStyle: TextStyle(
                    height: 0.5,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                  style: TextStyle(fontSize: 50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 17, 35, 17),
              child: Text.rich(
                TextSpan(
                  text: "This app is for practicing hand-writing Chinese characters by chaining them by their shared components:\n\n",
                  children: [
                    const TextSpan(
                      text: "　　虫虹工紅、寸吋囗吐土",
                      style: TextStyle(
                        fontSize: 23,
                      ),
                    ),
                    const TextSpan(
                        text:
                            "\n\nWrite a Chinese character in the white box. Tap your  character when it appears in one of the grey boxes to add it to the list. Tap ､ or ｡ to start a new sequence. If you want to know more about a character, tap on it!\n\n"),
                    TextSpan(
                      text: "Callum Beaney",
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color.fromARGB(255, 173, 30, 30),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Uri url = Uri.parse("https://callumbeaney.github.io");
                          launchUrl(url);
                        },
                    ),
                    const TextSpan(
                      text:
                          " made this based on how he used to furtively practice Japanese & Mandarin on a notepad at work.\n\nThis app was hand-compiled from several different dictionaries including EDRDG's KANJIDIC, Michael Raine & Jim Breen's KRADFILE, Denisowski's CEDICT, and Shang's Kanji Frequency on Wikipedia spreadsheet. There are likely to be some discrepancies in character information that can only viably be identified through real-world usage.\n\nTo read more, or to report an issue, consult this app's ",
                    ),
                    TextSpan(
                      text: "Github repository",
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color.fromARGB(255, 173, 30, 30),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Uri url = Uri.parse("https://github.com/CallumBeaney/rensou-kanji-hinge-flutter");
                          launchUrl(url);
                        },
                    ),
                    const TextSpan(
                      text: ".",
                    ),
                  ],
                  style: const TextStyle(fontSize: 17),
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 35),
            Container(
              width: 66,
              height: 66,
              color: const Color.fromARGB(255, 108, 108, 108),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Color.fromARGB(255, 221, 221, 221),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ))),
      ));
}
