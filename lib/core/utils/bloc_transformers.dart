import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) {
    return events.debounce(duration).asyncExpand(mapper);
  };
}


/*Because later we may need debounce in:

search
filters
chat typing
notifications
API throttling*/
