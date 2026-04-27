import 'dart:io';

import 'package:cronet_http/cronet_http.dart';
import 'package:cupertino_http/cupertino_http.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:http_image_provider/http_image_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mobisen_app/gen/assets.gen.dart';

class ImageLoader {
  static Client? _client;

  static Future<void> init() async {
    // for hot reload
    if (_client != null) {
      return;
    }
    try {
      if (Platform.isAndroid) {
        // tricky
        // sometimes the cache path is still locked by the last cronet client
        // so I rename it everytime

        final cachePathParent =
            "${(await getTemporaryDirectory()).absolute.path}/cronet_image_cache";

        final cacheParentDir = Directory(cachePathParent);
        String? lastCachePath;
        if (await cacheParentDir.exists()) {
          final list = cacheParentDir.listSync();
          if (list.length > 1) {
            list.sort(
                (f1, f2) => -f1.absolute.path.compareTo(f2.absolute.path));
            lastCachePath = list[0].absolute.path;
            for (var i = 1; i < list.length; i++) {
              try {
                await Directory(list[i].absolute.path).delete(recursive: true);
              } catch (_) {}
            }
          } else if (list.length == 1) {
            lastCachePath = list[0].absolute.path;
          }
        }

        final cachePathPrefix = "$cachePathParent/";
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        String cacheDirPath;
        if (lastCachePath == null) {
          final cacheDir = Directory("$cachePathPrefix$currentTime");
          await cacheDir.create(recursive: true);
          cacheDirPath = cacheDir.path;
        } else {
          final nextCacheDirPath = "$cachePathPrefix$currentTime";
          await Directory(lastCachePath).rename(nextCacheDirPath);
          cacheDirPath = nextCacheDirPath;
        }

        final engine = CronetEngine.build(
            cacheMode: CacheMode.disk,
            storagePath: cacheDirPath,
            cacheMaxSize: 16 * 1024 * 1024,
            enableHttp2: true,
            enableQuic: true);
        _client = CronetClient.fromCronetEngine(engine, closeEngine: true);
      } else if (Platform.isIOS || Platform.isMacOS) {
        final config = URLSessionConfiguration.ephemeralSessionConfiguration()
          ..cache = URLCache.withCapacity(diskCapacity: 16 * 1024 * 1024);
        _client = CupertinoClient.fromSessionConfiguration(config);
      }
    } catch (_) {}
  }

  static ImageProvider _getImageProvider(String? url) {
    if (_client != null && url != null && url.isNotEmpty) {
      return HttpImageProvider.string(url, client: _client);
    }
    return ExtendedNetworkImageProvider(url ?? "", cache: true);
  }

  static Widget cover({String? url}) {
    return ExtendedImage(
      image: _getImageProvider(url),
      fit: BoxFit.cover,
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      shape: BoxShape.rectangle,
      loadStateChanged: (state) {
        if (state.extendedImageLoadState == LoadState.loading) {
          return Container(
              alignment: Alignment.center,
              color: Colors.white.withOpacity(.06),
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Assets.images.imageLoadbg.image(fit: BoxFit.contain),
              ));
        }
        if (state.extendedImageLoadState == LoadState.failed) {
          // if (state.extendedImageLoadState == LoadState.loading ||
          //     state.extendedImageLoadState == LoadState.failed) {
          return Container(
            color: Colors.transparent,
          );
        }
        return null;
      },
    );
  }

  static Widget avatar({String? url}) {
    return ExtendedImage(
      image: _getImageProvider(url),
      fit: BoxFit.cover,
      shape: BoxShape.circle,
      loadStateChanged: (state) {
        if (state.extendedImageLoadState == LoadState.loading ||
            state.extendedImageLoadState == LoadState.failed) {
          return Assets.images.defaultAvatar.image(fit: BoxFit.cover);
        }
        return null;
      },
    );
  }
}
