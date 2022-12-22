import '../fastter/fastter_bloc.dart';

import '../models/notification.model.dart';

const String _notificationsFragment = '''
    fragment notification on Notification {
        _id
        title
        body
        read
        data
        route
        createdAt
        updatedAt
    }
''';

final FastterBloc<Notification> fastterNotifications =
    FastterBloc<Notification>(
  name: 'notification',
  fragment: _notificationsFragment,
  fromJson: (json) => Notification.fromJson(json),
  toInput: (obj) {
    final json = obj.toJson();
    json.remove('_id');
    json.remove('createdAt');
    json.remove('updatedAt');
    return json;
  },
  filterObject: (notification, filter) => true,
);
