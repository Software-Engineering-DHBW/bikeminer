import 'package:bikeminer/backend/api_connector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bikeminer/route.dart' as route;

class NavigationDrawerWidget extends StatefulWidget {
  final APIConnector _api;
  final BuildContext supercontext;
  final AsyncCallback logout;
  const NavigationDrawerWidget(this.supercontext, this.logout, this._api,
      {Key? key})
      : super(key: key);

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = const EdgeInsets.fromLTRB(20, 50, 20, 50);
  String username = "";

  @override
  void initState() {
    setState(() {
      username = widget._api.getusername();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Material(
          color: Theme.of(widget.supercontext).colorScheme.secondary,
          child: ListView(
            padding: padding,
            reverse: false,
            children: <Widget>[
              buildHeader(
                username: widget._api.getusername(),
                onClicked: () {},
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                color: Colors.white70,
                height: 5,
              ),
              buildMenuItem(
                text: "Wallet",
                icon: Icons.account_balance_wallet_rounded,
                onClicked: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, route.walletPage);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (BuildContext context) =>
                  //             const WalletPage()));
                },
              ),
              buildMenuItem(
                text: "Rides",
                icon: Icons.directions_bike,
                onClicked: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, route.ridesPage);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (BuildContext context) =>
                  //             const RidesPage()));
                },
              ),
              buildMenuItem(
                text: "Abmelden",
                icon: Icons.logout,
                onClicked: () {
                  Navigator.pop(context);
                  widget.logout().then((value) {
                    Navigator.pop(widget.supercontext);
                    Navigator.pushNamed(context, route.loginPage);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(
      {required String username, required VoidCallback onClicked}) {
    return InkWell(
      onTap: onClicked,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            username,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }
}



// /// Navigation drawer widget
// class NavigationDrawerWidget extends StatelessWidget {
//   final padding = const EdgeInsets.fromLTRB(20, 50, 20, 50);
//   final APIConnector _api;
//   final BuildContext supercontext;
//   final AsyncCallback logout;

//   const NavigationDrawerWidget(this.supercontext, this.logout, this._api,
//       {Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Drawer(
//         child: Material(
//           color: Theme.of(supercontext).colorScheme.secondary,
//           child: ListView(
//             padding: padding,
//             reverse: false,
//             children: <Widget>[
//               buildHeader(
//                 username: _api.getusername(),
//                 onClicked: () {},
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               const Divider(
//                 color: Colors.white70,
//                 height: 5,
//               ),
//               buildMenuItem(
//                 text: "Wallet",
//                 icon: Icons.account_balance_wallet_rounded,
//                 onClicked: () {
//                   Navigator.pop(context);
//                   Navigator.pushNamed(context, route.walletPage);
//                   // Navigator.push(
//                   //     context,
//                   //     MaterialPageRoute(
//                   //         builder: (BuildContext context) =>
//                   //             const WalletPage()));
//                 },
//               ),
//               buildMenuItem(
//                 text: "Rides",
//                 icon: Icons.directions_bike,
//                 onClicked: () {
//                   Navigator.pop(context);
//                   Navigator.pushNamed(context, route.ridesPage);
//                   // Navigator.push(
//                   //     context,
//                   //     MaterialPageRoute(
//                   //         builder: (BuildContext context) =>
//                   //             const RidesPage()));
//                 },
//               ),
//               buildMenuItem(
//                 text: "Abmelden",
//                 icon: Icons.logout,
//                 onClicked: () {
//                   Navigator.pop(context);
//                   logout().then((value) {
//                     Navigator.pop(supercontext);
//                     Navigator.pushNamed(context, route.loginPage);
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildHeader(
//       {required String username, required VoidCallback onClicked}) {
//     return InkWell(
//       onTap: onClicked,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             username,
//             style: const TextStyle(fontSize: 20, color: Colors.white),
//           )
//         ],
//       ),
//     );
//   }

//   Widget buildMenuItem({
//     required String text,
//     required IconData icon,
//     VoidCallback? onClicked,
//   }) {
//     const color = Colors.white;
//     const hoverColor = Colors.white70;

//     return ListTile(
//       leading: Icon(icon, color: color),
//       title: Text(text, style: const TextStyle(color: color)),
//       hoverColor: hoverColor,
//       onTap: onClicked,
//     );
//   }
// }
