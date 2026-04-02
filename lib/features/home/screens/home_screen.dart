import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070C),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            /// Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  const SizedBox(width: 28),
                  const Expanded(
                    child: Center(
                      child: Icon(
                        Icons.push_pin,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notification_add,
                      color: Color(0xFF6F7480),
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Divider(color: Color(0xFF1C2230), height: 1),

            /// Feed
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 10, bottom: 12),
                children: const [
                  UniversityFeedCard(
                    logoPath: 'assets/images/sdu_logo.png',
                    title: 'SDU University',
                    subtitle: 'Ведущий частный некоммерческий вуз',
                    city: 'в Алматы',
                    imagePath: 'assets/images/sdu.jpg',
                  ),
                  SizedBox(height: 6),
                  Divider(color: Color(0xFF1C2230), height: 1),
                  UniversityFeedCard(
                    logoPath: 'assets/images/kbtu_logo.png',
                    title: 'KBTU University',
                    subtitle: 'Лучший Технический университет',
                    city: 'Казахстана',
                    imagePath: 'assets/images/kbtu.jpg',
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

class UniversityFeedCard extends StatelessWidget {
  final String logoPath;
  final String title;
  final String subtitle;
  final String city;
  final String imagePath;

  const UniversityFeedCard({
    super.key,
    required this.logoPath,
    required this.title,
    required this.subtitle,
    required this.city,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: ClipOval(
                  child: Image.asset(
                    logoPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFFD8D8D8),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        city,
                        style: const TextStyle(
                          color: Color(0xFFD8D8D8),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// Main image
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                imagePath,
                width: 342,
                height: 274,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// Favorite icon
          const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.star_border_rounded,
                color: Color(0xFF8A8F99),
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}