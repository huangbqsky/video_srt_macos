import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

import '../repository/zip_repository.dart';

import 'config_view.dart';
import 'help_view.dart';

import 'about_view.dart';
import 'home_view.dart';
import 'video_srt.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _pageIndex = 0;
  bool inited = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  Future<void> init() async{
    // TODO: unzipVideoSrt 会报错？？
    // await ZipRepository.unzipVideoSrt();
    setState(() {
      inited = true;
    });
    return;
  }

  Widget buildMacosWindow(){
    return MacosWindow(
      sidebar: Sidebar(
        minWidth: 200,
        builder: (context, scrollController) => SidebarItems(
          currentIndex: _pageIndex,
          onChanged: (index) {
            setState(() => _pageIndex = index);
          },
          items: const [
            SidebarItem(
              leading: MacosIcon(CupertinoIcons.home),
              label: Text('首页'),
            ),
            SidebarItem(
              leading: MacosIcon(CupertinoIcons.videocam_circle_fill),
              label: Text('字幕'),
            ),
            SidebarItem(
              leading: MacosIcon(CupertinoIcons.settings),
              label: Text('配置'),
            ),
            SidebarItem(
              leading: MacosIcon(CupertinoIcons.helm),
              label: Text('帮助'),
            ),
            SidebarItem(
              leading: MacosIcon(CupertinoIcons.info),
              label: Text('关于'),
            ),
          ],
        ),
      ),
      child: IndexedStack(
        index: _pageIndex,
        children: const [
          HomePage(), // 主页：提取视频中字幕
          VideoSrtPage(), // 字幕：给视频添加字幕
          ConfigView(), // 配置
          HelpView(), // 帮助
          AboutView() // 关于
        ],
      ),
    );
  }


  Widget buildLoadingWidget(){
    return Container(
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          ProgressCircle(
            value: null,
          ),
          Text("正在初始化，第一次初始化会比较慢，请稍后 ..."),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: const [
        PlatformMenu(
          label: 'VideoSrtMacos',
          menus: [
            // PlatformMenuItem(
            //   label: '关于',
            //   onSelected: () async {
            //     final window = await DesktopMultiWindow.createWindow(jsonEncode(
            //       {
            //         'args1': 'About video_srt_macos',
            //         'args2': 500,
            //         'args3': true,
            //       },
            //     ));
            //     debugPrint('$window');
            //     window
            //       ..setFrame(const Offset(0, 0) & const Size(350, 350))
            //       ..center()
            //       ..setTitle('About video_srt_macos')
            //       ..show();
            //   },
            // ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.quit,
            ),
          ],
        ),
      ],
      child: inited ? buildMacosWindow() : buildLoadingWidget(),
    );
  }
}