import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepperProgress extends StatelessWidget {
  final int currentStep;

  const StepperProgress({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> steps = [
      {'icon': 'assets/images/personal_icon.svg', 'label': 'Personal'},
      {'icon': 'assets/images/travel_icon.svg', 'label': 'Travel'},
      {'icon': 'assets/images/emergency_icon.svg', 'label': 'Emergency'},
      {'icon': 'assets/images/health_icon.svg', 'label': 'Health'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          Row(
            children: List.generate(steps.length, (index) {
              bool isCompleted = currentStep > index;
              bool isActive = currentStep == index;

              return Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2,
                            color: index == 0
                                ? Colors.transparent
                                : (isActive || isCompleted
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.shade300),
                          ),
                        ),
                        _buildStepIcon(
                          context,
                          steps[index]['icon']!,
                          isActive,
                          isCompleted,
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: index == steps.length - 1
                                ? Colors.transparent
                                : (isCompleted
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.shade300),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      steps[index]['label']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isActive || isCompleted
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade600,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            'Step ${currentStep + 1} of ${steps.length}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIcon(
    BuildContext context,
    String iconAsset,
    bool isActive,
    bool isCompleted,
  ) {
    final Color activeColor = Theme.of(context).primaryColor;
    final Color inactiveColor = Colors.grey.shade400;

    if (isCompleted) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(shape: BoxShape.circle, color: activeColor),
        child: const Icon(Icons.check, color: Colors.white, size: 24),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? activeColor.withValues(alpha: 0.1)
            : Colors.transparent,
        border: Border.all(
          color: isActive ? activeColor : inactiveColor,
          width: 1.5,
        ),
      ),
      child: SvgPicture.asset(
        iconAsset,
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
          isActive ? activeColor : inactiveColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
