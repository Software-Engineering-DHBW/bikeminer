import 'package:flutter/material.dart';
import 'package:bikeminer/pages/rides.dart';
import 'package:bikeminer/pages/wallet.dart';
import 'package:bikeminer/route.dart' as route;

/// Navigation drawer widget
class NavigationDrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.fromLTRB(20, 50, 20, 50);
  final BuildContext supercontext;
  final VoidCallback logout;

  const NavigationDrawerWidget(this.supercontext, this.logout, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const username = 'Florian-0tt';

    return SafeArea(
      child: Drawer(
        child: Material(
          color: Theme.of(supercontext).colorScheme.secondary,
          child: ListView(
            padding: padding,
            reverse: false,
            children: <Widget>[
              buildHeader(
                username: username,
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const WalletPage()));
                },
              ),
              buildMenuItem(
                text: "Rides",
                icon: Icons.directions_bike,
                onClicked: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const RidesPage()));
                },
              ),
              buildMenuItem(
                text: "Abmelden",
                icon: Icons.logout,
                onClicked: () {
                  Navigator.pop(context);
                  logout();
                  Navigator.pop(supercontext);
                  Navigator.pushNamed(context, route.loginPage);
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
