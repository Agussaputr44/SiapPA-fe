import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:siappa/providers/upload_media_provider.dart';
import 'package:siappa/providers/users_provider.dart';
import 'package:siappa/views/widgets/loading_widget.dart';
import '../../../../helpers/dialog_helper.dart';
import '../../../../helpers/profile_url_helper.dart';
import '../../../../providers/auth_provider.dart';
import '../../../widgets/messages_widget.dart';
import '../../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  bool _isEditing = false;
  bool _isChangingPassword = false;
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    // Load user details when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  // Load user data from provider
  Future<void> _loadUserData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UsersProvider>(context, listen: false);

    print('Loading user data with token: ${authProvider.token}');
    await userProvider.loadUserDetails(authProvider);

    // Update controllers with loaded data
    if (userProvider.user != null) {
      _nameController.text = userProvider.user!.name ?? '';
      _emailController.text = userProvider.user!.email ?? '';
      print(
          'Loaded user: ${userProvider.user!.name}, ${userProvider.user!.email}, ${userProvider.user!.fotoProfile}');
    } else {
      print('No user data loaded');
    }
  }

  // Save updated user data
  Future<void> _saveUserData() async {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final uploadProvider =
        Provider.of<UploadMediaProvider>(context, listen: false);

    uploadProvider.init(authProvider);

    final name = _nameController.text.trim();

    if (name.isEmpty) {
      MessagesWidget.showError(context, "Nama harus diisi.");
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: LoadingWidget(
            isLoading: true,
            child: Container(),
          ),
        ),
      );

      String? fotoUrl = userProvider.user?.fotoProfile;
      print('Initial fotoUrl: $fotoUrl');

      if (_selectedFile != null) {
        final validExtensions = ['jpg', 'jpeg', 'png', 'gif'];
        final fileExtension = _selectedFile!.path.split('.').last.toLowerCase();
        print(
            'Selected file: ${_selectedFile!.path}, extension: $fileExtension');

        if (!validExtensions.contains(fileExtension)) {
          Navigator.pop(context);
          MessagesWidget.showError(context, "Tipe file tidak didukung.");
          return;
        }

        await uploadProvider.upload([_selectedFile!]);
        print('Upload result: ${uploadProvider.uploadedFiles}');

        if (uploadProvider.uploadedFiles.isEmpty) {
          Navigator.pop(context);
          throw Exception('File gagal diupload.');
        }

        fotoUrl = uploadProvider.uploadedFiles.first;
        print('Uploaded fotoUrl: $fotoUrl');
      }

      if (fotoUrl == null) {
        Navigator.pop(context);
        MessagesWidget.showError(context, "URL foto profil tidak valid.");
        return;
      }

      print('Updating profile with name: $name, fotoUrl: $fotoUrl');
      await userProvider.updateUserProfile(
        authProvider,
        name: name,
        fotoProfile: fotoUrl,
      );

      Navigator.pop(context);
      MessagesWidget.showSuccess(context, "Profil berhasil diperbarui.");

      setState(() {
        _isEditing = false;
        _selectedFile = null;
      });

      await _loadUserData();
    } catch (e) {
      Navigator.pop(context);
      MessagesWidget.showError(context, "Gagal memperbarui profil: $e");
      print('Error updating profile: $e');
    }
  }

  // Update password
  Future<void> _updatePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validate inputs
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      MessagesWidget.showError(context, "Semua field password harus diisi.");
      return;
    }

    if (newPassword != confirmPassword) {
      MessagesWidget.showError(
          context, "Password baru dan konfirmasi password tidak cocok.");
      return;
    }

    if (newPassword.length < 6) {
      MessagesWidget.showError(context, "Password baru minimal 6 karakter.");
      return;
    }

    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: LoadingWidget(
            isLoading: true,
            child: Container(),
          ),
        ),
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Update password using AuthProvider
      final success =
          await authProvider.updatePassword(currentPassword, newPassword);

      Navigator.pop(context);

      if (success) {
        // Show success message
        MessagesWidget.showSuccess(context,
            authProvider.successMessage ?? "Password berhasil diperbarui.");

        // Clear password fields and exit changing password mode
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        setState(() {
          _isChangingPassword = false;
        });
      } else {
        // Show error message from provider
        MessagesWidget.showError(context,
            authProvider.errorMessage ?? "Gagal memperbarui password.");
      }
    } catch (e) {
      // Hide loading
      Navigator.pop(context);

      // Show error message
      MessagesWidget.showError(context, "Gagal memperbarui password: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
        final isLoading = context.watch<UsersProvider>().isLoading;
    return LoadingWidget(

      isLoading: isLoading,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(241, 140, 176, 1),
                Color.fromRGBO(248, 187, 208, 1),

              ],
            ),
          ),
          child: SafeArea(
            child: Consumer2<UsersProvider, AuthProvider>(
              builder: (context, userProvider, authProvider, child) {
                // Show loading state
                if (userProvider.isLoading) {
                  return const Center(
                    child: LoadingWidget(
                      isLoading: true,
                      child: SizedBox(),
                    ),
                  );
                }
      
                // Show error state
                if (userProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userProvider.errorMessage!,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadUserData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor:
                                const Color.fromARGB(255, 234, 102, 216),
                          ),
                          child: Text(
                            'Coba Lagi',
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      ],
                    ),
                  );
                }
      
                final user = userProvider.user;
      
                return RefreshIndicator(
                  onRefresh: _loadUserData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Header Section
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back_ios,
                                      color: Colors.white),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Profile',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    _isEditing ? Icons.close : Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = !_isEditing;
                                      if (!_isEditing) {
                                        _selectedFile = null;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
      
                        const SizedBox(height: 20),
      
                        // Profile Avatar with Shadow
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundImage: _selectedFile != null
                                      ? FileImage(_selectedFile!)
                                      : (user?.fotoProfile != null &&
                                              user!.fotoProfile!.isNotEmpty)
                                          ? NetworkImage(
                                              getFotoUrl(user.fotoProfile))
                                          : const AssetImage(
                                                  'assets/icons/ic_profile.png')
                                              as ImageProvider,
                                ),
                              ),
                              if (_isEditing)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 234, 102, 216),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.camera_alt,
                                          color: Colors.white, size: 20),
                                      onPressed: _showImagePicker,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
      
                        const SizedBox(height: 30),
      
                        // Manage Profile Card
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Manage Profile',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
      
                              const SizedBox(height: 24),
      
                              // Name Field
                              _buildInputField(
                                label: 'Name',
                                controller: _nameController,
                                icon: Icons.person_outline,
                                isEditable: _isEditing,
                              ),
      
                              const SizedBox(height: 20),
      
                              // Email Field
                              _buildInputField(
                                label: 'Email',
                                controller: _emailController,
                                icon: Icons.email_outlined,
                                isEditable: false,
                              ),
      
                              const SizedBox(height: 32),
      
                              // Action Buttons
                              if (_isEditing)
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          // Reset controllers to original values
                                          if (user != null) {
                                            _nameController.text =
                                                user.name ?? '';
                                            _emailController.text =
                                                user.email ?? '';
                                          }
                                          setState(() {
                                            _isEditing = false;
                                            _selectedFile = null;
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          side: BorderSide(
                                              color: Colors.grey[300]!),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Batal',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _saveUserData,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 234, 102, 216),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          elevation: 3,
                                        ),
                                        child: Text(
                                          'Simpan',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
      
                        const SizedBox(height: 20),
      
                        // Settings Card
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Settings',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _isChangingPassword
                                          ? Icons.close
                                          : Icons.lock_outline,
                                      color: const Color.fromARGB(
                                          255, 234, 102, 216),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isChangingPassword =
                                            !_isChangingPassword;
                                        if (!_isChangingPassword) {
                                          _currentPasswordController.clear();
                                          _newPasswordController.clear();
                                          _confirmPasswordController.clear();
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              if (!_isChangingPassword) ...[
                                const SizedBox(height: 16),
                                ListTile(
                                  leading: const Icon(Icons.lock_outline,
                                      color: Color.fromARGB(255, 234, 102, 216)),
                                  title: Text(
                                    'Ubah Password',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Klik untuk mengubah password',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios,
                                      size: 16),
                                  onTap: () {
                                    setState(() {
                                      _isChangingPassword = true;
                                    });
                                  },
                                ),
                              ],
                              if (_isChangingPassword) ...[
                                const SizedBox(height: 24),
      
                                // Current Password Field
                                _buildPasswordField(
                                  label: 'Password Saat Ini',
                                  controller: _currentPasswordController,
                                  isVisible: _isCurrentPasswordVisible,
                                  onVisibilityToggle: () {
                                    setState(() {
                                      _isCurrentPasswordVisible =
                                          !_isCurrentPasswordVisible;
                                    });
                                  },
                                ),
      
                                const SizedBox(height: 20),
      
                                // New Password Field
                                _buildPasswordField(
                                  label: 'Password Baru',
                                  controller: _newPasswordController,
                                  isVisible: _isNewPasswordVisible,
                                  onVisibilityToggle: () {
                                    setState(() {
                                      _isNewPasswordVisible =
                                          !_isNewPasswordVisible;
                                    });
                                  },
                                ),
      
                                const SizedBox(height: 20),
      
                                // Confirm Password Field
                                _buildPasswordField(
                                  label: 'Konfirmasi Password Baru',
                                  controller: _confirmPasswordController,
                                  isVisible: _isConfirmPasswordVisible,
                                  onVisibilityToggle: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
      
                                const SizedBox(height: 32),
      
                                // Password Action Buttons
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          _currentPasswordController.clear();
                                          _newPasswordController.clear();
                                          _confirmPasswordController.clear();
                                          setState(() {
                                            _isChangingPassword = false;
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          side: BorderSide(
                                              color: Colors.grey[300]!),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Batal',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _updatePassword,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 234, 102, 216),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          elevation: 3,
                                        ),
                                        child: Text(
                                          'Update Password',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
      
                        const SizedBox(height: 20),
      
                        // Logout Button
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed:() async {
                                  // Tutup dropdown dulu
                                  // Tunggu overlay benar-benar hilang
                                  await Future.delayed(
                                      const Duration(milliseconds: 100));
      
                                  // GUNAKAN CONTEXT PARENT (_parentContext), BUKAN overlayContext!
                                  final shouldLogout =
                                      await showCustomConfirmDialog(
                                    context: context,
                                    title: 'Logout Confirmation',
                                    message: 'Are you sure you want to logout?',
                                    confirmText: 'Logout',
                                    cancelText: 'Cancel',
                                    icon: Icons.logout,
                                    iconColor: Colors.red,
                                  );
                                  if (shouldLogout == true) {
                                    await authProvider.logout();
                                    if (!mounted) return;
                                    Navigator.of(context)
                                        .pushAndRemoveUntil(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            const LoginScreen(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return FadeTransition(
                                              opacity: animation, child: child);
                                        },
                                      ),
                                      (route) => false,
                                    );
                                  }},
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red,
                              side:
                                  const BorderSide(color: Colors.red, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.logout, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Logout',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
      
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isEditable,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isEditable ? Colors.grey[50] : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isEditable
                  ? const Color.fromARGB(255, 234, 102, 216).withOpacity(0.3)
                  : Colors.grey[300]!,
            ),
          ),
          child: TextField(
            controller: controller,
            enabled: isEditable,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[800],
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: isEditable
                    ? const Color.fromARGB(255, 234, 102, 216)
                    : Colors.grey[400],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color.fromARGB(255, 234, 102, 216).withOpacity(0.3),
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: !isVisible,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[800],
            ),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Color.fromARGB(255, 234, 102, 216),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[400],
                ),
                onPressed: onVisibilityToggle,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Ubah Foto Profile',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImagePickerOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () {
                      _pickFile();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.grey[600]),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

}