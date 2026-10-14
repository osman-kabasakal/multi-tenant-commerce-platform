import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';

import '../../remote_data_sources/home/home_data_source.dart';

@lazySingleton
class HomeRepository extends BaseRepository {
  final HomeDataSource _dataSource;

  HomeRepository(this._dataSource, super.decorator, super.eventBus);
}
