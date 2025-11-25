import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

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
      borderOn: false,
      innerHorizontalPadding: 10,
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
    if (MzansiInnovationHub.of(context)!.theme.screenType == "desktop") {
      if (height < 700) {
        calcWidth = 300;
      }
    }
    return MihSingleChildScroll(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
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
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                      child: MihButton(
                        onPressed: () {
                          setState(() {
                            userInput = '';
                            answer = '0';
                          });
                        },
                        buttonColor: MihColors.getPurpleColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 50,
                        height: 50,
                        borderRadius: 5,
                        child: Text(
                          buttons[index],
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }

                  // ( button
                  else if (index == 1) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: MihButton(
                        onPressed: () {
                          setState(() {
                            userInput += buttons[index];
                          });
                        },
                        buttonColor: MihColors.getGreyColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 50,
                        height: 50,
                        borderRadius: 5,
                        child: Text(
                          buttons[index],
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }
                  // ) Button
                  else if (index == 2) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: MihButton(
                        onPressed: () {
                          setState(() {
                            userInput += buttons[index];
                          });
                        },
                        buttonColor: MihColors.getGreyColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 50,
                        height: 50,
                        borderRadius: 5,
                        child: Text(
                          buttons[index],
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                      child: MihButton(
                        onPressed: () {
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
                        },
                        buttonColor: MihColors.getGreyColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 50,
                        height: 50,
                        borderRadius: 5,
                        child: Text(
                          buttons[index],
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }

                  // delete Button
                  else if (index == 18) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: MihButton(
                        onPressed: () {
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
                            equalPressed();
                          });
                        },
                        buttonColor: MihColors.getRedColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 50,
                        height: 50,
                        borderRadius: 5,
                        child: Icon(
                          Icons.backspace,
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                    );
                  }
                  // Equal_to Button
                  else if (index == 19) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: MihButton(
                        onPressed: () {
                          setState(() {
                            equalPressed();
                            userInput = answer;
                          });
                        },
                        buttonColor: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 50,
                        height: 50,
                        borderRadius: 5,
                        child: Text(
                          buttons[index],
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }
                  //  other buttons
                  else {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: MihButton(
                        onPressed: () {
                          setState(() {
                            userInput += buttons[index];
                            equalPressed();
                          });
                        },
                        buttonColor: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 50,
                        height: 50,
                        borderRadius: 5,
                        child: Text(
                          buttons[index],
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
