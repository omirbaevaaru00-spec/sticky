import 'package:flutter/foundation.dart';

/// Глобальное состояние избранного.
/// Используем ValueNotifier чтобы лента и страница вуза
/// синхронно обновляли сердечко без лишних зависимостей.
class FavoritesNotifier extends ValueNotifier<Set<String>> {
  static final FavoritesNotifier instance = FavoritesNotifier._();
  FavoritesNotifier._() : super({});

  bool isFavorite(String id) => value.contains(id);

  void toggle(String id) {
    final updated = Set<String>.from(value);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    value = updated;
  }
}