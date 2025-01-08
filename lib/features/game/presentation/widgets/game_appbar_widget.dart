import 'package:flutter/material.dart';
import 'package:reversed_minesweeper/features/game/presentation/widgets/profile_bottom_sheet.dart';
import '../../../../helpers/shared_pref.dart';

class GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentGridSize;
  final Function(int) onGridSizeSelected;

  GameAppBar({required this.currentGridSize, required this.onGridSizeSelected});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SharedPrefsHelper().isGoogleLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == false) {
          // Return AppBar without the profile icon if not logged in with Google
          return _buildAppBar(context, showProfileIcon: false);
        }
        // Return AppBar with the profile icon
        return _buildAppBar(context, showProfileIcon: true);
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, {required bool showProfileIcon}) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text(
        "Reversed Minesweeper",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        if (showProfileIcon)
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () async {
              _openBottomSheet(context);
            },
          ),
        PopupMenuButton<int>(
          onSelected: (selectedGridSize) {
            onGridSizeSelected(selectedGridSize); // Notify parent of selection
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 8,
              child: Text("8x8"),
            ),
            PopupMenuItem(
              value: 10,
              child: Text("10x10"),
            ),
            PopupMenuItem(
              value: 12,
              child: Text("12x12"),
            ),
          ],
          icon: Icon(Icons.more_vert, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Future<void> _openBottomSheet(BuildContext context) async {
    final userName = await SharedPrefsHelper().getUserName();
    final email = await SharedPrefsHelper().getEmail();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ProfileBottomSheet(
        userName: userName,
        email: email,
      ),
    );
  }
}
