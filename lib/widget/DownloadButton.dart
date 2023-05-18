import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

enum DownloadStatus {
  notDownloaded,
  fetchingDownload,
  downloading,
  downloaded,
}

abstract class DownloadController implements ChangeNotifier {
  DownloadStatus get downloadStatus;
  double get progress;
  String get downloadUrl;
  String get downloadName;
  void startDownload();
  void stopDownload();
  void openDownload();
}

/// count 当前下载进度
/// total 下载总长度
typedef DownloadProgressCallBack = Function(int count, int total);

class SimulatedDownloadController extends DownloadController
    with ChangeNotifier {
  SimulatedDownloadController({
    DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
    double progress = 0.0,
    required String downloadUrl,
    required String downloadName,
    required VoidCallback onOpenDownload,
  })  : _downloadStatus = downloadStatus,
        _progress = progress,
        _downloadUrl = downloadUrl,
        _downloadName = downloadName,
        _onOpenDownload = onOpenDownload;

  DownloadStatus _downloadStatus;
  @override
  DownloadStatus get downloadStatus => _downloadStatus;

  double _progress;
  String _downloadUrl;
  String _downloadName;
  @override
  double get progress => _progress;

  @override
  String get downloadUrl => _downloadUrl;
  @override
  String get downloadName => _downloadName;

  final VoidCallback _onOpenDownload;

  bool _isDownloading = false;

  @override
  void startDownload() {
    if (downloadStatus == DownloadStatus.notDownloaded) {
      _doDownload();
    }
  }

  @override
  void stopDownload() {
    if (_isDownloading) {
      _isDownloading = false;
      _downloadStatus = DownloadStatus.notDownloaded;
      _progress = 0.0;
      _downloadUrl = '';
      _downloadName = '';
      notifyListeners();
    }
  }

  @override
  void openDownload() {
    if (downloadStatus == DownloadStatus.downloaded) {
      _onOpenDownload();
    }
  }

  @override
  DownloadStatus getDownloadStatus()  {
    if (prefs.getBool(_downloadName) ?? false) {
      _downloadStatus = DownloadStatus.downloaded;
    }
    return _downloadStatus;
  }

  ///下载文件到本地
  ///urlPath 文件Url
  ///savePath 本地保存位置
  ///downloadProgressCallBack 下载文件回调
  static Future<Response> _downloadFile(String urlPath, String savePath,
      {DownloadProgressCallBack? downloadProgressCallBack}) async {
    Dio dio = Dio();
    return await dio.download(urlPath, savePath,
        onReceiveProgress: downloadProgressCallBack);
  }

  Future<void> _doDownload() async {
    _isDownloading = true;
    _downloadStatus = DownloadStatus.fetchingDownload;
    notifyListeners();
    print(_downloadUrl);
    print(_downloadName);
    if (!_isDownloading) {
      return;
    }

    // Shift to the downloading phase.
    _downloadStatus = DownloadStatus.downloading;
    notifyListeners();
    File file =
        File('${appDocumentsDir.path}/AiTools/$_downloadName/${path.basename(downloadUrl)}');
    if (file.existsSync()) {
      _downloadStatus = DownloadStatus.downloaded;
      notifyListeners();
    } else {
      _downloadFile(_downloadUrl,
          '${appDocumentsDir.path}/AiTools/$_downloadName/${path.basename(downloadUrl)}',
          downloadProgressCallBack: (int count, int total) async {
        _progress = count / total;
        notifyListeners();
        if (_progress == 1) {
          _downloadStatus = DownloadStatus.downloaded;
          _isDownloading = false;
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool(_downloadName, true);
          notifyListeners();
        }
      });
    }

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // If the user chose to cancel the download, stop the simulation.
    // if (!_isDownloading) {
    //   return;
    // }
    //
    // // Shift to the downloading phase.
    // _downloadStatus = DownloadStatus.downloading;
    // notifyListeners();

    // const downloadProgressStops = [0.0, 0.15, 0.45, 0.8, 1.0];
    // for (final stop in downloadProgressStops) {
    //   // Wait a second to simulate varying download speeds.
    //   await Future<void>.delayed(const Duration(seconds: 1));
    //
    //   // If the user chose to cancel the download, stop the simulation.
    //   if (!_isDownloading) {
    //     return;
    //   }
    //
    //   // Update the download progress.
    //   _progress = stop;
    //   notifyListeners();
    // }

    // // Wait a second to simulate a final delay.
    // await Future<void>.delayed(const Duration(seconds: 1));
    //
    // // If the user chose to cancel the download, stop the simulation.
    // if (!_isDownloading) {
    //   return;
    // }
    //
    // // Shift to the downloaded state, completing the simulation.
    // _downloadStatus = DownloadStatus.downloaded;
    // _isDownloading = false;
    // notifyListeners();
  }
}

