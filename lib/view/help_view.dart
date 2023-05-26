import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_srt_macos/constanst.dart';

class HelpView extends StatefulWidget {
  const HelpView({super.key});

  @override
  State<HelpView> createState() => _HelpViewState();
}

class _HelpViewState extends State<HelpView> {

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MacosScaffold(
          toolBar: ToolBar(
            title: const Text('帮助'),
            actions: [
              ToolBarIconButton(
                label: 'Toggle Sidebar',
                icon: const MacosIcon(CupertinoIcons.sidebar_left),
                showLabel: false,
                tooltipMessage: 'Toggle Sidebar',
                onPressed: () {
                  MacosWindowScope.of(context).toggleSidebar();
                },
              )
            ],
          ),
          children: [
            ContentArea(
              builder: (context, scrollController) {
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DefaultTextStyle(
                            style: MacosTheme.of(context).typography.title2,
                            child: const Text("点击以下链接")),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          child: DefaultTextStyle(
                              style: MacosTheme.of(context)
                                  .typography
                                  .title2
                                  .copyWith(
                                    color: Colors.blueAccent,
                                    decoration: TextDecoration.underline,
                                  ),
                              child: const Text(GITHUB)),
                          onTap: () {
                            Uri url = Uri.parse(GITHUB);
                            launchUrl(url);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DefaultTextStyle(
                            style: MacosTheme.of(context).typography.title2,
                            child: const Text("查看更多帮助"))
                      ]),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
