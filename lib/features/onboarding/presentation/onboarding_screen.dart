import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/pill_button.dart';
import '../../../shared/widgets/shadow_card.dart';

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

const _pages = <_OnboardingPageData>[
  _OnboardingPageData(
    icon: Icons.local_parking_rounded,
    title: 'Guaranteed Parking,\nEvery Time',
    body:
        'No circling around, no cash, no stress. Reserve a private spot in '
        'Chișinău in advance and count on it being there.',
  ),
  _OnboardingPageData(
    icon: Icons.qr_code_2_rounded,
    title: 'Pay Straight\nFrom Your Phone',
    body:
        'Get in with a QR code or license-plate access. No tickets, no '
        'barriers, no guard to wave you through.',
  ),
  _OnboardingPageData(
    icon: Icons.apartment_rounded,
    title: 'Turn Empty Lots\nInto Revenue',
    body:
        'List parking at your office, hotel, or residential complex. Full '
        'control over pricing and availability, zero upfront cost.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_page == _pages.length - 1) {
      context.go('/map');
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () => context.go('/map'),
                  child: Text('Skip', style: AppTextStyles.body),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _page = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShadowCard(
                          rotationDegrees: index.isEven ? -2 : 2,
                          padding: const EdgeInsets.all(28),
                          child: Icon(
                            page.icon,
                            size: 64,
                            color: AppColors.accentText,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headline.copyWith(
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.body,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                final active = index == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.accent
                        : AppColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Center(
                child: PillButton(
                  label: isLast ? 'Get Started' : 'Next',
                  icon: isLast ? Icons.arrow_forward_rounded : null,
                  onPressed: _next,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
