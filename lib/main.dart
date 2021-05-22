import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tip Calculator',
      theme: ThemeData(
        primaryColor: const Color(0xFFB0C5D6),
        primarySwatch: Colors.blue,
        sliderTheme: SliderTheme.of(context).copyWith(
          activeTrackColor: Colors.transparent,
          inactiveTrackColor: Colors.transparent,
          thumbColor: const Color(0xFF8DA2F5),
          thumbShape: const RoundSliderThumbShape(
            enabledThumbRadius: 10,
          ),
          valueIndicatorColor: Colors.transparent,
          overlayColor: Colors.black.withOpacity(.1),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Tip Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final TextEditingController textEditingController;

  double _tipPercentage = 15;
  double _currentTip = 0;
  double _totalTip = 0;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    textEditingController.addListener(() {
      setState(() {
        _calculateTip(
          _tipPercentage,
          textEditingController.value.text.length < 1
              ? 0
              : double.parse(textEditingController.value.text),
        );
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  Future<void> _calculateTip(double percentage, double total) async {
    final totalTipValue = (total / 100) * percentage;
    _currentTip = totalTipValue;
    _totalTip = total + totalTipValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0C3FC),
                  Color(0xFF8DA2F8),
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: const Text(
                  'Tip Calculator',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24,
                        ),
                        child: Row(
                          children: <Widget>[
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Bill',
                                textScaleFactor: 1,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFB0C5D6),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const Spacer(flex: 7),
                            Expanded(
                              flex: 5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: TextField(
                                  maxLines: 1,
                                  cursorColor: const Color(0xFFB0C5D6),
                                  controller: textEditingController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(8),
                                  ],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.6,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: ' Input...',
                                    hintStyle: TextStyle(
                                      color: Colors.white54,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                      top: 6,
                                      bottom: 6,
                                      left: 20,
                                      right: 26,
                                    ),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Color(0xFF6E8FFF),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Tip',
                              textScaleFactor: 1,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFB0C5D6),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '${_tipPercentage.floor()}%',
                                style: const TextStyle(
                                  color: Color(0xFF6E8FFF),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              height: 8,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(15),
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFFE0C3FC),
                                    Color(0xFF8DA2F8),
                                  ],
                                ),
                              ),
                            ),
                            Slider.adaptive(
                              min: 0,
                              max: 100,
                              value: _tipPercentage,
                              onChanged: (v) {
                                setState(() {
                                  _tipPercentage = v;
                                  _calculateTip(
                                    _tipPercentage,
                                    textEditingController.value.text.length < 1
                                        ? 0
                                        : double.parse(
                                            textEditingController.value.text,
                                          ),
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Tip',
                              textScaleFactor: 1,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFB0C5D6),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '\$${_currentTip.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Color(0xFF6E8FFF),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 4,
                        color: Color(0xFF6D8DFC),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Total',
                              textScaleFactor: 1,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFB0C5D6),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '\$${_totalTip.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Color(0xFF6E8FFF),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
