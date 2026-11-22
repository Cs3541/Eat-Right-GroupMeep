import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../presenters/auth_presenter.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'nutrition_goals_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthPresenter _presenter = AuthPresenter();

  // Available profile pictures (more can be added)
  final List<String> _avatarPaths = [
    'assets/avatars/apple.png',
    'assets/avatars/blueberry.png',
    'assets/avatars/strawberry.png',
    'assets/avatars/burger.png',
    'assets/avatars/bowl.png',
    'assets/avatars/icecream.png',
  ];

  String? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
  }

 
  Future<void> _loadProfilePicture() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      final snapshot = await FirebaseDatabase.instance
          .ref('profile_pictures/${user.uid}')
          .get();

      if (snapshot.exists && mounted) {
        setState(() {
          _selectedAvatar = snapshot.value as String?;
        });
      }
    } catch (e) {
      debugPrint('Error loading profile picture: $e');
    }
  }

  
  Future<void> _selectAvatar(
    BuildContext dialogContext,
    String avatarPath,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      await FirebaseDatabase.instance
          .ref('profile_pictures/${user.uid}')
          .set(avatarPath);

      if (!mounted) return;

      setState(() {
        _selectedAvatar = avatarPath;
      });

      Navigator.pop(dialogContext);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile picture updated!'),
        ),
      );
    } catch (e) {
      debugPrint('Error saving profile picture: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not update profile picture.'),
        ),
      );
    }
  }

  void _showAvatarDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.lightGreen,
          title: const Text(
            'Select New Profile Picture',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBrown,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: _avatarPaths.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemBuilder: (context, index) {
                final avatar = _avatarPaths[index];
                final isSelected = avatar == _selectedAvatar;

                return InkWell(
                  onTap: () => _selectAvatar(
                    dialogContext,
                    avatar,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.darkGreen
                            : AppTheme.originalLightGreen,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: CircleAvatar(
                      backgroundColor:
                          AppTheme.originalLightGreen,
                      backgroundImage: AssetImage(avatar),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.darkGreen,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Logout
  void _logout(BuildContext context) async {
    await _presenter.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (_) => false,
    );
  }

  
  Widget _buildSectionTitle(
    String title,
    IconData icon, {
    Color iconColor = AppTheme.darkGreen,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 23,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkBrown,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final email =
        _presenter.getCurrentUserEmail() ?? 'Unknown user';

    return Scaffold(
      backgroundColor: AppTheme.lightGreen,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.lightGreen,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 22,
              ),
              decoration: BoxDecoration(
                color: AppTheme.darkGreen,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.mediumGreen,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.eco,
                    color: AppTheme.originalLightGreen,
                    size: 32,
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: AppTheme.lightGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.mutedRed,
                        width: 2.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: AppTheme.mutedRed,
                      size: 27,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.darkBrown,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.darkBrown
                              .withValues(alpha: 0.15),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor:
                          AppTheme.originalLightGreen,
                      backgroundImage: _selectedAvatar != null
                          ? AssetImage(_selectedAvatar!)
                          : null,
                      child: _selectedAvatar == null
                          ? const Icon(
                              Icons.person,
                              size: 55,
                              color: AppTheme.darkGreen,
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextButton.icon(
                    onPressed: _showAvatarDialog,
                    icon: const Icon(
                      Icons.edit,
                      size: 16,
                    ),
                    label: const Text(
                      'Change Profile Picture',
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.mutedRed,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBrown,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.darkBrown
                          .withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            
            _buildSectionTitle(
              'Account Information',
              Icons.person_outline,
              iconColor: AppTheme.mutedRed,
            ),

            const SizedBox(height: 12),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(
                  color: AppTheme.mediumGreen,
                  width: 3,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppTheme.lightGreen,
                      child: Icon(
                        Icons.email_outlined,
                        color: AppTheme.mutedRed,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email Address',
                            style: TextStyle(
                              color: AppTheme.darkBrown
                                  .withValues(alpha: 0.65),
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            email,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppTheme.darkBrown,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            
            _buildSectionTitle(
              'Nutrition Goals',
              Icons.track_changes,
              iconColor: AppTheme.darkBrown,
            ),

            const SizedBox(height: 12),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(
                  color: AppTheme.mediumGreen,
                  width: 3,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personalize Your Nutrition',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkBrown,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Set daily nutrition goals for calories, '
                      'protein, carbohydrates, and fat. '
                      'Track your progress toward your goals!',
                      style: TextStyle(
                        color: AppTheme.darkBrown
                            .withValues(alpha: 0.7),
                        height: 1.5,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const NutritionGoalsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                        ),
                        label: const Text(
                          'Set Nutrition Goals',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.mutedRed,
                  side: const BorderSide(
                    color: AppTheme.mutedRed,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}