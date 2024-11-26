// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserChatRoom.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserChatRoomAdapter extends TypeAdapter<UserChatRoom> {
  @override
  final int typeId = 10;

  @override
  UserChatRoom read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserChatRoom(
      (fields[0] as List).cast<ChatMessage>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserChatRoom obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserChatRoomAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
