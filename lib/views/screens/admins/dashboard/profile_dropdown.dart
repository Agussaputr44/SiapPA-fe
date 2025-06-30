import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileDropdown extends StatefulWidget {
  const ProfileDropdown({Key? key}) : super(key: key);

  @override
  _ProfileDropdownState createState() => _ProfileDropdownState();
}

class _ProfileDropdownState extends State<ProfileDropdown> {
  OverlayEntry? _dropdownOverlay;
  final LayerLink _layerLink = LayerLink();

  void _toggleDropdown() {
    if (_dropdownOverlay == null) {
      _showDropdown();
    } else {
      _removeDropdown();
    }
  }

  void _showDropdown() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final avatarOffset = renderBox.localToGlobal(Offset.zero);
    final avatarSize = renderBox.size;
    final screenWidth = MediaQuery.of(context).size.width;
    final dropdownWidth = screenWidth < 260 ? screenWidth - 32 : 240.0;
    final left = (avatarOffset.dx + avatarSize.width - dropdownWidth).clamp(16.0, screenWidth - dropdownWidth - 16.0);

    _dropdownOverlay = OverlayEntry(
      builder: (context) {
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
                          icon: Icons.email,
                          title: 'Myshhhh@gmail.com',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.settings,
                          title: 'Manage Account',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.logout,
                          title: 'Log out',
                          onTap: () {},
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

    Overlay.of(context, rootOverlay: true)!.insert(_dropdownOverlay!);
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
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: CircleAvatar(
          backgroundColor: Colors.grey[200],
          radius: 28,
          backgroundImage: const AssetImage('assets/images/logo.png'),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return InkWell(
      onTap: () {
        onTap();
        _removeDropdown();
      },
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