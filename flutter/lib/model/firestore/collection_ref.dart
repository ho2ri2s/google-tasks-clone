import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'firestore.dart';

typedef MakeQuery = Query Function(CollectionReference collectionRef);

class CollectionRef<E extends Entity, D extends Document<E>> {
  CollectionRef({
    @required this.ref,
    @required this.decoder,
    @required this.encoder,
  });

  @protected
  final CollectionReference ref;
  @protected
  final DocumentDecoder<D> decoder;
  @protected
  final EntityEncoder<E> encoder;

  Stream<QuerySnapshot> snapshots(MakeQuery makeQuery) {
    return makeQuery(ref).snapshots();
  }

  Stream<List<D>> documents(MakeQuery makeQuery) {
    return snapshots(makeQuery)
        .map((snap) => snap.documents.map(decoder.decode).toList());
  }

  @protected
  DocumentReference docRefRaw([String id]) => ref.document(id);

  DocumentRef<E, D> docRef([String id]) {
    return DocumentRef<E, D>(
      ref: docRefRaw(id),
      decoder: decoder,
      encoder: encoder,
    );
  }
}
