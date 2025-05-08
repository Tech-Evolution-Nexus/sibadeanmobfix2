import 'package:flutter/material.dart';
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

  final List<Map<String, dynamic>> _items = [
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
      'label': 'Riwayat Pengajuan',
    },
    {
      'icon': Icons.person_2,
      'label': 'Profile',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    return Container(
      height: width * 0.2,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isActive = widget.currentIndex == index;
          // final isActive = _selectedIndex == index;

          return Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                    widget.onTap(index);
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'],
                        color:
                            isActive ? lightColorScheme.primary : Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      Visibility(
                        visible: isActive,
                        child: Text(
                          item['label'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: isActive
                                ? lightColorScheme.primary
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
    );
  }
}
