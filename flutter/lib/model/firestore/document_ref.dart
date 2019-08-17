import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_tasks/util/util.dart';
import 'package:meta/meta.dart';

import 'firestore.dart';

@immutable
class DocumentRef<E extends Entity, D extends Document<E>> {
  const DocumentRef({
    @required this.ref,
    @required this.decoder,
    @required this.encoder,
  });

  final DocumentReference ref;
  final DocumentDecoder<D> decoder;
  final EntityEncoder<E> encoder;

  Stream<D> document() {
    return ref.snapshots().map((snapshot) {
      if (!snapshot.exists) {
        logger.warning('$D not found(id: ${ref.documentID})');
        return null;
      }
      return decoder.decode(snapshot);
    });
  }

  Future<D> get() async {
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      logger.warning('$D not found(id: ${ref.documentID})');
      return null;
    }
    return decoder.decode(snapshot);
  }

  /// すでにあるデータに対して
  /// マージと似ているがそのキーの配下のものは置き換わる
  Future<void> update(E entity) {
    return ref.updateData(encoder.encode(entity));
  }

  /// すでにあるデータに対して
  /// マージと似ているがそのキーの配下のものは置き換わる
  Future<void> updateJson(Map<String, dynamic> json) {
    return ref.updateData(json);
  }

  /// 全置き換え
  Future<void> set(E entity) {
    return ref.setData(encoder.encode(entity));
  }

  /// 全置き換え
  Future<void> setJson(Map<String, dynamic> json) {
    return ref.setData(json);
  }

  /// マージ
  Future<void> merge(E entity) {
    return ref.setData(encoder.encode(entity), merge: true);
  }

  /// マージ
  Future<void> mergeJson(Map<String, dynamic> json) {
    return ref.setData(json, merge: true);
  }

  Future<void> delete() {
    return ref.delete();
  }
}
