import 'package:drift/drift.dart';

class Players extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get level => integer().withDefault(const Constant(0))();
  IntColumn get hp => integer().withDefault(const Constant(100))();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  IntColumn get credits => integer().withDefault(const Constant(0))();
}