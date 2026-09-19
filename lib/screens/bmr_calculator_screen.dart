import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/fitness_calculators.dart';
import '../providers/profile_provider.dart';
import '../widgets/neon_card.dart';

class BmrCalculatorScreen extends StatefulWidget {
  const BmrCalculatorScreen({super.key});

  @override
  State<BmrCalculatorScreen> createState() => _BmrCalculatorScreenState();
}

class _BmrCalculatorScreenState extends State<BmrCalculatorScreen> {
  late int _age;
  late String _gender;
  late double _heightCm;
  late double _weightKg;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileProvider>().profile;
    _age = profile.age;
    _gender = profile.gender;
    _heightCm = profile.heightCm;
    _weightKg = profile.weightKg;
  }

  @override
  Widget build(BuildContext context) {
    final bmr = FitnessCalculators.calculateBMR(
      age: _age,
      gender: _gender,
      heightCm: _heightCm,
      weightKg: _weightKg,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.textWhite : AppColors.lightTextPrimary;
    final secondaryText = isDark ? AppColors.textGrey : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMR Calculator'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeonCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Age', style: TextStyle(color: secondaryText, fontWeight: FontWeight.w600)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: AppColors.neonGreen),
                          onPressed: () {
                            if (_age > 10) setState(() => _age--);
                          },
                        ),
                        Text('$_age', style: TextStyle(color: primaryText, fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: AppColors.neonGreen),
                          onPressed: () {
                            if (_age < 100) setState(() => _age++);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              NeonCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Gender', style: TextStyle(color: secondaryText, fontWeight: FontWeight.w600)),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _gender,
                        dropdownColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                        style: TextStyle(color: primaryText, fontWeight: FontWeight.bold, fontSize: 16),
                        items: ['Male', 'Female']
                            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _gender = val);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              NeonCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Height', style: TextStyle(color: secondaryText, fontWeight: FontWeight.w600)),
                        Text('${_heightCm.toInt()} cm', style: TextStyle(color: primaryText, fontSize: 18, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    Slider(
                      value: _heightCm,
                      min: 100,
                      max: 220,
                      activeColor: AppColors.neonGreen,
                      onChanged: (val) => setState(() => _heightCm = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              NeonCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Weight', style: TextStyle(color: secondaryText, fontWeight: FontWeight.w600)),
                        Text('${_weightKg.toStringAsFixed(1)} kg', style: TextStyle(color: primaryText, fontSize: 18, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    Slider(
                      value: _weightKg,
                      min: 30,
                      max: 180,
                      activeColor: AppColors.neonGreen,
                      onChanged: (val) => setState(() => _weightKg = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              NeonCard(
                hasNeonBorder: true,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BMR Result',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: secondaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          bmr.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},'),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: AppColors.neonGreen,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'kcal/day',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: secondaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This is the number of calories your body needs at rest.',
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
