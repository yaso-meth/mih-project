import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class SimpleCalc extends StatefulWidget {
  const SimpleCalc({super.key});

  @override
  State<SimpleCalc> createState() => _SimpleCalcState();
}

class _SimpleCalcState extends State<SimpleCalc> {
  var userInput = '';
  var answer = '0';

  // Array of button
  final List<String> buttons = [
    'AC',
    '(',
    ')',
    '÷',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    'D',
    '=',
  ];

// function to calculate the input operation
  void equalPressed() {
    String finaluserinput = userInput;
    finaluserinput = finaluserinput.replaceAll('x', '*');
    finaluserinput = finaluserinput.replaceAll('÷', '/');
    print(finaluserinput);

    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    if (eval.toString().length <= 1) {
    } else if (eval
            .toString()
            .substring(eval.toString().length - 2, eval.toString().length) ==
        ".0") {
      answer = eval.toString().substring(0, eval.toString().length - 2);
    } else {
      answer = eval.toString();
    }
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: true,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    // double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    // var padding = MediaQuery.paddingOf(context);
    // double newheight = height - padding.top - padding.bottom;
    // print("width: $width");
    // print("height: $height");
    // print("newheight: $newheight");
    double calcWidth = 500;
    if (MzanziInnovationHub.of(context)!.theme.screenType == "desktop") {
      if (height < 700) {
        calcWidth = 300;
      }
    }
    return MihSingleChildScroll(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Simple Calculator",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
          Divider(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                userInput,
                style: TextStyle(
                  fontSize: 40,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            //color: Colors.white,
            padding: const EdgeInsets.all(15),
            alignment: Alignment.centerRight,
            child: Text(
              answer,
              style: TextStyle(
                  fontSize: 30,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: calcWidth,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // padding: EdgeInsets.only(
                //   left: width / 10,
                //   right: width / 10,
                //   bottom: height / 15,
                //   //top: 20,
                // ),
                // shrinkWrap: true,
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  //mainAxisExtent: 150,
                ),
                itemBuilder: (context, index) {
                  // Clear Button
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: MIHButton(
                        onTap: () {
                          setState(() {
                            userInput = '';
                            answer = '0';
                          });
                        },
                        buttonText: buttons[index],
                        buttonColor: Color.fromRGBO(214, 171, 255, 1),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                      ),
                    );
                  }

                  // ( button
                  else if (index == 1) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: MIHButton(
                        onTap: () {
                          setState(() {
                            userInput += buttons[index];
                          });
                        },
                        buttonText: buttons[index],
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .messageTextColor(),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                      ),
                    );
                  }
                  // ) Button
                  else if (index == 2) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: MIHButton(
                        onTap: () {
                          setState(() {
                            userInput += buttons[index];
                          });
                        },
                        buttonText: buttons[index],
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .messageTextColor(),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                      ),
                    );
                  }
                  //  +, -, / x buttons
                  else if (index == 3 ||
                      index == 7 ||
                      index == 11 ||
                      index == 15) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: MIHButton(
                        onTap: () {
                          if (answer == "0") {
                            setState(() {
                              userInput += buttons[index];
                            });
                          } else {
                            setState(() {
                              // userInput = answer;
                              // answer = "0";
                              userInput += buttons[index];
                            });
                          }
                          // setState(() {
                          //   userInput += buttons[index];
                          // });
                        },
                        buttonText: buttons[index],
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .messageTextColor(),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                      ),
                    );
                  }

                  // delete Button
                  else if (index == 18) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: MIHButton(
                        onTap: () {
                          setState(() {
                            if (userInput.length == 1) {
                              userInput = '0';
                            } else if (userInput.length > 1) {
                              userInput =
                                  userInput.substring(0, userInput.length - 1);
                            }
                            if (!isNumeric(userInput[userInput.length - 1])) {
                              userInput =
                                  userInput.substring(0, userInput.length - 1);
                            }
                            // userInput =
                            // userInput.substring(0, userInput.length - 1);
                            equalPressed();
                          });
                        },
                        buttonText: buttons[index],
                        buttonColor:
                            MzanziInnovationHub.of(context)!.theme.errorColor(),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                      ),
                    );
                  }
                  // Equal_to Button
                  else if (index == 19) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: MIHButton(
                        onTap: () {
                          setState(() {
                            equalPressed();
                            userInput = answer;
                          });
                        },
                        buttonText: buttons[index],
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .successColor(),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                      ),
                    );
                  }
                  //  other buttons
                  else {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: MIHButton(
                        onTap: () {
                          setState(() {
                            userInput += buttons[index];
                            equalPressed();
                          });
                        },
                        buttonText: buttons[index],
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
