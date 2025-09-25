import 'package:flutter/material.dart';
import 'package:safetravel_app/features/auth/presentation/screens/registration_complete_screen.dart';
import 'package:safetravel_app/features/auth/presentation/widgets/stepper_progress.dart';
import 'package:safetravel_app/features/auth/presentation/widgets/step_personal.dart';
import 'package:safetravel_app/features/auth/presentation/widgets/step_travel.dart';
import 'package:safetravel_app/features/auth/presentation/widgets/step_emergency.dart';
import 'package:safetravel_app/features/auth/presentation/widgets/step_health.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();
  bool _privacyConsentGiven = false;

  // Validation states for each step
  List<bool> _stepValidations = [false, false, false, false];

  // The 'const' keyword has been removed from 'StepPersonal()' to fix the error.
  late final List<Widget> _steps;

  @override
  void initState() {
    super.initState();
    _steps = [
      StepPersonal(
        onValidationChanged: (isValid) => _updateStepValidation(0, isValid),
      ),
      StepTravel(
        onValidationChanged: (isValid) => _updateStepValidation(1, isValid),
      ),
      StepEmergency(
        onValidationChanged: (isValid) => _updateStepValidation(2, isValid),
      ),
      StepHealth(
        onConsentChanged: _onPrivacyConsentChanged,
        onValidationChanged: (isValid) => _updateStepValidation(3, isValid),
      ),
    ];
  }

  void _updateStepValidation(int stepIndex, bool isValid) {
    setState(() {
      _stepValidations[stepIndex] = isValid;
    });
  }

  bool _currentStepIsValid() {
    return _stepValidations[_currentStep];
  }

  void _onPrivacyConsentChanged(bool consent) {
    setState(() {
      _privacyConsentGiven = consent;
    });
  }

  void _nextStep() {
    // Check if current step is valid before proceeding
    if (!_stepValidations[_currentStep]) {
      _showValidationRequiredDialog();
      return;
    }

    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Check privacy consent before completing registration
      if (!_privacyConsentGiven) {
        _showPrivacyRequiredDialog();
        return;
      }

      // Navigate to completion screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RegistrationCompleteScreen()),
      );
    }
  }

  void _showValidationRequiredDialog() {
    String stepName;
    String message;

    switch (_currentStep) {
      case 0:
        stepName = 'Personal Information';
        message =
            'Please fill in all required fields: Full Name, Date of Birth, Nationality, and Gender.';
        break;
      case 1:
        stepName = 'Travel Information';
        message =
            'Please provide at least one identity document (Passport Number or Aadhaar Number) and select your preferred language.';
        break;
      case 2:
        stepName = 'Emergency Contacts';
        message =
            'Please provide at least one complete emergency contact with Name, Relationship, and Phone Number.';
        break;
      case 3:
        stepName = 'Health & Privacy';
        message =
            'Please accept the privacy consent to complete your registration.';
        break;
      default:
        stepName = 'Current Step';
        message = 'Please fill in all required fields to continue.';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$stepName Required'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Privacy Consent Required'),
          content: const Text(
            'You must consent to location tracking for safety purposes to complete your registration. This helps our emergency response team locate you if needed.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // You can add your logo here if you have one
                  const Text(
                    'SafeTravel Registration',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your safety profile to access emergency assistance, location tracking, and travel support services.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Takes about 5-10 minutes to complete",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Stepper Progress Indicator
            StepperProgress(currentStep: _currentStep),
            const SizedBox(height: 10),

            // Step Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: _steps,
              ),
            ),

            // Navigation Buttons
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _previousStep,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: Colors.grey.shade300),
                              foregroundColor: Colors.grey.shade700,
                            ),
                            child: const Text('Previous'),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _nextStep,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentStepIsValid()
                                ? null // Use default theme color
                                : Colors.grey[400],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!_currentStepIsValid()) ...[
                                Icon(
                                  Icons.warning_rounded,
                                  size: 18,
                                  color: Colors.grey[700],
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                _currentStep == _steps.length - 1
                                    ? 'Register'
                                    : 'Next',
                              ),
                              if (_currentStepIsValid()) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "All data is encrypted and stored securely.",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
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
