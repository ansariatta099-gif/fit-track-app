import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/profile_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/user_avatar_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late String _gender;
  late String _goal;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileProvider>().profile;
    _nameController = TextEditingController(text: profile.name);
    _ageController = TextEditingController(text: profile.age.toString());
    _heightController = TextEditingController(text: profile.heightCm.toInt().toString());
    _weightController = TextEditingController(text: profile.weightKg.toStringAsFixed(1));
    _gender = profile.gender;
    _goal = profile.goal;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final profileProvider = context.read<ProfileProvider>();
    final current = profileProvider.profile;

    final updated = current.copyWith(
      name: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : 'Alex Johnson',
      age: int.tryParse(_ageController.text) ?? current.age,
      heightCm: double.tryParse(_heightController.text) ?? current.heightCm,
      weightKg: double.tryParse(_weightController.text) ?? current.weightKg,
      gender: _gender,
      goal: _goal,
    );

    profileProvider.updateProfile(updated);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: AppColors.neonGreenDark,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    UserAvatarWidget(
                      avatarIndex: profile.avatarIndex,
                      size: 80,
                      onTap: () => UserAvatarWidget.showAvatarPicker(context),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => UserAvatarWidget.showAvatarPicker(context),
                      icon: const Icon(Icons.change_circle_outlined, color: AppColors.neonGreen, size: 18),
                      label: const Text('Change Avatar', style: TextStyle(color: AppColors.neonGreen, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _gender,
                      decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
                      dropdownColor: isDark ? AppColors.darkCard : AppColors.lightCard,
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Height (cm)', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _goal,
                decoration: const InputDecoration(labelText: 'Primary Fitness Goal', border: OutlineInputBorder()),
                dropdownColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                items: ['Muscle Gain', 'Lose Weight', 'Keep Fit', 'Endurance']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _goal = val);
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Save Changes',
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
