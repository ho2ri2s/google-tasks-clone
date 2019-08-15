import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'firestore.dart';

@immutable
abstract class Document<E extends Entity> {
  const Document(
    this.id,
    this.entity,
  );

  final String id;
  final E entity;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Document &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          entity == other.entity;

  @override
  int get hashCode => id.hashCode ^ entity.hashCode;
}

// ignore: one_member_abstracts
abstract class DocumentDecoder<D extends Document> {
  D decode(DocumentSnapshot snapshot);
}
