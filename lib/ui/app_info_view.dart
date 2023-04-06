import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rensou_flutter/ui/theme_data.dart';
import 'package:ruby_text/ruby_text.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoView extends StatelessWidget {
  const AppInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Theme(
      data: kanjiLookupTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("アップリ情報"),
          toolbarHeight: 50,
        ),
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
                      'RENSOU ',
                      ruby: '連想',
                    ),
                    RubyTextData(
                      'KANJI ',
                      ruby: '漢字',
                    ),
                    RubyTextData(
                      'HINGE ',
                      ruby: '蝶番',
                    ),
                  ],
                  rubyStyle: TextStyle(
                    height: 0.5,
                    fontSize: 18,
                    letterSpacing: 1,
                  ),
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 17, 35, 17),
              child: Text.rich(
                TextSpan(
                  text: "This app is for practicing hand-writing kanji by chaining them by their shared components:\n\n",
                  children: [
                    const TextSpan(
                      text: "　　虫虹工紅、寸吋囗吐土",
                      style: TextStyle(
                        fontSize: 23,
                      ),
                    ),
                    const TextSpan(
                        text:
                            "\n\nWrite a kanji in the white box. Tap your kanji when it appears in one of the grey boxes to add it to the list. Tap ､ or ｡ to start a new sequence. If you want to know more about a kanji, tap on it!\n\n"),
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
                          " made this based on how he used to furtively practice kanji on a notepad at work.\n\nThis app's dictionary builds on the Electronic Dictionary Research and Development Group's KANJIDIC & KRADFILE databases, and on Shang's Kanji Frequency on Wikipedia spreadsheet. To read more, or to report an issue with dictionary data, consult this app's ",
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

            // Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            // Container(
            //     width: 45,
            //     height: 45,
            //     color: Color.fromARGB(255, 129, 129, 129),
            //     child: TextButton(
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //       child: const Icon(
            //         Icons.arrow_back,
            //         color: Color.fromARGB(255, 221, 221, 221),
            //       ),
            //     )),
          ],
        ))),
      ));
}
