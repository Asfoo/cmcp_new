import 'package:flutter/material.dart';
import '../theme_utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class MyAppBar extends StatefulWidget {
  var titleName;
  var drawer = false;
  Widget actions;

  MyAppBar({
    this.titleName,
    this.drawer = false,
    this.actions,
  });
  @override
  State<StatefulWidget> createState() {
    return MyAppBarState();
  }
}

class MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 60,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon:
                      widget.drawer ? Icon(Icons.menu) : Icon(Icons.arrow_back),
                  color: t3_white,
                  onPressed: () {
                    widget.drawer
                        ? Scaffold.of(context).openDrawer()
                        : Navigator.maybePop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Center(
                    child: Text(
                      widget.titleName,
                      maxLines: 2,
                      style: boldTextStyle(size: 22, color: t3_white),
                    ),
                  ),
                )
              ],
            ),
            if (widget.actions != null) widget.actions
            // if (widget.profile)
            //   Container(
            //     margin: EdgeInsets.only(right: 10),
            //     child: CircleAvatar(
            //       backgroundImage: CachedNetworkImageProvider(t3_ic_profile),
            //       radius: 16,
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return null;
  }
}
