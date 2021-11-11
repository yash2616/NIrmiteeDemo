import "package:flutter/material.dart";

class MonthHeader extends StatelessWidget {
  const MonthHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: ["M","T","W","T","F","S","S"].map((e){
          return Expanded(
            child: Center(child: Text("$e")),
          );
        }).toList(),
      ),
    );
  }
}
