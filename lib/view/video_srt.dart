import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

import '../repository/shell_repository.dart';
import '../utils/path_utils.dart';

import 'custom_dialog_view.dart';

// 给视频添加字幕
class VideoSrtPage extends StatefulWidget {
  const VideoSrtPage({super.key});

  @override
  State<VideoSrtPage> createState() => _VideoSrtPageState();
}

class _VideoSrtPageState extends State<VideoSrtPage> {
  String? selectedFilePath; // 视频文件
  String? selectedSrtFilePath; // 字幕文件
  String? outFilePath; // 带字幕的视频文件
  String cmdRecord = "";
  bool running = false;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MacosScaffold(
          toolBar: ToolBar(
            title: const Text('首页'),
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
                return Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      buildSelectFile(), // 选择视频
                      Container(
                        height: 10,
                      ),
                      buildSelectSrtFile(), // 选择字幕
                      buildCmdRecord(),
                      Container(
                        height: 40,
                      ),
                      buildCommitButton()
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildSelectFile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "视频文件:",
          style: TextStyle(fontSize: 13),
        ),
        Container(
          width: 3,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[300],
          ),
          width: 400,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Text(
            selectedFilePath ?? "请选择视频文件",
            style: TextStyle(
                color:
                selectedFilePath == null ? Colors.grey : Colors.black87,
                fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          width: 3,
        ),
        MacosIconButton(
          icon: const Icon(
            Icons.more_horiz,
            size: 16,
          ),
          backgroundColor: Colors.grey[200],
          onPressed: () async {
            var path = await PathUtils.selectFile();
            if (path != null) {
              setState(() {
                selectedFilePath = path;
              });
            }
          },
          padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
        )
      ],
    );
  }

  // 选择字幕文件
  Widget buildSelectSrtFile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "字幕文件:",
          style: TextStyle(fontSize: 13),
        ),
        Container(
          width: 3,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[300],
          ),
          width: 400,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Text(
            selectedSrtFilePath ?? "请选择字幕文件",
            style: TextStyle(
                color:
                selectedSrtFilePath == null ? Colors.grey : Colors.black87,
                fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          width: 3,
        ),
        MacosIconButton(
          icon: const Icon(
            Icons.more_horiz,
            size: 16,
          ),
          backgroundColor: Colors.grey[200],
          onPressed: () async {
            var path = await PathUtils.selectFile();
            if (path != null) {
              setState(() {
                selectedSrtFilePath = path;
              });
            }
          },
          padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
        )
      ],
    );
  }

  Widget buildCommitButton() {
    return PushButton(
      buttonSize: ButtonSize.large,
      padding: EdgeInsets.symmetric(horizontal: running ? 10 : 25, vertical: 5),
      onPressed: running ? null :() async{

        var path = selectedFilePath;
        if(path == null){
          showSelectFileHintDialog();
          return;
        }

        var srtPath = selectedSrtFilePath;
        if(srtPath == null){
          showSelectFileHintDialog();
          return;
        }

        setState(() {
          running = true;
          cmdRecord = "开始添加字幕，请稍后。。。\n";
        });
        await ShellRepository.runAddSrtForVideo(path, srtPath, (event) {
          setState(() {
            cmdRecord += "$event\n";
          });
          if(event.contains("完成")){
            showFinishHintDialog();
          }
        });
        setState(() {
          running = false;
        });
      },
      child: running ? Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(scale: 0.8, child: ProgressCircle()),
            const SizedBox(width: 5,),
            const Text("字幕添加中...")
          ],),
      ) : const Text("添加字幕"),
    );
  }


  Widget buildCmdRecord(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[200],

      ),
      width: 500,
      constraints: const BoxConstraints(
        minHeight: 200,
      ),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(cmdRecord),
    );
  }

  void showSelectFileHintDialog(){
    showMacosAlertDialog(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.only(left: 200.0),
        child: CustomMacosAlertDialog(
          primaryButton:PushButton(
            buttonSize: ButtonSize.large,
            child: const Text('确定'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Text(
                '提示',
                style: MacosTheme.of(context).typography.title2,
              ),
              const SizedBox(height: 10,),
              Text(
                '请先选择视频文件',
                textAlign: TextAlign.center,
                style: MacosTheme.of(context).typography.headline,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showFinishHintDialog(){
    showMacosAlertDialog(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.only(left: 200.0),
        child: CustomMacosAlertDialog(
          primaryButton:PushButton(
            buttonSize: ButtonSize.large,
            child: const Text('打开文件夹'),
            onPressed: () async{
              var path = selectedFilePath;
              if(path != null){
                ShellRepository.openFileDir(path);
              }
              Navigator.pop(context);
            },
          ),
          secondaryButton: PushButton(
            isSecondary: true,
            buttonSize: ButtonSize.large,
            child: const Text('取消'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Text(
                '提示',
                style: MacosTheme.of(context).typography.title2,
              ),
              const SizedBox(height: 10,),
              Text(
                '恭喜你，提取完成',
                textAlign: TextAlign.center,
                style: MacosTheme.of(context).typography.headline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}