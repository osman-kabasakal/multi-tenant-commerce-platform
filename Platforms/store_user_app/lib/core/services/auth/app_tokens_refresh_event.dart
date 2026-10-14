import 'package:store_user_app/core/data/events/common_event.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';

import '../../services/auth/auth_service.dart';

class AuthTokensRefreshEvent extends EntityEvent<AuthTokens>
    with CommonEvent<AuthTokens> {
  final AuthTokens? oldTokens;
  AuthTokensRefreshEvent({required super.entity, super.userId, this.oldTokens});
}
