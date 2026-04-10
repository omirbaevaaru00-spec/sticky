import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../features/home/screens/home_screen.dart';
import 'favorites_notifier.dart';
import 'university_model.dart';

class UniversityFeedCard extends StatelessWidget {
  final University university;
  final VoidCallback onTap;

  const UniversityFeedCard({
    super.key,
    required this.university,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Шапка: лого + название ──────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  // Логотип / аватар
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EEF8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE0DDEF),
                        width: 1,
                      ),
                    ),
                    child: ClipOval(
                      child: university.logoUrl.isNotEmpty
                          ? Image.network(
                              university.logoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _InitialsAvatar(name: university.name),
                            )
                          : _InitialsAvatar(name: university.name),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          university.name,
                          style: const TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: university.type == 'гос'
                                    ? const Color(0xFFE8F5E9)
                                    : const Color(0xFFF3E5F5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                university.type == 'гос'
                                    ? 'Гос'
                                    : 'Частный',
                                style: TextStyle(
                                  color: university.type == 'гос'
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFF6A1B9A),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              university.city,
                              style: const TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Фото вуза ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  university.imageUrl,
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 190,
                      color: const Color(0xFFF0EEF8),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF3B3B8E),
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 190,
                    color: const Color(0xFFF0EEF8),
                    child: const Icon(
                      Icons.school_outlined,
                      color: Color(0xFF3B3B8E),
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),

            // ── Направления (чипы) ───────────────────────
            if (university.directions.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: university.directions.take(3).map((d) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EEF8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        d,
                        style: const TextStyle(
                          color: Color(0xFF3B3B8E),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            // ── Сердечко ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    university.costRange,
                    style: const TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 12,
                    ),
                  ),
                  ValueListenableBuilder<Set<String>>(
                    valueListenable: FavoritesNotifier.instance,
                    builder: (_, favorites, __) {
                      final isFav = favorites.contains(university.id);
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          FavoritesNotifier.instance.toggle(university.id);
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isFav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            key: ValueKey(isFav),
                            color: isFav
                                ? const Color(0xFFE53935)
                                : const Color(0xFFBBBBBB),
                            size: 26,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Аватар с инициалами если нет логотипа
class _InitialsAvatar extends StatelessWidget {
  final String name;
  const _InitialsAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'U';
    return Container(
      color: const Color(0xFF3B3B8E),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}