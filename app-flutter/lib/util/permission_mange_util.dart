import 'dart:io';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobisen_app/util/log.dart';
// import 'dialog_util.dart';

/// Title: Permissions
/// Function: Permission detection and handling
/// Content:
/// -----

enum SystemServiceType { location }

enum SystemServiceStatus { open, close, none }

enum PermissionType { photos, storage, camera, location, notification }

bool permissionDeniedConfirm = false;
bool permissionModalOpen = false;

class PermissionMangeUtil {
  // static const permissionTips={
  //   'location':'Location permission is not enabled, please enable it in settings'
  // };

  /// deal Permissions
  /// d - SYSTEM
  // static dealSystemServiceType(
  //     PermissionType name, SystemServiceStatus status) {
  //   switch (name) {
  //     case PermissionType.location:
  //       {
  //         String permissionName = Platform.isIOS
  //             ? 'System Location Service or GPS'
  //             : 'System Location Service or GPS';
  //         switch (status) {
  //           case SystemServiceStatus.open:
  //             return '$permissionName is enabled';
  //
  //           default:
  //             return '$permissionName is not enabled, please enable it';
  //         }
  //       }
  //
  //     default:
  //       return 'Unknown error!';
  //   }
  // }

  /// d - APP
  static _dealPermissionsType(PermissionType name, PermissionStatus status) {
    switch (name) {
      case PermissionType.notification:
        {
          String permissionName = 'Notification';
          switch (status) {
            case PermissionStatus.granted:
              return '$permissionName permission is enabled';

            default:
              return '$permissionName permission is not enabled, please enable it in settings';
          }
        }
      case PermissionType.photos:
        {
          String permissionName =
              Platform.isIOS ? 'Album' : 'Files and Documents';
          switch (status) {
            case PermissionStatus.granted:
              return '$permissionName permission is enabled';

            default:
              return '$permissionName permission is not enabled, please enable it in settings';
          }
        }

      case PermissionType.camera:
        {
          String permissionName = Platform.isIOS ? 'Camera' : 'Camera';
          switch (status) {
            case PermissionStatus.granted:
              return '$permissionName permission is enabled';

            default:
              return '$permissionName permission is not enabled, please enable it in settings';
          }
        }

      case PermissionType.location:
        {
          String permissionName = Platform.isIOS ? 'Location' : 'Location';
          switch (status) {
            case PermissionStatus.granted:
              return '$permissionName permission is enabled';

            default:
              return '$permissionName permission is not enabled, please enable it in settings';
          }
        }

      default:
        return 'Unknown error!';
    }
  }

  /// Check necessary permissions
  static Future<PermissionStatus> checkPermissionStatus(
      PermissionType name) async {
    if (Platform.isAndroid) {
      switch (name) {
        case PermissionType.notification:
          return await Permission.notification.status;
        case PermissionType.photos:
          return await Permission.storage.status;
        case PermissionType.camera:
          return await Permission.camera.status;
        case PermissionType.location:
          return await Permission.location.status;
        default:
          return PermissionStatus.denied;
      }
    } else if (Platform.isIOS) {
      switch (name) {
        case PermissionType.notification:
          return await Permission.notification.status;
        case PermissionType.photos:
          return await Permission.photos.status;
        case PermissionType.camera:
          return await Permission.camera.status;
        case PermissionType.location:
          return await Permission.location.status;
        default:
          return PermissionStatus.denied;
      }
    } else {
      return PermissionStatus.denied;
    }
  }

  /// Request permissions
  /// c - SYSTEM
  // static Future<SystemServiceStatus?> _requestSystemService(
  //     PermissionType name) async {
  //   if (Platform.isIOS) {
  //     switch (name) {
  //       default:
  //         {
  //           return null;
  //         }
  //     }
  //   } else {
  //     switch (name) {
  //       // case PermissionType.location:
  //       //   {
  //       //     bool open = await LocationServiceCheck.checkLocationIsOpen;
  //       //     if (!open) {
  //       //       return SystemServiceStatus.close;
  //       //     }
  //       //     return null;
  //       //   }
  //       //
  //       default:
  //         {
  //           return null;
  //         }
  //     }
  //   }
  // }

  /// c - APP
  static Future<PermissionStatus?> _requestPermissions(
      PermissionType name) async {
    if (Platform.isIOS) {
      switch (name) {
        case PermissionType.notification:
          {
            return Permission.notification.request();
          }
        case PermissionType.photos:
          {
            return Permission.photos.request();
          }

        case PermissionType.camera:
          {
            return Permission.camera.request();
          }

        case PermissionType.location:
          {
            return Permission.location.request();
          }

        default:
          {
            return null;
          }
      }
    } else {
      switch (name) {
        case PermissionType.notification:
          {
            return Permission.notification.request();
          }
        case PermissionType.photos:
          {
            return Permission.storage.request();
          }

        case PermissionType.camera:
          {
            return Permission.camera.request();
          }

        case PermissionType.location:
          {
            // /// System location service
            // bool open = await LocationServiceCheck.checkLocationIsOpen;
            // if(!open){
            //   return PermissionStatus.denied;
            // }
            /// App location permission
            return Permission.location.request();
          }

        default:
          {
            return null;
          }
      }
    }
  }

  /// Determine if permission status is granted
  static bool _statusIsGranted(PermissionStatus status) {
    if (status == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  /// Jump to permission grant location
  static Future<bool> permissionsHandle(PermissionType name,
      {bool permissionDeniedDeal = false}) async {
    /// System permission handling
    LogD(
        'The API called requires permission, the type of permission is: \n$name');
    // var statusSystemService = await _requestSystemService(name);
    // if (statusSystemService != null &&
    //     statusSystemService == SystemServiceStatus.close) {
    //   if (!permissionModalOpen) {
    //     permissionModalOpen = true;
    //     // DialogUtil.openCenterDialog((bool v) async {
    //     //   if (v == true) {
    //     //     permissionDeniedConfirm = true;
    //     //   }
    //     //   permissionModalOpen = false;
    //     // }, des: dealSystemServiceType(name, statusSystemService));
    //   }
    //   return false;
    // }

    /// APP permission handling
    var statusAppPermissions = await _requestPermissions(name);
    LogD('$name permission authorization status: \n$statusAppPermissions');
    if (statusAppPermissions != null) {
      bool isGranted = _statusIsGranted(statusAppPermissions);
      LogD('$name permission has been granted: $isGranted');
      if (isGranted != true) {
        if (!permissionModalOpen && permissionDeniedDeal) {
          LogD(
              '$name permission denied but request: ${!permissionModalOpen && permissionDeniedDeal}');
          permissionModalOpen = true;
          // DialogUtil.openCenterDialog((bool v) {
          //   if (v == true) {
          //     permissionDeniedConfirm = true;
          //     openAppSettings();
          //   }
          //   permissionModalOpen = false;
          // }, des: _dealPermissionsType(name, statusAppPermissions));
        }
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  static void goToSystemSetting() {
    openAppSettings();
  }
}
