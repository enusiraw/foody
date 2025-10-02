import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

/// Profile screen - displays user profile and settings
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(isDark),
          const SizedBox(height: 24),
          _buildSection(
            'Account',
            [
              _buildListTile(
                Icons.person_outline,
                'Edit Profile',
                () {},
                isDark,
              ),
              _buildListTile(
                Icons.location_on_outlined,
                'Delivery Addresses',
                () {},
                isDark,
              ),
              _buildListTile(
                Icons.payment_outlined,
                'Payment Methods',
                () {},
                isDark,
              ),
            ],
            isDark,
          ),
          const SizedBox(height: 16),
          _buildSection(
            'Preferences',
            [
              _buildListTile(
                Icons.notifications_outlined,
                'Notifications',
                () {},
                isDark,
              ),
              _buildListTile(
                Icons.dark_mode_outlined,
                'Dark Mode',
                () {},
                isDark,
                trailing: Switch(
                  value: isDark,
                  onChanged: (value) {
                    // Theme toggle would go here
                  },
                  activeColor: AppColors.primary,
                ),
              ),
              _buildListTile(
                Icons.language_outlined,
                'Language',
                () {},
                isDark,
              ),
            ],
            isDark,
          ),
          const SizedBox(height: 16),
          _buildSection(
            'Support',
            [
              _buildListTile(
                Icons.help_outline,
                'Help Center',
                () {},
                isDark,
              ),
              _buildListTile(
                Icons.privacy_tip_outlined,
                'Privacy Policy',
                () {},
                isDark,
              ),
              _buildListTile(
                Icons.description_outlined,
                'Terms of Service',
                () {},
                isDark,
              ),
            ],
            isDark,
          ),
          const SizedBox(height: 24),
          _buildLogoutButton(isDark),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: const Icon(
              Icons.person,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: AppTextStyles.h4.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'john.doe@example.com',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {},
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    List<Widget> items,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: AppTextStyles.label.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title,
    VoidCallback onTap,
    bool isDark, {
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      ),
      trailing: trailing ?? Icon(
        Icons.chevron_right,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: AppColors.error, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: AppColors.error),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: AppTextStyles.buttonLarge.copyWith(
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
