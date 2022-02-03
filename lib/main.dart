import 'package:animations_sample/fps_widget.dart';
import 'package:animations_sample/pages/gravity_simulation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'pages/pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animations Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scrollbarTheme: ScrollbarThemeData(isAlwaysShown: true),
      ),
      debugShowCheckedModeBanner: false,
      home: MyFpsWidget(
        child: Dashboard(),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;

  Widget getPage(int index) {
    if (index < pages.length) {
      return pages[index].widget;
    } else {
      return const SizedBox();
    }
  }

  final pages = <AppPage>[
    AppPage('Implicit animations', ImplicitAnimations()),
    AppPage('Explicit animations', ExplicitAnimations()),
    AppPage('Tweens', Tweens()),
    AppPage('TweenAnimationBuilder', TweenPageController()),
    AppPage('Staggered animations', StaggeredAnimations()),
    AppPage('Custom controller', CustomController()),
    AppPage('Spring simulation', PhysicsAnimation()),
    AppPage('Gravity simulation', GravitySimulationWidget()),
    AppPage('Material animations', MaterialAnimationsDemo()),
    AppPage('Funvas', FunvasDemo()),
  ];

  @override
  Widget build(BuildContext context) {
    final drawer = AppDrawer(
      pages: pages,
      selectedIndex: selectedIndex,
      onTap: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
    );

    return Scaffold(
      drawer: drawer,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: <Widget>[
              if (constraints.maxWidth < 800)
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                )
              else
                drawer,
              Expanded(
                child: getPage(selectedIndex),
              )
            ],
          );
        },
      ),
    );
  }
}

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    Key? key,
    required this.onTap,
    required this.pages,
    this.selectedIndex = 0,
  }) : super(key: key);

  final Function(int) onTap;
  final List<AppPage> pages;
  final int selectedIndex;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        controller: scrollController,
        children: <Widget>[
          DrawerHeader(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Animations examples',
                style: theme.textTheme.headline5,
              ),
            ),
          ),
          for (final page in widget.pages)
            ListTile(
              leading: Icon(Icons.chevron_right),
              title: Text(page.title),
              selected: widget.pages.indexOf(page) == widget.selectedIndex,
              onTap: () {
                widget.onTap(widget.pages.indexOf(page));
                if (Scaffold.of(context).isDrawerOpen) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ThinDivider(),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            onTap: () {
              if (Scaffold.of(context).isDrawerOpen) {
                Navigator.of(context).pop();
              }
              showAboutDialog(
                context: context,
                children: [
                  AboutPage(),
                ],
              );
              if (Scaffold.of(context).isDrawerOpen) {
                Navigator.of(context).pop();
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text('Source Code'),
            onTap: () async {
              if (Scaffold.of(context).isDrawerOpen) {
                Navigator.of(context).pop();
              }
              final url = 'https://github.com/orestesgaolin/animations_samples';
              if (await canLaunch(url)) {
                launch(url);
              }
            },
          ),
          ThinDivider(),
          SwitchListTile(
            value: context.watch<FpsState>().show,
            title: Text('Show FPS'),
            onChanged: (_) {
              context.read<FpsState>().toggle();
            },
          ),
        ],
      ),
    );
  }
}

class ThinDivider extends StatelessWidget {
  const ThinDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
    );
  }
}
