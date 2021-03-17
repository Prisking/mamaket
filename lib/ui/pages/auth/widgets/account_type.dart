import 'package:flutter/material.dart';
import 'package:mamaket/constants/constants.dart';
import 'package:mamaket/ui/pages/auth/controller/auth_controller.dart';
import 'package:provider/provider.dart';

class AccountType extends StatelessWidget {
  final String title;
  final String value;
  const AccountType({
    Key key,
    @required this.title,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    return GestureDetector(
      onTap: () {
        auth.changeGroupValue(value);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
        child: Text(
          title,
          style: TextStyle(
              color: auth.groupValue == value ? Colors.white : kPrimaryColor),
        ),
        decoration: BoxDecoration(
          color: auth.groupValue == value ? kPrimaryColor : Color(0xffEEEEF0),
          borderRadius: value == "buyer"
              ? BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
        ),
      ),
    );
  }
}
