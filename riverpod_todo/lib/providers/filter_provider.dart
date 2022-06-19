import 'package:hooks_riverpod/hooks_riverpod.dart';

enum Filter {
  notCompleted,
  completed,
  all
}

final filterProvider = StateProvider<Filter>(
    (ref) => Filter.all
);
