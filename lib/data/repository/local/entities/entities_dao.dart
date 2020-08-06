import 'package:flutterapp/data/repository/local/entities/entities_database.dart';
import 'package:flutterapp/extension/response.dart';
import 'package:moor_flutter/moor_flutter.dart';

@UseDao(tables: [])
class EntitiesDao extends DatabaseAccessor<EntitiesDatabase>
    with _$EntitiesDaoMixin {
  final EntitiesDatabase database;

  EntitiesDao({@required this.database}) : super(database);

  Future<Response> getLocalRepositories

  =>

  select(repo)

      .

  get();

  Future<Response> insertRepositories

  =>

  into(repo)

      .

  insert(task);

  Future<Reponse> deleteRepositories

  =>

  delete(tasks)

      .

  delete(task);
}