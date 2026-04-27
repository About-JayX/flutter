import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:mobisen_app/util/log.dart';
import 'package:mobisen_app/util/theme_helper.dart';
import 'package:path_provider/path_provider.dart';

class AvatarCropPage extends StatefulWidget {
  final String imagePath;

  const AvatarCropPage({super.key, required this.imagePath});

  @override
  State<AvatarCropPage> createState() => _AvatarCropPageState();
}

class _AvatarCropPageState extends State<AvatarCropPage> {
  final GlobalKey<ExtendedImageEditorState> _editorKey = GlobalKey();
  bool _isProcessing = false;

  Future<void> _cropAndSave() async {
    // 防止重复点击
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final state = _editorKey.currentState;
      if (state == null) {
        _showError('Editor state not available');
        return;
      }

      final cropRect = state.getCropRect();
      if (cropRect == null) {
        _showError('Please select a crop area');
        return;
      }

      // 验证 cropRect 有效性
      if (cropRect.width <= 0 || cropRect.height <= 0) {
        _showError('Invalid crop area');
        return;
      }

      final Uint8List rawData = state.rawImageData;
      if (rawData.isEmpty) {
        _showError('Image data is empty');
        return;
      }

      final editAction = state.editAction;

      // 解码图片
      img.Image? src;
      try {
        src = img.decodeImage(rawData);
      } catch (e) {
        LogE('AvatarCropPage: decodeImage error: $e');
        _showError('Failed to decode image, please try another photo');
        return;
      }

      if (src == null) {
        _showError('Unsupported image format');
        return;
      }

      // 处理方向
      try {
        src = img.bakeOrientation(src);
      } catch (e) {
        LogE('AvatarCropPage: bakeOrientation error: $e');
        // 继续处理，方向问题不致命
      }

      // 应用旋转
      if (editAction != null && editAction.hasRotateDegrees) {
        try {
          src = img.copyRotate(src!, angle: editAction.rotateDegrees);
        } catch (e) {
          LogE('AvatarCropPage: rotate error: $e');
          _showError('Failed to rotate image');
          return;
        }
      }

      // 应用翻转
      if (editAction != null && editAction.flipY) {
        try {
          src = img.flipHorizontal(src!);
        } catch (e) {
          LogE('AvatarCropPage: flip error: $e');
          _showError('Failed to flip image');
          return;
        }
      }

      // 验证裁剪区域在图片范围内
      final srcWidth = src!.width;
      final srcHeight = src.height;

      final safeLeft = cropRect.left.toInt().clamp(0, srcWidth - 1);
      final safeTop = cropRect.top.toInt().clamp(0, srcHeight - 1);
      final safeRight = (cropRect.left + cropRect.width)
          .toInt()
          .clamp(safeLeft + 1, srcWidth);
      final safeBottom = (cropRect.top + cropRect.height)
          .toInt()
          .clamp(safeTop + 1, srcHeight);

      final safeWidth = safeRight - safeLeft;
      final safeHeight = safeBottom - safeTop;

      if (safeWidth <= 0 || safeHeight <= 0) {
        _showError('Invalid crop dimensions');
        return;
      }

      // 裁剪
      img.Image cropped;
      try {
        cropped = img.copyCrop(
          src!,
          x: safeLeft,
          y: safeTop,
          width: safeWidth,
          height: safeHeight,
        );
      } catch (e) {
        LogE('AvatarCropPage: copyCrop error: $e');
        _showError('Failed to crop image');
        return;
      }

      // 限制输出图片尺寸（防止内存溢出）
      const maxOutputSize = 1024;
      img.Image finalImage = cropped;
      if (cropped.width > maxOutputSize || cropped.height > maxOutputSize) {
        try {
          final ratio = cropped.width / cropped.height;
          int newWidth, newHeight;
          if (ratio > 1) {
            newWidth = maxOutputSize;
            newHeight = (maxOutputSize / ratio).round();
          } else {
            newHeight = maxOutputSize;
            newWidth = (maxOutputSize * ratio).round();
          }
          finalImage =
              img.copyResize(cropped, width: newWidth, height: newHeight);
        } catch (e) {
          LogE('AvatarCropPage: resize error: $e');
          // 使用原图继续
          finalImage = cropped;
        }
      }

      // 编码为 JPG
      List<int> jpgData;
      try {
        jpgData = img.encodeJpg(finalImage, quality: 85);
      } catch (e) {
        LogE('AvatarCropPage: encodeJpg error: $e');
        _showError('Failed to encode image');
        return;
      }

      // 写入临时文件
      File file;
      try {
        final tempDir = await getTemporaryDirectory();
        final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
        file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(jpgData);
      } catch (e) {
        LogE('AvatarCropPage: write file error: $e');
        _showError('Failed to save image');
        return;
      }

      // 成功，返回路径
      if (mounted) {
        Navigator.of(context).pop(file.path);
      }
    } catch (e, stackTrace) {
      LogE('AvatarCropPage: unexpected error: $e\n$stackTrace');
      _showError('An unexpected error occurred, please try again');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isProcessing ? null : _cropAndSave,
            child: _isProcessing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: ThemeHelper.primaryColor,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: ThemeHelper.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ExtendedImage.file(
                  File(widget.imagePath),
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.editor,
                  extendedImageEditorKey: _editorKey,
                  cacheRawData: true,
                  initEditorConfigHandler: (state) {
                    return EditorConfig(
                      maxScale: 8.0,
                      cropRectPadding: const EdgeInsets.all(20.0),
                      hitTestSize: 20.0,
                      cropAspectRatio: CropAspectRatios.ratio1_1,
                      cornerColor: ThemeHelper.primaryColor,
                      lineColor: Colors.white,
                    );
                  },
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.rotate_left, color: Colors.white),
                        onPressed: _isProcessing
                            ? null
                            : () {
                                _editorKey.currentState?.rotate(degree: -90);
                              },
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        icon:
                            const Icon(Icons.rotate_right, color: Colors.white),
                        onPressed: _isProcessing
                            ? null
                            : () {
                                _editorKey.currentState?.rotate();
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: ThemeHelper.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
