import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:siappa/providers/upload_media_provider.dart';
import 'package:siappa/providers/users_provider.dart';
import 'package:siappa/views/widgets/loading_widget.dart';
import '../../../../providers/auth_provider.dart';
import '../../../widgets/messages_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isEditing = false;

  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    // Load user details when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'gif', 'mp4', 'mov', 'avi'],
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

    await userProvider.loadUserDetails(authProvider);

    // Update controllers with loaded data
    if (userProvider.user != null) {
      _nameController.text = userProvider.user!.name ?? '';
      _emailController.text = userProvider.user!.email ?? '';
    }
  }

  // Save updated user data
  Future<void> _saveUserData() async {
  final userProvider = Provider.of<UsersProvider>(context, listen: false);
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final uploadProvider = Provider.of<UploadMediaProvider>(context, listen: false);

  final name = _nameController.text.trim();

  // Validate input
  if (name.isEmpty) {
    MessagesWidget.showError(context, "Nama harus diisi.");
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

    String? fotoUrl = userProvider.user?.fotoProfile; // Retain existing URL if no new file
    if (_selectedFile != null) {
      // Validate file type
      final validExtensions = ['jpg', 'jpeg', 'png', 'gif'];
      final fileExtension = _selectedFile!.path.split('.').last.toLowerCase();

      if (!validExtensions.contains(fileExtension)) {
        Navigator.pop(context); // Hide loading
        MessagesWidget.showError(context, "Tipe file tidak didukung.");
        return;
      }

      // Upload file
      await uploadProvider.upload([_selectedFile!]);

      if (uploadProvider.uploadedFiles.isEmpty) {
        Navigator.pop(context); // Hide loading
        throw Exception('File gagal diupload.');
      }

      fotoUrl = uploadProvider.uploadedFiles.first;
    }

    // Update user profile
    await userProvider.updateUserProfile(
      authProvider,
      name: name,
      fotoProfil: fotoUrl, 
    );

    // Hide loading
    Navigator.pop(context);

    // Show success message
    MessagesWidget.showSuccess(context, "Profil berhasil diperbarui.");

    // Update UI state
    setState(() {
      _isEditing = false;
      _selectedFile = null; // Reset selected file
    });

    // Navigate to profile screen or stay on current screen
    Navigator.of(context).pushNamedAndRemoveUntil('/profile', (route) => false);
  } catch (e) {
    // Hide loading
    Navigator.pop(context);

    // Show error message
    MessagesWidget.showError(context, "Gagal memperbarui profil: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 234, 102, 216),
              Color.fromARGB(255, 190, 85, 155),
            ],
          ),
        ),
        child: LoadingWidget(
          isLoading: UsersProvider().isLoading,
          child: SafeArea(
            child: Consumer2<UsersProvider, AuthProvider>(
              builder: (context, userProvider, authProvider, child) {
                // Show loading state

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
                            foregroundColor: Colors.pink,
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

                final user = UsersProvider().user;

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
                                  backgroundImage: user?.fotoProfile != null
                                      ? NetworkImage(user!.fotoProfile!)
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
                                      color: Colors.pink,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.pink.withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.camera_alt,
                                          color: Colors.white, size: 20),
                                      onPressed: () {
                                        // Handle image change
                                        _showImagePicker(
                                        
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        const SizedBox(height: 8),

                        // Main Content Card
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
                                        onPressed: () {
                                          _saveUserData();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.pink,
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

                        const SizedBox(height: 10),

                        // Logout Button
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              _showLogoutDialog();
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red,
                              side: const BorderSide(
                                  color: Colors.red, width: 1.5),
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
              color:
                  isEditable ? Colors.pink.withOpacity(0.3) : Colors.grey[300]!,
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
                color: isEditable ? Colors.pink : Colors.grey[400],
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar?',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                // Handle logout logic
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();

                // Navigate to login screen
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
