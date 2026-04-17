import 'package:flutter/material.dart';

class UniversityDetailScreen extends StatefulWidget {
  final String id;

  const UniversityDetailScreen({
    super.key,
    required this.id,
  });

  @override
  State<UniversityDetailScreen> createState() =>
      _UniversityDetailScreenState();
}

class _UniversityDetailScreenState extends State<UniversityDetailScreen> {
  int selectedTab = 0;
  final PageController _pageController = PageController();
  int currentImage = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // top bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 24,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        size: 28,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // image slider
              SizedBox(
                height: 220,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: 4,
                      onPageChanged: (index) {
                        setState(() {
                          currentImage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          width: double.infinity,
                          color: const Color(0xFFEAEAEA),
                          child: const Center(
                            child: Text(
                              'Фото университета',
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    Positioned(
                      top: 12,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${currentImage + 1}/4',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: currentImage == index
                                  ? scheme.primary
                                  : Colors.white70,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // university info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 74,
                      height: 74,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE9B6BE),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'KIMEP University',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF222222),
                              height: 1.25,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Алматы',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7A7A7A),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        _circleActionButton(
                          icon: Icons.favorite_border_rounded,
                        ),
                        const SizedBox(width: 10),
                        _circleActionButton(
                          icon: Icons.chat_bubble_outline_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(child: _buildTab('описание', 0)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTab('специальности', 1)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTab('новости', 2)),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildTabContent(),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF7C4DFF)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: const Color(0xFF444444),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (selectedTab == 0) {
      return Column(
        children: [
          _lightCard(
            child: const Text(
              'KIMEP University — один из ведущих частных университетов Казахстана. Университет предлагает программы по бизнесу, IT, праву, международным отношениям и журналистике.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFF2C2C2C),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _lightCard(
            child: Column(
              children: const [
                _ContactItem(
                  icon: Icons.language_rounded,
                  text: 'kimep.kz',
                ),
                SizedBox(height: 16),
                _ContactItem(
                  icon: Icons.phone_outlined,
                  text: '+7 727 270 42 13',
                ),
                SizedBox(height: 16),
                _ContactItem(
                  icon: Icons.mail_outline_rounded,
                  text: 'info@kimep.kz',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _lightCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Условия поступления',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF222222),
                  ),
                ),
                SizedBox(height: 16),
                _TextItem(text: 'Мин. балл: от 95 баллов ЕНТ'),
                _TextItem(text: 'Дедлайн: до 25 августа'),
                _TextItem(text: 'Языки: Русский, Английский'),
                _TextItem(text: 'Экзамены: Математика, Английский язык'),
                _TextItem(
                  text: 'Гранты и стипендии: Есть внутренние гранты и скидки',
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    Icon(
                      Icons.download_rounded,
                      color: Color(0xFF7C4DFF),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Скачать документы',
                      style: TextStyle(
                        color: Color(0xFF7C4DFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (selectedTab == 1) {
      final programs = [
        'Business Administration',
        'Computer Science',
        'International Relations',
        'Finance',
        'Marketing',
        'Journalism',
      ];

      return Column(
        children: programs
            .map(
              (program) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _lightCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          program,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF2C2C2C),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF7A7A7A),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      );
    }

    return SizedBox(
      height: 240,
      child: Center(
        child: Text(
          'Новостей пока нет',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black.withOpacity(0.45),
          ),
        ),
      ),
    );
  }

  static Widget _circleActionButton({required IconData icon}) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFE2E2E2),
          width: 1.2,
        ),
        color: Colors.white,
      ),
      child: Icon(
        icon,
        color: const Color(0xFF6D6D6D),
        size: 26,
      ),
    );
  }

  Widget _lightCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EDF8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF7A7A7A),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF2C2C2C),
            ),
          ),
        ),
        const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF9B9B9B),
        ),
      ],
    );
  }
}

class _TextItem extends StatelessWidget {
  final String text;

  const _TextItem({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Color(0xFF2C2C2C),
        ),
      ),
    );
  }
}