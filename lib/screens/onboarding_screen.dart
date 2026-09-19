import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/services/storage_service.dart';
import '../widgets/vector_art_painters.dart';
import '../widgets/custom_button.dart';
import 'main_navigation_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_OnboardData> _pages = const [
    _OnboardData(
      title: 'Track Workouts\nAchieve Goals',
      subtitle: 'Track your workouts, monitor your progress and achieve your fitness goals effortlessly.',
    ),
    _OnboardData(
      title: 'Nutrition &\nMacro Fueling',
      subtitle: 'Log your meals, monitor daily calories, water hydration, and stay on top of your macros.',
    ),
    _OnboardData(
      title: 'Smart Analytics &\nBody Calculators',
      subtitle: 'Calculate your BMI, BMR, daily targets and analyze your strength growth charts.',
    ),
  ];

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      context.read<StorageService>().setHasOnboarded(true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;
    final subColor = isDark ? AppColors.textGrey : AppColors.lightTextSecondary;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Expanded(
                flex: 3,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final data = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            data.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: subColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const Expanded(
                flex: 5,
                child: Center(
                  child: NeonLifterArtwork(width: 260, height: 280),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  final isSelected = index == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isSelected ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.neonGreen : AppColors.darkBorder,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: _currentIndex == _pages.length - 1 ? 'Get Started' : 'Next',
                onPressed: _onNext,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardData {
  final String title;
  final String subtitle;
  const _OnboardData({required this.title, required this.subtitle});
}
