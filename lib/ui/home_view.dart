import 'package:flutter/material.dart';
import 'package:rensou_flutter/ui/jp_ink_view.dart';
import 'package:rensou_flutter/ui/zh_trad_ink_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Home Page'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
              child: const Text(
                '漢字連鎖',
                style: TextStyle(
                  fontSize: 70,
                  shadows: [
                    Shadow(
                      blurRadius: 5,
                      color: Colors.grey,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      width: 120,
                      height: 60,
                      color: const Color.fromARGB(255, 108, 108, 108),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const DigitalInkView()));
                          },
                          child: const Text(
                            "日本語",
                            style: TextStyle(color: Color.fromARGB(255, 221, 221, 221), fontSize: 26, height: 1.2),
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      width: 120,
                      height: 60,
                      color: const Color.fromARGB(255, 108, 108, 108),
                      child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "简体字",
                            style: TextStyle(color: Color.fromARGB(255, 221, 221, 221), fontSize: 26, height: 1.2),
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      width: 120,
                      height: 60,
                      color: const Color.fromARGB(255, 108, 108, 108),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ZhTradInkView()));
                          },
                          child: const Text(
                            "繁體字",
                            style: TextStyle(color: Color.fromARGB(255, 221, 221, 221), fontSize: 26, height: 1.2),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.25), // add some padding below the buttons
          ],
        ),
      ),
    );
  }
}

// Navigator.push(context, MaterialPageRoute(builder: (context) => KanjiInfoView(kanji: kanji)));