@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.status,
    this.downloadProgress = 0.0,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
    this.transitionDuration = const Duration(milliseconds: 500),
    this.buttonSt,
    this.buttonEn,
  });

  final DownloadStatus status;
  final double downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;
  final Duration transitionDuration;
  final String? buttonSt;
  final String? buttonEn;
  bool get _isDownloading => status == DownloadStatus.downloading;

  bool get _isFetching => status == DownloadStatus.fetchingDownload;

  bool get _isDownloaded => status == DownloadStatus.downloaded;

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
        onDownload();
        break;
      case DownloadStatus.fetchingDownload:
        // do nothing.
        break;
      case DownloadStatus.downloading:
        onCancel();
        break;
      case DownloadStatus.downloaded:
        onOpen();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        children: [
          ButtonShapeWidget(
            transitionDuration: transitionDuration,
            isDownloaded: _isDownloaded,
            isDownloading: _isDownloading,
            isFetching: _isFetching,
            buttonSt: buttonSt,
            buttonEn: buttonEn,
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              duration: transitionDuration,
              opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
              curve: Curves.ease,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ProgressIndicatorWidget(
                    downloadProgress: downloadProgress,
                    isDownloading: _isDownloading,
                    isFetching: _isFetching,
                  ),
                  if (_isDownloading)
                    const Icon(
                      Icons.stop,
                      size: 14,
                      color: CupertinoColors.activeBlue,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class ButtonShapeWidget extends StatelessWidget {
  const ButtonShapeWidget({
    super.key,
    required this.isDownloading,
    required this.isDownloaded,
    required this.isFetching,
    required this.transitionDuration,
    this.buttonSt,
    this.buttonEn,
  });

  final bool isDownloading;
  final bool isDownloaded;
  final bool isFetching;
  final Duration transitionDuration;
  final String? buttonSt;
  final String? buttonEn;

  @override
  Widget build(BuildContext context) {
    var shape = const ShapeDecoration(
      shape: StadiumBorder(),
      color: CupertinoColors.lightBackgroundGray,
    );

    if (isDownloading || isFetching) {
      shape = ShapeDecoration(
        shape: const CircleBorder(),
        color: Colors.white.withOpacity(0),
      );
    }
    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.ease,
      width: double.infinity,
      decoration: shape,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: AnimatedOpacity(
          duration: transitionDuration,
          opacity: isDownloading || isFetching ? 0.0 : 1.0,
          curve: Curves.ease,
          child: Text(
            isDownloaded ? buttonEn ?? '查看' : buttonSt ?? '下载',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.activeBlue,
                ),
          ),
        ),
      ),
    );
  }
}

@immutable
class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    super.key,
    required this.downloadProgress,
    required this.isDownloading,
    required this.isFetching,
  });

  final double downloadProgress;
  final bool isDownloading;
  final bool isFetching;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: downloadProgress),
        duration: const Duration(milliseconds: 200),
        builder: (context, progress, child) {
          return CircularProgressIndicator(
            backgroundColor: isDownloading
                ? CupertinoColors.lightBackgroundGray
                : Colors.white.withOpacity(0),
            valueColor: AlwaysStoppedAnimation(isFetching
                ? CupertinoColors.lightBackgroundGray
                : CupertinoColors.activeBlue),
            strokeWidth: 2,
            value: isFetching ? null : progress,
          );
        },
      ),
    );
  }
}
