import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Application made by Dominik Roszkowski'),
        const Gap(16),
        InkWell(
          onTap: () async {
            final url = 'https://roszkowski.dev';
            if (await canLaunch(url)) {
              launch(url);
            }
          },
          child: Text('dominik@roszkowski.dev'),
        ),
        const Gap(16),
        InkWell(
          onTap: () async {
            final url = 'https://twitter.com/OrestesGaolin';
            if (await canLaunch(url)) {
              launch(url);
            }
          },
          child: Text('@OrestesGaolin'),
        ),
      ],
    );
  }
}
