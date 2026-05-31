import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const keepdayPrimary = Color(0xFF0468D7);
const keepdayPrimaryContainer = Color(0xFF02569B);
const keepdaySecondary = Color(0xFFD78A1F);
const keepdayTertiary = Color(0xFF54C5F8);
const keepdaySuccess = Color(0xFF2EAD6B);
const keepdayDanger = Color(0xFFD84C4C);
const keepdayBackground = Color(0xFFF7F8F6);
const keepdaySurface = Color(0xFFFFFFFF);
const keepdaySurfaceSoft = Color(0xFFEEF6F4);
const keepdayLine = Color(0xFFDDE5E2);
const keepdayMuted = Color(0xFF6D767A);
const keepdayText = Color(0xFF121D21);

class KeepDayTopBar extends StatelessWidget implements PreferredSizeWidget {
  const KeepDayTopBar({
    required this.title,
    this.leading,
    this.actions = const [],
    this.centerTitle = false,
    super.key,
  });

  final String title;
  final Widget? leading;
  final List<Widget> actions;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 64,
      leading: leading,
      centerTitle: centerTitle,
      title: Row(
        mainAxisSize: centerTitle ? MainAxisSize.min : MainAxisSize.max,
        children: [
          if (!centerTitle) ...[
            const Icon(Icons.calendar_today, color: keepdayPrimary, size: 22),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: const TextStyle(
              color: keepdayPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }
}

class KeepDayBottomNav extends StatelessWidget {
  const KeepDayBottomNav({required this.active, super.key});

  final String active;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: keepdaySurface.withValues(alpha: 0.96),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A2F8F83),
              blurRadius: 12,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.format_list_bulleted,
              label: 'Habits',
              active: active == 'habits',
              onTap: () => context.go('/'),
            ),
            _NavItem(
              icon: Icons.equalizer,
              label: 'Stats',
              active: active == 'stats',
              onTap: () {},
            ),
            _NavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              active: active == 'profile',
              onTap: () => context.go('/settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = active ? Colors.white : keepdayMuted;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? keepdayPrimaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: foreground, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: foreground,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KeepDayCard extends StatelessWidget {
  const KeepDayCard({required this.child, this.padding, super.key});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: keepdaySurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: keepdayLine),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A2F8F83),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class KeepDayHabitIcon extends StatelessWidget {
  const KeepDayHabitIcon({
    required this.icon,
    this.size = 40,
    this.background = keepdaySurfaceSoft,
    super.key,
  });

  final String? icon;
  final double size;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        icon == null || icon!.isEmpty ? '✓' : icon!,
        style: TextStyle(fontSize: size * 0.48),
      ),
    );
  }
}

class KeepDayStatusRing extends StatelessWidget {
  const KeepDayStatusRing({
    required this.checked,
    required this.onTap,
    this.grace = false,
    this.checkedColor = keepdayPrimary,
    super.key,
  });

  final bool checked;
  final bool grace;
  final Color checkedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: checked ? checkedColor : Colors.transparent,
          shape: BoxShape.circle,
          border: checked
              ? null
              : Border.all(
                  color: grace ? keepdaySecondary : keepdayLine,
                  width: 2,
                ),
          boxShadow: checked
              ? const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: checked
            ? const Icon(Icons.check, color: Colors.white, size: 22)
            : grace
            ? Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: keepdaySecondary,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

Color habitColorFromHex(String value) {
  final normalized = value.trim().replaceFirst('#', '');
  final parsed = int.tryParse('FF$normalized', radix: 16);
  if (parsed == null || normalized.length != 6) {
    return keepdayPrimary;
  }
  return Color(parsed);
}

Color habitSoftColor(String value) {
  return Color.lerp(habitColorFromHex(value), Colors.white, 0.86)!;
}

Color habitReadableColor(String value) {
  final color = habitColorFromHex(value);
  if (color.computeLuminance() > 0.45) {
    return Color.lerp(color, Colors.black, 0.28)!;
  }
  return color;
}

class KeepDaySectionLabel extends StatelessWidget {
  const KeepDaySectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: keepdayText,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
