import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobisen_app/model/block_model.dart';
import 'package:mobisen_app/model/conversation_model.dart';
import 'package:mobisen_app/model/privacy_settings.dart';
import 'package:mobisen_app/net/model/episode.dart';
import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/net/model/reward/task_item.dart';
import 'package:mobisen_app/net/model/reward/task_item_language.dart';
import 'package:mobisen_app/net/model/watch_history.dart';

Map<String, dynamic> _fixMapType(Map<String, dynamic> map) {
  Map<String, dynamic> fixedMap = {};
  for (var entry in map.entries) {
    String key = entry.key;
    dynamic value = entry.value;
    if (value is List) {
      final list = value.toList();
      for (var i = 0; i < list.length; i++) {
        if (list[i] is Map) {
          value[i] = _fixMapType(list[i].cast<String, dynamic>());
        }
      }
    }
    if (value is Map) {
      value = _fixMapType(value.cast<String, dynamic>());
    }
    fixedMap[key] = value;
  }
  return fixedMap;
}

void _writeMap(BinaryWriter writer, Map<String, dynamic> map) {
  writer.writeByte(map.length);
  map.forEach((key, value) {
    writer.writeString(key);
    writer.write(value);
  });
}

Map<String, dynamic> _readMap(BinaryReader reader) {
  int length = reader.readByte();
  Map<String, dynamic> map = {};
  for (int i = 0; i < length; i++) {
    String key = reader.readString();
    dynamic value = reader.read();
    map[key] = value;
  }
  map = _fixMapType(map);
  return map;
}

class ShowAdapter extends TypeAdapter<Show> {
  @override
  int get typeId => 0;

  @override
  Show read(BinaryReader reader) {
    return Show.fromJson(_readMap(reader));
  }

  @override
  void write(BinaryWriter writer, Show obj) {
    _writeMap(writer, obj.toJson());
  }
}

class EpisodeAdapter extends TypeAdapter<Episode> {
  @override
  int get typeId => 1;

  @override
  Episode read(BinaryReader reader) {
    return Episode.fromJson(_readMap(reader));
  }

  @override
  void write(BinaryWriter writer, Episode obj) {
    _writeMap(writer, obj.toJson());
  }
}

class WatchHistoryAdapter extends TypeAdapter<WatchHistory> {
  @override
  int get typeId => 2;

  @override
  WatchHistory read(BinaryReader reader) {
    return WatchHistory.fromJson(_readMap(reader));
  }

  @override
  void write(BinaryWriter writer, WatchHistory obj) {
    _writeMap(writer, obj.toJson());
  }
}

class TaskItemAdapter extends TypeAdapter<TaskItem> {
  @override
  int get typeId => 3;

  @override
  TaskItem read(BinaryReader reader) {
    return TaskItem.fromJson(_readMap(reader));
  }

  @override
  void write(BinaryWriter writer, TaskItem obj) {
    _writeMap(writer, obj.toJson());
  }
}

// class TaskItemLanguageAdapter extends TypeAdapter<TaskItemLanguage> {
//   @override
//   int get typeId => 4;
//
//   @override
//   TaskItemLanguage read(BinaryReader reader) {
//     final json = _readMap(reader);
//     return TaskItemLanguage.fromJson(json);
//   }
//
//   @override
//   void write(BinaryWriter writer, TaskItemLanguage obj) {
//     _writeMap(writer, obj.toJson());
//   }
// }

class PrivacySettingsAdapter extends TypeAdapter<PrivacySettings> {
  @override
  int get typeId => 10; // 使用新的 typeId，避免与现有冲突

  @override
  PrivacySettings read(BinaryReader reader) {
    return PrivacySettings.fromJson(_readMap(reader));
  }

  @override
  void write(BinaryWriter writer, PrivacySettings obj) {
    _writeMap(writer, obj.toJson());
  }
}

class BlockedUserAdapter extends TypeAdapter<BlockedUser> {
  @override
  int get typeId => 20; // 使用新的 typeId，避免与现有冲突

  @override
  BlockedUser read(BinaryReader reader) {
    return BlockedUser.fromJson(_readMap(reader));
  }

  @override
  void write(BinaryWriter writer, BlockedUser obj) {
    _writeMap(writer, obj.toJson());
  }
}

class BlockedKeywordAdapter extends TypeAdapter<BlockedKeyword> {
  @override
  int get typeId => 21;

  @override
  BlockedKeyword read(BinaryReader reader) {
    return BlockedKeyword.fromJson(_readMap(reader));
  }

  @override
  void write(BinaryWriter writer, BlockedKeyword obj) {
    _writeMap(writer, obj.toJson());
  }
}

class ConversationAdapter extends TypeAdapter<Conversation> {
  @override
  int get typeId => 30;

  @override
  Conversation read(BinaryReader reader) {
    return Conversation.fromJson(_readMap(reader));
  }

  @override
  void write(BinaryWriter writer, Conversation obj) {
    _writeMap(writer, obj.toJson());
  }
}
