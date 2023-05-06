import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PhoneNb_login_page extends StatefulWidget {
  const PhoneNb_login_page({super.key});

  @override
  State<PhoneNb_login_page> createState() => _PhoneNb_login_pageState();
}

class _PhoneNb_login_pageState extends State<PhoneNb_login_page> {
  @override
  Widget build(BuildContext context) {
    return Form(

      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.call),
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: "Phone",
                // hintStyle: TextStyle(fontSize: 13),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Password",
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                // hintStyle: TextStyle(fontSize: 13),
                // prefixText: "Password",
                prefixIcon: Icon(Icons.key),
                suffixIcon: Icon(Icons.visibility),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
