import '../fastter/fastter_bloc.dart';
import '../models/label.model.dart';

const _labelFragment = '''
    fragment label on Label {
        _id
        title
        createdAt
        updatedAt
    }
''';

final FastterBloc<Label> fastterLabels = FastterBloc<Label>(
  name: 'label',
  fragment: _labelFragment,
  fromJson: (json) => Label.fromJson(json),
  toInput: (obj) {
    final json = obj.toJson();
    json.remove('_id');
    json.remove('createdAt');
    json.remove('updatedAt');
    return json;
  },
  filterObject: (label, filter) => true,
);
