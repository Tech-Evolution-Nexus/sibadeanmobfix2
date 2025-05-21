import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/methods/auth.dart';
import 'package:sibadeanmob_v2_fix/theme/theme.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/dashboard/dashboard_warga.dart';

class BottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _items_warga = [
    {
      'icon': Icons.home_rounded,
      'label': 'Home',
    },
    {
      'icon': Icons.newspaper,
      'label': 'Berita',
    },
    {
      'icon': Icons.mail_rounded,
      'label': 'Riwayat',
    },
    {
      'icon': Icons.person_2,
      'label': 'Profile',
    },
  ];
  final List<Map<String, dynamic>> _items_rt = [
    {
      'icon': Icons.home_rounded,
      'label': 'Home',
    },
    {
      'icon': Icons.mail_rounded,
      'label': 'Riwayat',
    },
    {
      'icon': Icons.person_2,
      'label': 'Profile',
    },
  ];

  List<Map<String, dynamic>> _items = [];
  @override
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
    _items = _items_warga;

    _loadUserData(); // jalankan async function di luar setState
  }

  void _loadUserData() async {
    // var user = await Auth.user();
    // setState(() {
    //   if (user["role"] == "masyarakat") {
    //     _items = _items_warga;
    //   } else if (user["role"] == "rt") {
    //     _items = _items_rt;
    //   } else {
    //     _items = _items_rt;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    return _items.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: IntrinsicHeight(
              // 👈 Tambahkan ini
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_items.length, (index) {
                  final item = _items[index];
                  final isActive = widget.currentIndex == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                          widget.onTap(index);
                        });
                      },
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item['icon'],
                                color: isActive
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                              ),
                              const SizedBox(height: 4),
                              Visibility(
                                visible: isActive,
                                // maintainSize: true,
                                // maintainAnimation: true,
                                // maintainState: true,
                                child: Text(
                                  item['label'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isActive
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          );
  }
}
