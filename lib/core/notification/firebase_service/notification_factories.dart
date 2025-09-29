
import 'package:mishkat_almasabih/core/notification/firebase_service/notification_handler.dart';

class NotificationHandlerFactory {
  static final Map<String, NotificationHandler> onTapHandler = {
    'project_status': ProjectStatus(),
    'order_status': OrderStatus(),
    'credit': AddCredit(),
    'cart': CheckCart(),
    'favorite': CheckFavorite(),
  };
  static NotificationHandler? getHandler(String type) {
    return onTapHandler[type];
  }
}