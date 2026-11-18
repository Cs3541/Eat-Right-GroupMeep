import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../presenters/auth_presenter.dart';
import 'login_screen.dart';
import 'nutrition_goals_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthPresenter _presenter = AuthPresenter();

  static const Color primaryPurple = Color(0xFF7956A5);
  static const Color lightPurple = Color(0xFFF2EDF8);

//feel free to add more profile pictures here
  final List<String> _avatarPaths = [
  'assets/avatars/apple.png',
  'assets/avatars/blueberry.png',
  'assets/avatars/strawberry.png',
  'assets/avatars/burger.png',
  'assets/avatars/bowl.png',
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

//profile pic popup
  void _showAvatarDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Select New Profile Picture',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryPurple,
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
                            ? primaryPurple
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: CircleAvatar(
                      backgroundColor: lightPurple,
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
                style: TextStyle(color: primaryPurple),
              ),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    await _presenter.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: primaryPurple, size: 22),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
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
      backgroundColor: const Color(0xFFF8F7FA),

      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: primaryPurple,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: lightPurple,
                    backgroundImage: _selectedAvatar != null
                        ? AssetImage(_selectedAvatar!)
                        : null,
                    child: _selectedAvatar == null
                        ? const Icon(
                            Icons.person,
                            size: 55,
                            color: primaryPurple,
                          )
                        : null,
                  ),

                  const SizedBox(height: 8),

                  TextButton.icon(
                    onPressed: _showAvatarDialog,
                    icon: const Icon(
                      Icons.edit,
                      size: 16,
                    ),
                    label: const Text('Change Profile Picture'),
                    style: TextButton.styleFrom(
                      foregroundColor: primaryPurple,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

        
            _buildSectionTitle(
              'Account Information',
              Icons.person_outline,
            ),

            const SizedBox(height: 12),

            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: lightPurple,
                      child: Icon(
                        Icons.email_outlined,
                        color: primaryPurple,
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
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            email,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
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

            // Nutrition Goals
            _buildSectionTitle(
              'Nutrition Goals',
              Icons.track_changes,
            ),

            const SizedBox(height: 12),

            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
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
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Set daily nutrition targets for calories, '
                      'protein, carbohydrates, fat, and water. '
                      'Track your progress toward your goals!',
                      style: TextStyle(
                        color: Colors.grey[600],
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10),
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
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(
                    color: Colors.redAccent,
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