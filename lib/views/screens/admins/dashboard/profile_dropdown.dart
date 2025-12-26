import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:siappa/providers/users_provider.dart';
import '../../../../helpers/dialog_helper.dart';
import '../../../../helpers/profile_url_helper.dart';
import '../../../../providers/auth_provider.dart';
import '../../auth/login_screen.dart';

class ProfileDropdown extends StatefulWidget {
  const ProfileDropdown({Key? key}) : super(key: key);

  @override
  _ProfileDropdownState createState() => _ProfileDropdownState();
}

class _ProfileDropdownState extends State<ProfileDropdown> {
  OverlayEntry? _dropdownOverlay;
  final LayerLink _layerLink = LayerLink();

  // Simpan context parent (utama)
  late BuildContext _parentContext;

  void _toggleDropdown() {
    if (_dropdownOverlay == null) {
      _showDropdown();
    } else {
      _removeDropdown();
    }
  }

  void _showDropdown() {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final avatarOffset = renderBox.localToGlobal(Offset.zero);
    final avatarSize = renderBox.size;
    final screenWidth = MediaQuery.of(context).size.width;
    final dropdownWidth = screenWidth < 260 ? screenWidth - 32 : 240.0;
    final left = (avatarOffset.dx + avatarSize.width - dropdownWidth)
        .clamp(16.0, screenWidth - dropdownWidth - 16.0);

    _dropdownOverlay = OverlayEntry(
      builder: (overlayContext) {
        // Gunakan overlayContext hanya untuk UI, BUKAN untuk dialog/navigasi!
        return Consumer<UsersProvider>(
          builder: (context, usersProvider, _) {
            final user = usersProvider.user;
            final name = user?.name ?? 'Memuat...';
            final email = user?.email ?? 'Memuat...';

            return GestureDetector(
              onTap: _removeDropdown,
              behavior: HitTestBehavior.translucent,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                  Positioned(
                    left: left,
                    top: avatarOffset.dy + avatarSize.height + 10,
                    width: dropdownWidth,
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildMenuItem(
                              icon: Icons.person,
                              title: name,
                              onTap: _removeDropdown,
                            ),
                            _buildMenuItem(
                              icon: Icons.email,
                              title: email,
                              onTap: _removeDropdown,
                            ),
                            const Divider(height: 1),
                            _buildMenuItem(
                              icon: Icons.settings,
                              title: 'Manage Account',
                              onTap: () {
                                _removeDropdown();
                                Navigator.pushNamed(context, '/profile');
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.logout,
                              title: 'Keluar',
                              onTap: () async {
                                // Tutup dropdown dulu
                                _removeDropdown();
                                // Tunggu overlay benar-benar hilang
                                await Future.delayed(
                                    const Duration(milliseconds: 100));

                                // GUNAKAN CONTEXT PARENT (_parentContext), BUKAN overlayContext!
                                final shouldLogout =
                                    await showCustomConfirmDialog(
                                  context: _parentContext,
                                  title: 'Konfirmasi Keluar',
                                  message: 'Apakah anda yakin untuk keluar?',
                                  confirmText: 'Ya',
                                  cancelText: 'Batal',
                                  icon: Icons.logout,
                                  iconColor: Colors.red,
                                );
                                if (shouldLogout == true) {
                                  await authProvider.logout();
                                  if (!mounted) return;
                                  Navigator.of(_parentContext)
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
                                }
                              },
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    Overlay.of(context, rootOverlay: true).insert(_dropdownOverlay!);
  }

  void _removeDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  @override
  void dispose() {
    _removeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _parentContext = context;
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Consumer<UsersProvider>(
          builder: (context, usersProvider, child) {
            final photoUrl = usersProvider.user?.fotoProfile;
            return CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 28,
              backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                  ? NetworkImage(getFotoUrl(photoUrl))
                  : const AssetImage('assets/icons/ic_profile.png')
                      as ImageProvider,
            );
          },
        ),
      ),
    );
  }

  /// Tidak langsung menutup dropdown, biarkan tiap menu menutup sendiri jika perlu
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
