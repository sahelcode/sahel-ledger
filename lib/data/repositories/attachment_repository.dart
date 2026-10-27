import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../domain/access/access.dart';
import '../db/database.dart';
import 'audit_log.dart';

/// Receipt photos and documents, stored privately in the app directory.
///
/// Attachments stay on the device; cloud upload is not implemented yet
/// (see docs/ARCHITECTURE.md). Each file is content-addressed by SHA-256.
class AttachmentRepository {
  AttachmentRepository(
    this.db, {
    required this.actor,
    required this.storageDir,
  });

  final AppDatabase db;
  final ActorContext actor;
  final Directory storageDir;

  static const maxBytes = 10 * 1024 * 1024;

  Future<AttachmentRow> add(
    String txId,
    File source, {
    String? mimeType,
  }) async {
    actor.require(Permission.writeTransactions);
    final bytes = await source.readAsBytes();
    if (bytes.length > maxBytes) throw ArgumentError('attachment_too_large');
    final hash = sha256.convert(bytes).toString();
    final id = const Uuid().v4();
    final ext = p.extension(source.path);
    await storageDir.create(recursive: true);
    final dest = File(p.join(storageDir.path, '$hash$ext'));
    if (!await dest.exists()) await dest.writeAsBytes(bytes, flush: true);
    final row = AttachmentsCompanion.insert(
      id: id,
      txId: txId,
      fileName: p.basename(source.path),
      localPath: dest.path,
      mimeType: Value(mimeType),
      sizeBytes: bytes.length,
      sha256: hash,
      createdAt: DateTime.now(),
    );
    await db.transaction(() async {
      await db.into(db.attachments).insert(row);
      await AuditLog(db).append(
        actorId: actor.actorId,
        entityType: 'tx',
        entityId: txId,
        action: 'attachment_added',
        details: {'sha256': hash, 'name': p.basename(source.path)},
      );
    });
    return (await (db.select(
      db.attachments,
    )..where((a) => a.id.equals(id))).getSingle());
  }

  Stream<List<AttachmentRow>> watchFor(String txId) =>
      (db.select(db.attachments)..where((a) => a.txId.equals(txId))).watch();
}
