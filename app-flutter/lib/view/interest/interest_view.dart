import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class InterestView extends StatefulWidget {
  const InterestView({super.key});

  @override
  State<InterestView> createState() => _InterestViewState();
}

enum _InterestSurface {
  match,
  editCard,
}

enum _InterestOverlay {
  none,
  like,
  filter,
  vipLimit,
}

class _InterestViewState extends State<InterestView>
    with SingleTickerProviderStateMixin {
  static const _background = Color(0xFFF2F2F2);

  static const _interests = [
    'Food & Coffee',
    'Reading & Learning',
    'Lifestyle & Daily Chat',
  ];

  static const _quickOpeners = [
    '"Saw you love gaming too!\nWhat do you play?"',
    '"Your profile card is sick!\nWanna chat?"',
  ];

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final Set<String> _selectedGenders = {'Everyone'};
  AnimationController? _filterSheetController;
  Animation<double>? _filterSheetAnimation;
  String? _selectedQuickOpener;

  _InterestSurface _surface = _InterestSurface.match;
  _InterestOverlay _overlay = _InterestOverlay.none;
  String? _selectedStatus;
  RangeValues _ageRange = const RangeValues(18, 28);
  int _swipeCount = 6;

  @override
  void initState() {
    super.initState();
    _ensureFilterSheetController();
    _messageController.addListener(_onMessageChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: SystemUiOverlay.values,
      );
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: _background,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    });
  }

  AnimationController _ensureFilterSheetController() {
    final existing = _filterSheetController;
    if (existing != null) {
      return existing;
    }

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      reverseDuration: const Duration(milliseconds: 210),
    );
    _filterSheetController = controller;
    _filterSheetAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return controller;
  }

  Animation<double> get _filterSheetMotion {
    _ensureFilterSheetController();
    return _filterSheetAnimation!;
  }

  @override
  void dispose() {
    _messageController.removeListener(_onMessageChanged);
    _messageController.dispose();
    _messageFocusNode.dispose();
    _filterSheetController?.dispose();
    super.dispose();
  }

  void _onMessageChanged() {
    if (_overlay == _InterestOverlay.like) {
      if (_messageController.text.trim().isNotEmpty &&
          _selectedQuickOpener != null) {
        _selectedQuickOpener = null;
      }
      setState(() {});
    }
  }

  void _openLike({String message = ''}) {
    _selectedQuickOpener = null;
    _messageController.text = message;
    _messageController.selection = TextSelection.collapsed(
      offset: _messageController.text.length,
    );
    _messageFocusNode.unfocus();
    setState(() => _overlay = _InterestOverlay.like);
  }

  void _openFilter() {
    _messageFocusNode.unfocus();
    final controller = _ensureFilterSheetController();
    controller.stop();
    setState(() => _overlay = _InterestOverlay.filter);
    controller.forward(from: 0);
  }

  void _openVipLimit() {
    _messageFocusNode.unfocus();
    setState(() => _overlay = _InterestOverlay.vipLimit);
  }

  void _closeOverlay() {
    _messageFocusNode.unfocus();
    if (_overlay == _InterestOverlay.filter) {
      _dismissFilterSheet();
      return;
    }
    setState(() => _overlay = _InterestOverlay.none);
  }

  void _dismissFilterSheet() {
    _ensureFilterSheetController().reverse().whenComplete(_clearFilterOverlay);
  }

  void _clearFilterOverlay() {
    if (mounted && _overlay == _InterestOverlay.filter) {
      setState(() => _overlay = _InterestOverlay.none);
    }
  }

  void _showEditCard({bool publishable = false}) {
    _messageFocusNode.unfocus();
    setState(() {
      _overlay = _InterestOverlay.none;
      _surface = _InterestSurface.editCard;
      _selectedStatus = publishable ? 'Just want someone to chill with.' : null;
    });
  }

  void _showMatchCard() {
    setState(() {
      _surface = _InterestSurface.match;
      _overlay = _InterestOverlay.none;
    });
  }

  void _onNextCard() {
    if (_swipeCount >= 6) {
      _openVipLimit();
      return;
    }
    setState(() => _swipeCount += 1);
  }

  void _onGenderToggled(String gender) {
    setState(() {
      if (_selectedGenders.contains(gender)) {
        _selectedGenders.remove(gender);
      } else {
        _selectedGenders.add(gender);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: _surface == _InterestSurface.editCard
          ? const Color(0xFFF5F5F5)
          : _background,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: _surface == _InterestSurface.editCard
                ? _EditCardSurface(
                    selectedStatus: _selectedStatus,
                    onBack: _showMatchCard,
                    onStatusSelected: (status) {
                      setState(() => _selectedStatus = status);
                    },
                  )
                : _MatchSurface(
                    interests: _interests,
                    onAvatarTap: _showEditCard,
                    onStarChat: () => _openLike(),
                    onPrev: () {},
                    onNext: _onNextCard,
                    onFilter: _openFilter,
                  ),
          ),
          if (_overlay != _InterestOverlay.none)
            Positioned.fill(child: _buildOverlay()),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    switch (_overlay) {
      case _InterestOverlay.like:
        return _Scrim(
          onTap: _closeOverlay,
          child: _LikeOverlay(
            controller: _messageController,
            focusNode: _messageFocusNode,
            selectedQuickOpener: _selectedQuickOpener,
            quickOpeners: _quickOpeners,
            onQuickSelected: (message) {
              _messageFocusNode.unfocus();
              _messageController.clear();
              setState(() => _selectedQuickOpener = message);
            },
            onSend: _closeOverlay,
          ),
        );
      case _InterestOverlay.filter:
        return _BottomPopupScrim(
          controller: _ensureFilterSheetController(),
          animation: _filterSheetMotion,
          onTap: _closeOverlay,
          onDismissed: _clearFilterOverlay,
          opacity: 0.18,
          child: _FilterSheet(
            selectedGenders: _selectedGenders,
            ageRange: _ageRange,
            onGenderToggled: _onGenderToggled,
            onAgeRangeChanged: (range) {
              setState(() => _ageRange = range);
            },
            onConfirm: _closeOverlay,
          ),
        );
      case _InterestOverlay.vipLimit:
        return _Scrim(
          onTap: _closeOverlay,
          opacity: 0.38,
          child: _VipLimitDialog(
            onUpgrade: _closeOverlay,
            onCancel: _closeOverlay,
          ),
        );
      case _InterestOverlay.none:
        return const SizedBox.shrink();
    }
  }
}

class _MatchSurface extends StatelessWidget {
  static const double _designWidth = 1125;
  static const double _designHeight = 2436;
  static const double _designTopSafeBand = 203;
  static const double _designBottomSafeBand = 337;
  static const double _maxPhoneContentWidth = 375;

  final List<String> interests;
  final VoidCallback onAvatarTap;
  final VoidCallback onStarChat;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onFilter;

  const _MatchSurface({
    required this.interests,
    required this.onAvatarTap,
    required this.onStarChat,
    required this.onPrev,
    required this.onNext,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final safePadding = media.viewPadding;
    final gestureInsets = media.systemGestureInsets;

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalInset = math.max(
          math.max(safePadding.left, safePadding.right),
          math.max(gestureInsets.left, gestureInsets.right),
        );
        final bottomInset = math.max(safePadding.bottom, gestureInsets.bottom);
        final usableWidth = math.max(
          1.0,
          constraints.maxWidth - horizontalInset * 2,
        );
        final phoneWidth = math.min(usableWidth, _maxPhoneContentWidth);
        final widthScale = phoneWidth / _designWidth;
        final topExtra = math.max(
          0.0,
          safePadding.top - _designTopSafeBand * widthScale,
        );
        final bottomExtra = math.max(
          0.0,
          bottomInset - _designBottomSafeBand * widthScale,
        );
        final availableHeight = math.max(
          1.0,
          constraints.maxHeight - topExtra - bottomExtra,
        );
        final heightScale = availableHeight / _designHeight;
        final scale = math.min(widthScale, heightScale);
        final artboardWidth = _designWidth * scale;
        final artboardHeight = _designHeight * scale;
        final left = (constraints.maxWidth - artboardWidth) / 2;
        final top = topExtra;
        final panelTop = top + 156 * scale;

        return ColoredBox(
          color: const Color(0xFFF2F2F2),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: panelTop,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E6E6),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(75 * scale),
                      topRight: Radius.circular(75 * scale),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: left,
                top: top,
                width: artboardWidth,
                height: artboardHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _ProfilePillArtboard(scale: scale, onTap: onAvatarTap),
                    _StackedCardArtboard(
                      scale: scale,
                      interests: interests,
                      onFilter: onFilter,
                    ),
                    _BottomActionsArtboard(
                      scale: scale,
                      onPrev: onPrev,
                      onStarChat: onStarChat,
                      onNext: onNext,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

List<BoxShadow> _softLanhuShadow(
  double scale, {
  double opacity = 0.08,
  double blur = 18,
  double dx = 15,
}) {
  return [
    BoxShadow(
      color: const Color(0xFF808080).withOpacity(opacity),
      blurRadius: blur * scale,
      offset: Offset(dx * scale, 0),
    ),
  ];
}

class _ProfilePillArtboard extends StatelessWidget {
  final double scale;
  final VoidCallback onTap;

  const _ProfilePillArtboard({
    required this.scale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 724 * scale,
      top: 203 * scale,
      width: 329 * scale,
      height: 201 * scale,
      child: Semantics(
        button: true,
        label: 'Edit profile card',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 14 * scale,
                top: 5 * scale,
                width: 300 * scale,
                height: 166 * scale,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(83 * scale),
                    boxShadow: _softLanhuShadow(scale),
                  ),
                ),
              ),
              Positioned(
                left: 149 * scale,
                top: 5 * scale,
                width: 165 * scale,
                height: 166 * scale,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(83 * scale),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      15 * scale,
                      16 * scale,
                      15 * scale,
                      15 * scale,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/default_avatar.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StackedCardArtboard extends StatelessWidget {
  final double scale;
  final List<String> interests;
  final VoidCallback onFilter;

  const _StackedCardArtboard({
    required this.scale,
    required this.interests,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    final frontCardRadius = BorderRadius.only(
      topLeft: Radius.circular(90 * scale),
      topRight: Radius.circular(195 * scale),
      bottomRight: Radius.circular(90 * scale),
      bottomLeft: Radius.circular(195 * scale),
    );

    return Stack(
      children: [
        _shadowCard(
          left: 196,
          top: 391,
          width: 690,
          height: 1049,
          radius: 92,
          gradientOpacity: 0.58,
        ),
        _shadowCard(
          left: 131,
          top: 424,
          width: 820,
          height: 1228,
          radius: 98,
          gradientOpacity: 0.36,
        ),
        Positioned(
          left: 52 * scale,
          top: 458 * scale,
          width: 1021 * scale,
          height: 1402 * scale,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: frontCardRadius,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF808080).withOpacity(0.05),
                  blurRadius: 15 * scale,
                  offset: Offset(15 * scale, 0),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: frontCardRadius,
              child: Stack(
                children: [
                  Positioned(
                    left: 39 * scale,
                    top: 39 * scale,
                    width: 943 * scale,
                    height: 534 * scale,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFFAD4D6),
                            Color(0xFFEBD6E8),
                            Color(0xFFDABAF3),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(75 * scale),
                          topRight: Radius.circular(180 * scale),
                          bottomRight: Radius.circular(75 * scale),
                          bottomLeft: Radius.circular(75 * scale),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 96 * scale,
                    top: 247 * scale,
                    width: 394 * scale,
                    height: 395 * scale,
                    child: Container(
                      padding: EdgeInsets.all(17 * scale),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(96 * scale),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(78 * scale),
                        child: Image.asset(
                          'assets/images/default_avatar.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  _positionedLanhuText(
                    left: 520,
                    top: 470,
                    width: 387,
                    height: 71,
                    text: 'BunnyBelle',
                    fontSize: 75,
                    color: const Color(0xFF2C2C2C),
                    fontWeight: FontWeight.w600,
                    strokeWidth: 0.45,
                  ),
                  _positionedLanhuText(
                    left: 117,
                    top: 715,
                    width: 183,
                    height: 33,
                    text: 'Interests:',
                    fontSize: 45,
                    color: const Color(0xFF929292),
                    fontWeight: FontWeight.w400,
                    strokeWidth: 0.18,
                  ),
                  _InterestChipDesign(
                    scale: scale,
                    left: 90,
                    top: 779,
                    width: 311,
                    label: interests[0],
                  ),
                  _InterestChipDesign(
                    scale: scale,
                    left: 425,
                    top: 779,
                    width: 401,
                    label: interests[1],
                  ),
                  _InterestChipDesign(
                    scale: scale,
                    left: 90,
                    top: 872,
                    width: 436,
                    label: interests[2],
                  ),
                  _positionedLanhuText(
                    left: 117,
                    top: 1018,
                    width: 138,
                    height: 34,
                    text: 'Status:',
                    fontSize: 45,
                    color: const Color(0xFF929292),
                    fontWeight: FontWeight.w400,
                    strokeWidth: 0.18,
                  ),
                  _positionedLanhuText(
                    left: 116,
                    top: 1090,
                    width: 725,
                    height: 40,
                    text: 'Just want someone to chill with.',
                    fontSize: 51,
                    color: const Color(0xFF525252),
                    fontWeight: FontWeight.w400,
                    strokeWidth: 0.16,
                  ),
                  Positioned(
                    left: 699 * scale,
                    top: 1248 * scale,
                    width: 305 * scale,
                    height: 151 * scale,
                    child: Semantics(
                      button: true,
                      label: 'Filter',
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onFilter,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 15 * scale,
                              top: 15 * scale,
                              width: 260 * scale,
                              height: 121 * scale,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F7F7),
                                  borderRadius:
                                      BorderRadius.circular(57 * scale),
                                  boxShadow: _softLanhuShadow(scale),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 45 * scale,
                                      top: 33 * scale,
                                      width: 59 * scale,
                                      height: 55 * scale,
                                      child: CustomPaint(
                                        painter: _FilterBarsPainter(),
                                      ),
                                    ),
                                    _positionedLanhuText(
                                      left: 140,
                                      top: 46,
                                      width: 85,
                                      height: 30,
                                      text: 'Filter',
                                      fontSize: 39,
                                      color: const Color(0xFF929292),
                                      fontWeight: FontWeight.w400,
                                      strokeWidth: 0.14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _positionedLanhuText({
    required double left,
    required double top,
    required double width,
    required double height,
    required String text,
    required double fontSize,
    required Color color,
    required FontWeight fontWeight,
    double strokeWidth = 0,
    TextAlign textAlign = TextAlign.left,
  }) {
    return Positioned(
      left: left * scale,
      top: top * scale,
      width: width * scale,
      height: height * scale,
      child: _LanhuText(
        scale: scale,
        text: text,
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        strokeWidth: strokeWidth,
        textAlign: textAlign,
      ),
    );
  }

  Widget _shadowCard({
    required double left,
    required double top,
    required double width,
    required double height,
    required double radius,
    required double gradientOpacity,
  }) {
    final cardRadius = BorderRadius.circular(radius * scale);

    return Positioned(
      left: left * scale,
      top: top * scale,
      width: width * scale,
      height: height * scale,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: cardRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 38 * scale,
              offset: Offset(45 * scale, 0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: cardRadius,
          child: Stack(
            children: [
              Positioned(
                left: 39 * scale,
                top: 22 * scale,
                width: (width - 78) * scale,
                height: 534 * scale,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        const Color(0xFFFAD4D6).withOpacity(gradientOpacity),
                        const Color(0xFFEBD6E8).withOpacity(gradientOpacity),
                        const Color(0xFFDABAF3).withOpacity(gradientOpacity),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(75 * scale),
                      topRight: Radius.circular(180 * scale),
                      bottomRight: Radius.circular(75 * scale),
                      bottomLeft: Radius.circular(75 * scale),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchText extends StatelessWidget {
  final double scale;
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final double strokeWidth;

  const _MatchText({
    required this.scale,
    required this.text,
    required this.fontSize,
    required this.color,
    required this.fontWeight,
    this.strokeWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    Text buildText({Paint? foreground}) {
      return Text(
        text,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.visible,
        textScaler: TextScaler.noScaling,
        textHeightBehavior: const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
        style: TextStyle(
          inherit: false,
          color: foreground == null ? color : null,
          foreground: foreground,
          fontSize: fontSize * scale,
          height: 1,
          fontWeight: fontWeight,
          letterSpacing: 0,
        ),
      );
    }

    final textWidget = strokeWidth > 0
        ? Stack(
            clipBehavior: Clip.none,
            children: [
              buildText(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = strokeWidth * scale
                  ..color = color,
              ),
              buildText(),
            ],
          )
        : buildText();

    return textWidget;
  }
}

class _InterestChipDesign extends StatelessWidget {
  final double scale;
  final double left;
  final double top;
  final double width;
  final String label;

  const _InterestChipDesign({
    required this.scale,
    required this.left,
    required this.top,
    required this.width,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left * scale,
      top: top * scale,
      width: width * scale,
      height: 61 * scale,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 26 * scale),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(31 * scale),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: _MatchText(
            scale: scale,
            text: label,
            fontSize: 39,
            color: const Color(0xFF2C2C2C),
            fontWeight: FontWeight.w600,
            strokeWidth: 0.28,
          ),
        ),
      ),
    );
  }
}

class _FilterBarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE6928C)
      ..style = PaintingStyle.fill;
    final radius = Radius.circular(size.height * 0.1);
    final bars = [
      Rect.fromLTWH(0, 0, size.width, size.height * 0.22),
      Rect.fromLTWH(0, size.height * 0.40, size.width, size.height * 0.22),
      Rect.fromLTWH(
          0, size.height * 0.78, size.width * 0.62, size.height * 0.2),
    ];
    for (final rect in bars) {
      canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BottomActionsArtboard extends StatelessWidget {
  final double scale;
  final VoidCallback onPrev;
  final VoidCallback onStarChat;
  final VoidCallback onNext;

  const _BottomActionsArtboard({
    required this.scale,
    required this.onPrev,
    required this.onStarChat,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _ActionCircle(
          scale: scale,
          left: 112,
          top: 1926,
          label: 'Prev',
          isNext: false,
          onTap: onPrev,
        ),
        Positioned(
          left: 371 * scale,
          top: 1897 * scale,
          width: 384 * scale,
          height: 289 * scale,
          child: Semantics(
            button: true,
            label: 'Star chat',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onStarChat,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 14 * scale,
                    top: 5 * scale,
                    width: 355 * scale,
                    height: 254 * scale,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(126 * scale),
                        boxShadow: _softLanhuShadow(scale),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 40 * scale,
                            top: 97 * scale,
                            width: 275 * scale,
                            height: 51 * scale,
                            child: _LanhuText(
                              scale: scale,
                              text: 'Star chat',
                              fontSize: 66,
                              color: const Color(0xFFE6928C),
                              fontWeight: FontWeight.w700,
                              textAlign: TextAlign.center,
                              strokeWidth: 0.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _ActionCircle(
          scale: scale,
          left: 790,
          top: 1926,
          label: 'Next',
          isNext: true,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _LanhuText extends StatelessWidget {
  final double scale;
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final double strokeWidth;
  final TextAlign textAlign;

  const _LanhuText({
    required this.scale,
    required this.text,
    required this.fontSize,
    required this.color,
    required this.fontWeight,
    this.strokeWidth = 0,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: text,
      child: CustomPaint(
        painter: _LanhuTextPainter(
          scale: scale,
          text: text,
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          strokeWidth: strokeWidth,
          textAlign: textAlign,
        ),
      ),
    );
  }
}

class _LanhuTextPainter extends CustomPainter {
  final double scale;
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final double strokeWidth;
  final TextAlign textAlign;

  const _LanhuTextPainter({
    required this.scale,
    required this.text,
    required this.fontSize,
    required this.color,
    required this.fontWeight,
    required this.strokeWidth,
    required this.textAlign,
  });

  TextPainter _buildPainter({Paint? foreground}) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          inherit: false,
          color: foreground == null ? color : null,
          foreground: foreground,
          fontSize: fontSize * scale,
          height: 1,
          fontWeight: fontWeight,
          letterSpacing: 0,
        ),
      ),
      maxLines: 1,
      textAlign: textAlign,
      textDirection: TextDirection.ltr,
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
      textScaler: TextScaler.noScaling,
    );
  }

  void _paintText(Canvas canvas, Size size, {Paint? foreground}) {
    final textPainter = _buildPainter(foreground: foreground)
      ..layout(maxWidth: double.infinity);
    final boxes = textPainter.getBoxesForSelection(
      TextSelection(baseOffset: 0, extentOffset: text.length),
    );
    final textBounds = boxes.fold<Rect?>(
      null,
      (bounds, box) {
        final rect = box.toRect();
        return bounds == null ? rect : bounds.expandToInclude(rect);
      },
    );
    final bounds = textBounds ?? Offset.zero & textPainter.size;
    final fittedWidthScale = bounds.width > size.width && size.width > 0
        ? size.width / bounds.width
        : 1.0;
    final paintedWidth = bounds.width * fittedWidthScale;
    final dx = switch (textAlign) {
      TextAlign.center => (size.width - paintedWidth) / 2,
      TextAlign.right || TextAlign.end => size.width - paintedWidth,
      _ => 0.0,
    };
    final dy = (size.height - bounds.height) / 2;
    canvas
      ..save()
      ..translate(dx, dy)
      ..scale(fittedWidthScale, 1);
    textPainter.paint(canvas, Offset(-bounds.left, -bounds.top));
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (strokeWidth > 0) {
      _paintText(
        canvas,
        size,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth * scale
          ..color = color,
      );
    }
    _paintText(canvas, size);
  }

  @override
  bool shouldRepaint(covariant _LanhuTextPainter oldDelegate) {
    return oldDelegate.scale != scale ||
        oldDelegate.text != text ||
        oldDelegate.fontSize != fontSize ||
        oldDelegate.color != color ||
        oldDelegate.fontWeight != fontWeight ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.textAlign != textAlign;
  }
}

class _ActionCircle extends StatelessWidget {
  final double scale;
  final double left;
  final double top;
  final String label;
  final bool isNext;
  final VoidCallback onTap;

  const _ActionCircle({
    required this.scale,
    required this.left,
    required this.top,
    required this.label,
    required this.isNext,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left * scale,
      top: top * scale,
      width: 224 * scale,
      height: 231 * scale,
      child: Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 14 * scale,
                top: 5 * scale,
                width: 195 * scale,
                height: 196 * scale,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(98 * scale),
                    boxShadow: _softLanhuShadow(scale),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 55 * scale,
                        top: 53 * scale,
                        width: 79 * scale,
                        height: 91 * scale,
                        child: CustomPaint(
                          painter: _DoubleChevronPainter(isNext: isNext),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoubleChevronPainter extends CustomPainter {
  final bool isNext;

  const _DoubleChevronPainter({required this.isNext});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE6928C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.16
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width * 0.42;
    final h = size.height * 0.82;
    final gap = size.width * 0.04;
    final left = (size.width - w * 2 - gap) / 2;
    final y = (size.height - h) / 2;
    final xs = [left, left + w + gap];

    for (final x in xs) {
      final path = Path();
      if (isNext) {
        path
          ..moveTo(x, y)
          ..lineTo(x + w, y + h / 2)
          ..lineTo(x, y + h);
      } else {
        path
          ..moveTo(x + w, y)
          ..lineTo(x, y + h / 2)
          ..lineTo(x + w, y + h);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DoubleChevronPainter oldDelegate) {
    return oldDelegate.isNext != isNext;
  }
}

class _Scrim extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final double opacity;

  const _Scrim({
    required this.child,
    required this.onTap,
    this.opacity = 0.34,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(opacity),
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
            ),
          ),
          Center(child: child),
        ],
      ),
    );
  }
}

class _BottomPopupScrim extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final VoidCallback onDismissed;
  final AnimationController controller;
  final Animation<double> animation;
  final double opacity;

  const _BottomPopupScrim({
    required this.child,
    required this.onTap,
    required this.onDismissed,
    required this.controller,
    required this.animation,
    this.opacity = 0.18,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final value = animation.value;

        return Material(
          color: Colors.black.withOpacity(opacity * value),
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onTap,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onVerticalDragUpdate: (details) {
                    final height = context.size?.height ?? 1;
                    final delta = details.primaryDelta ?? 0;
                    controller.value =
                        (controller.value - delta / height).clamp(0.0, 1.0);
                  },
                  onVerticalDragEnd: (details) {
                    final velocity = details.primaryVelocity ?? 0;
                    if (velocity > 700 || controller.value < 0.72) {
                      controller.reverse().whenComplete(onDismissed);
                    } else {
                      controller.forward();
                    }
                  },
                  child: FractionalTranslation(
                    translation: Offset(0, 1 - value),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DesignCanvas extends StatelessWidget {
  static const double _designWidth = 1125;
  static const double _designHeight = 2436;
  static const double _maxPhoneContentWidth = 375;

  final Color? backgroundColor;
  final Widget Function(BuildContext context, double scale) builder;

  const _DesignCanvas({
    required this.builder,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final media = MediaQuery.of(context);
          final safePadding = media.viewPadding;
          final gestureInsets = media.systemGestureInsets;
          final horizontalInset = math.max(
            math.max(safePadding.left, safePadding.right),
            math.max(gestureInsets.left, gestureInsets.right),
          );
          final usableWidth = math.max(
            1.0,
            constraints.maxWidth - horizontalInset * 2,
          );
          final phoneWidth = math.min(usableWidth, _maxPhoneContentWidth);
          final widthScale = phoneWidth / _designWidth;
          final heightScale = constraints.maxHeight / _designHeight;
          final scale = math.min(widthScale, heightScale);
          final artboardWidth = _designWidth * scale;
          final artboardHeight = _designHeight * scale;
          final left = (constraints.maxWidth - artboardWidth) / 2;

          return ColoredBox(
            color: backgroundColor ?? Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: left,
                  top: 0,
                  width: artboardWidth,
                  height: artboardHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [builder(context, scale)],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DesignText extends StatelessWidget {
  final double scale;
  final double left;
  final double top;
  final double width;
  final double height;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final int maxLines;
  final double strokeWidth;
  final double lineHeight;

  const _DesignText({
    required this.scale,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.color,
    this.textAlign = TextAlign.left,
    this.maxLines = 1,
    this.strokeWidth = 0,
    this.lineHeight = 1.12,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left * scale,
      top: top * scale,
      width: width * scale,
      height: height * scale,
      child: maxLines == 1
          ? _LanhuText(
              scale: scale,
              text: text,
              fontSize: fontSize,
              color: color,
              fontWeight: fontWeight,
              strokeWidth: strokeWidth,
              textAlign: textAlign,
            )
          : Text(
              text,
              maxLines: maxLines,
              overflow: TextOverflow.visible,
              textAlign: textAlign,
              textScaler: TextScaler.noScaling,
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false,
              ),
              style: TextStyle(
                inherit: false,
                color: color,
                fontSize: fontSize * scale,
                height: lineHeight,
                fontWeight: fontWeight,
                letterSpacing: 0,
              ),
            ),
    );
  }
}

class _DesignRoundRect extends StatelessWidget {
  final double scale;
  final double left;
  final double top;
  final double width;
  final double height;
  final Color color;
  final double radius;
  final List<BoxShadow>? boxShadow;
  final Border? border;

  const _DesignRoundRect({
    required this.scale,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.color,
    required this.radius,
    this.boxShadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left * scale,
      top: top * scale,
      width: width * scale,
      height: height * scale,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius * scale),
          boxShadow: boxShadow,
          border: border,
        ),
      ),
    );
  }
}

class _LikeOverlay extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? selectedQuickOpener;
  final List<String> quickOpeners;
  final ValueChanged<String> onQuickSelected;
  final VoidCallback onSend;

  const _LikeOverlay({
    required this.controller,
    required this.focusNode,
    required this.selectedQuickOpener,
    required this.quickOpeners,
    required this.onQuickSelected,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, focusNode]),
      builder: (context, _) {
        final message = controller.text.trim();
        final hasCustomMessage = message.isNotEmpty;
        final hasSelectedOpener = selectedQuickOpener != null;
        final canSend = hasCustomMessage || hasSelectedOpener;
        final isLongMessage = hasCustomMessage && message.length > 20;
        final keyboardVisible =
            MediaQuery.viewInsetsOf(context).bottom > 0 || focusNode.hasFocus;
        final top = isLongMessage ? (keyboardVisible ? 535.0 : 566.0) : 598.0;
        final dialogHeight =
            isLongMessage ? (keyboardVisible ? 1328.0 : 1304.0) : 1265.0;
        final inputTop = isLongMessage
            ? top + 909
            : hasCustomMessage
                ? 1507.0
                : 1512.0;
        final inputHeight = isLongMessage
            ? 155.0
            : hasCustomMessage
                ? 92.0
                : 81.0;
        final inputWidth = hasCustomMessage ? 566.0 : 556.0;
        final inputText = hasCustomMessage ? message : 'Write your own...';
        final inputTextColor = hasCustomMessage
            ? const Color(0xFF2C2C2C)
            : const Color(0xFFB7B7B7);
        final smallSendTop =
            isLongMessage ? (keyboardVisible ? 1480.0 : 1512.0) : 1512.0;
        final bottomButtonTop = isLongMessage ? top + 1116 : 1651.0;
        final bottomButtonTextTop = bottomButtonTop + 31;

        return _DesignCanvas(
          builder: (context, scale) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {},
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _DesignRoundRect(
                    scale: scale,
                    left: isLongMessage && !keyboardVisible ? 152 : 143,
                    top: top,
                    width: isLongMessage && !keyboardVisible ? 821 : 840,
                    height: dialogHeight,
                    color: const Color(0xFFF2F2F2),
                    radius: 45,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF808080).withOpacity(0.05),
                        blurRadius: 15 * scale,
                        offset: Offset(15 * scale, 0),
                      ),
                    ],
                  ),
                  _DesignText(
                    scale: scale,
                    left: 213,
                    top: top + 72,
                    width: 482,
                    height: 52,
                    text: 'Message to Jordan:',
                    fontSize: 54,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF80576B),
                    strokeWidth: 0.25,
                  ),
                  _DesignRoundRect(
                    scale: scale,
                    left: 208,
                    top: top + 167,
                    width: 709,
                    height: isLongMessage && !keyboardVisible ? 4 : 3,
                    color: const Color(0xFFE3E3E3),
                    radius: 0,
                  ),
                  _MessageBubble(
                    scale: scale,
                    left: hasCustomMessage ? 208 : 203,
                    top: top + 216,
                    width: hasCustomMessage ? 709 : 719,
                    height: hasCustomMessage ? 217 : 227,
                    text:
                        '👏 Hey! I love movies too.\nWhat have you been watching lately?',
                    textLeft: 250,
                    textTop: top + 251,
                    textWidth: 603,
                    textHeight: 107,
                    lineHeight: 1.16,
                  ),
                  _DesignText(
                    scale: scale,
                    left: 223,
                    top: top + 458,
                    width: 617,
                    height: 60,
                    text: '💡 Try a different opener:',
                    fontSize: 54,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF80576B),
                    strokeWidth: 0.18,
                  ),
                  _QuickOpenerBubble(
                    scale: scale,
                    left: 208,
                    top: top + 566,
                    text: quickOpeners[0],
                    textTop: top + 580,
                    textWidth: 529,
                    selected: selectedQuickOpener == quickOpeners[0],
                    onTap: () => onQuickSelected(quickOpeners[0]),
                  ),
                  _QuickOpenerBubble(
                    scale: scale,
                    left: 208,
                    top: top + 740,
                    text: quickOpeners[1],
                    textTop: top + 760,
                    textWidth: 496,
                    selected: selectedQuickOpener == quickOpeners[1],
                    onTap: () => onQuickSelected(quickOpeners[1]),
                  ),
                  _LikeInput(
                    scale: scale,
                    left: hasCustomMessage ? 203 : 208,
                    top: inputTop,
                    width: inputWidth,
                    height: inputHeight,
                    controller: controller,
                    focusNode: focusNode,
                    hasMessage: hasCustomMessage,
                    isLongMessage: isLongMessage,
                    text: inputText,
                    textColor: inputTextColor,
                  ),
                  _SmallDesignSendButton(
                    scale: scale,
                    left: 793,
                    top: smallSendTop,
                    width: 124,
                    height: isLongMessage && keyboardVisible ? 82 : 81,
                    enabled: canSend,
                    onTap: canSend ? onSend : null,
                  ),
                  _GradientDesignButton(
                    scale: scale,
                    left: 407,
                    top: bottomButtonTop,
                    width: 311,
                    height: isLongMessage && !keyboardVisible ? 101 : 100,
                    radius: 22.5,
                    enabled: canSend,
                    label: 'Send',
                    labelLeft: 512,
                    labelTop: bottomButtonTextTop,
                    labelWidth: 109,
                    labelHeight: 37,
                    fontSize: 48,
                    onTap: canSend ? onSend : null,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final double scale;
  final double left;
  final double top;
  final double width;
  final double height;
  final String text;
  final double textLeft;
  final double textTop;
  final double textWidth;
  final double textHeight;
  final double lineHeight;

  const _MessageBubble({
    required this.scale,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.text,
    required this.textLeft,
    required this.textTop,
    required this.textWidth,
    required this.textHeight,
    this.lineHeight = 1.12,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _DesignRoundRect(
          scale: scale,
          left: left,
          top: top,
          width: width,
          height: height,
          color: Colors.white,
          radius: 22.5,
        ),
        _DesignText(
          scale: scale,
          left: textLeft,
          top: textTop,
          width: textWidth,
          height: textHeight,
          text: text,
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF2C2C2C),
          maxLines: 2,
          lineHeight: lineHeight,
        ),
      ],
    );
  }
}

class _QuickOpenerBubble extends StatelessWidget {
  final double scale;
  final double left;
  final double top;
  final String text;
  final double textTop;
  final double textWidth;
  final bool selected;
  final VoidCallback onTap;

  const _QuickOpenerBubble({
    required this.scale,
    required this.left,
    required this.top,
    required this.text,
    required this.textTop,
    required this.textWidth,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left * scale,
      top: top * scale,
      width: 709 * scale,
      height: 136 * scale,
      child: Semantics(
        button: true,
        label: text.replaceAll('\n', ' '),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.5 * scale),
                  border: selected
                      ? Border.all(
                          color: const Color(0xFFE8B6AE),
                          width: 5 * scale,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF808080).withOpacity(0.1),
                      blurRadius: 15 * scale,
                      offset: Offset(11 * scale, 0),
                    ),
                  ],
                ),
                child: const SizedBox.expand(),
              ),
              Positioned(
                left: 42 * scale,
                top: (textTop - top) * scale,
                width: textWidth * scale,
                height: 103 * scale,
                child: Text(
                  text,
                  maxLines: 2,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    inherit: false,
                    color: const Color(0xFF2C2C2C),
                    fontSize: 45 * scale,
                    height: 1.12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LikeInput extends StatelessWidget {
  final double scale;
  final double left;
  final double top;
  final double width;
  final double height;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasMessage;
  final bool isLongMessage;
  final String text;
  final Color textColor;

  const _LikeInput({
    required this.scale,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.controller,
    required this.focusNode,
    required this.hasMessage,
    required this.isLongMessage,
    required this.text,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left * scale,
      top: top * scale,
      width: width * scale,
      height: height * scale,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.5 * scale),
          border: hasMessage
              ? Border.all(
                  color: const Color(0xFFE8B6AE),
                  width: 5 * scale,
                )
              : null,
          boxShadow: hasMessage
              ? null
              : [
                  BoxShadow(
                    color: const Color(0xFF808080).withOpacity(0.1),
                    blurRadius: 15 * scale,
                    offset: Offset(11 * scale, 0),
                  ),
                ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            42 * scale,
            isLongMessage ? 18 * scale : 0,
            18 * scale,
            isLongMessage ? 12 * scale : 0,
          ),
          child: Align(
            alignment: isLongMessage ? Alignment.topLeft : Alignment.centerLeft,
            child: Stack(
              children: [
                if (!hasMessage)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        textScaler: TextScaler.noScaling,
                        style: TextStyle(
                          inherit: false,
                          color: textColor,
                          fontSize: 45 * scale,
                          height: 1.05,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                EditableText(
                  controller: controller,
                  focusNode: focusNode,
                  maxLines: isLongMessage ? 2 : 1,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(58),
                  ],
                  cursorColor: const Color(0xFFE6928C),
                  backgroundCursorColor: Colors.transparent,
                  cursorHeight: 45 * scale,
                  style: TextStyle(
                    inherit: false,
                    color: textColor,
                    fontSize: 45 * scale,
                    height: 1.05,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallDesignSendButton extends StatelessWidget {
  final double scale;
  final double left;
  final double top;
  final double width;
  final double height;
  final bool enabled;
  final VoidCallback? onTap;

  const _SmallDesignSendButton({
    required this.scale,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left * scale,
      top: top * scale,
      width: width * scale,
      height: height * scale,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: 'Send',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Stack(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: enabled
                      ? const Color(0xFFEE9791)
                      : const Color(0xFFCCCCCC),
                  borderRadius: BorderRadius.circular(40.5 * scale),
                ),
                child: const SizedBox.expand(),
              ),
              _DesignText(
                scale: scale,
                left: 12,
                top: 23,
                width: 100,
                height: 33,
                text: 'Send',
                fontSize: 42,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                textAlign: TextAlign.center,
                strokeWidth: enabled ? 0.15 : 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientDesignButton extends StatelessWidget {
  final double scale;
  final double left;
  final double top;
  final double width;
  final double height;
  final double radius;
  final bool enabled;
  final String label;
  final double labelLeft;
  final double labelTop;
  final double labelWidth;
  final double labelHeight;
  final double fontSize;
  final VoidCallback? onTap;

  const _GradientDesignButton({
    required this.scale,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.radius,
    required this.enabled,
    required this.label,
    required this.labelLeft,
    required this.labelTop,
    required this.labelWidth,
    required this.labelHeight,
    required this.fontSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left * scale,
      top: top * scale,
      width: width * scale,
      height: height * scale,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: enabled ? null : const Color(0xFFBDBDBD),
                  gradient: enabled
                      ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFD5A7BD),
                            Color(0xFFFF9595),
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(radius * scale),
                ),
                child: const SizedBox.expand(),
              ),
              _DesignText(
                scale: scale,
                left: labelLeft - left,
                top: labelTop - top,
                width: labelWidth,
                height: labelHeight,
                text: label,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFEF4F3),
                textAlign: TextAlign.center,
                strokeWidth: 0.2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  static const double _designWidth = 1125;
  static const double _designHeight = 2436;
  static const double _sheetTop = 1272;
  static const double _sheetHeight = 1164;
  static const double _maxPhoneContentWidth = 375;

  final Set<String> selectedGenders;
  final RangeValues ageRange;
  final ValueChanged<String> onGenderToggled;
  final ValueChanged<RangeValues> onAgeRangeChanged;
  final VoidCallback onConfirm;

  const _FilterSheet({
    required this.selectedGenders,
    required this.ageRange,
    required this.onGenderToggled,
    required this.onAgeRangeChanged,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final safePadding = media.viewPadding;
    final gestureInsets = media.systemGestureInsets;
    final horizontalInset = math.max(
      math.max(safePadding.left, safePadding.right),
      math.max(gestureInsets.left, gestureInsets.right),
    );
    final usableWidth = math.max(1.0, size.width - horizontalInset * 2);
    final phoneWidth = math.min(usableWidth, _maxPhoneContentWidth);
    final widthScale = phoneWidth / _designWidth;
    final heightScale = size.height / _designHeight;
    final scale = math.min(widthScale, heightScale);
    final artboardWidth = _designWidth * scale;
    final sheetHeight = _sheetHeight * scale;
    final contentLeft = (size.width - artboardWidth) / 2;
    double y(double top) => top - _sheetTop;
    final end = ageRange.end.clamp(18, 65);
    const sliderLeft = 112.0;
    const trackLeft = 13.0;
    const trackWidth = 875.0;
    const thumbSize = 52.0;
    const thumbRadius = thumbSize / 2;
    const thumbCenterMin = trackLeft + thumbRadius;
    const thumbCenterMax = trackLeft + trackWidth - thumbRadius;
    final percent = ((end - 18) / (65 - 18)).clamp(0.0, 1.0);
    final thumbCenter =
        thumbCenterMin + percent * (thumbCenterMax - thumbCenterMin);
    final activeWidth = thumbCenter - trackLeft + thumbRadius;
    final endLabel = end >= 64.5 ? '65+' : '${end.round()}';
    final endLabelWidth = end >= 64.5 ? 62.0 : 42.0;
    final endLabelLeft = (sliderLeft + thumbCenter - endLabelWidth / 2)
        .clamp(134.0, 1010.0 - endLabelWidth);

    RangeValues rangeFromLocalDx(double localDx) {
      final clamped = localDx.clamp(thumbCenterMin, thumbCenterMax);
      final nextPercent =
          (clamped - thumbCenterMin) / (thumbCenterMax - thumbCenterMin);
      final value = 18 + nextPercent * (65 - 18);
      return RangeValues(18, value.clamp(18, 65));
    }

    return SizedBox(
      width: size.width,
      height: sheetHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(90 * scale),
                  topRight: Radius.circular(90 * scale),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
            ),
          ),
          Positioned(
            left: contentLeft,
            top: 0,
            width: artboardWidth,
            height: sheetHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _DesignRoundRect(
                  scale: scale,
                  left: 487,
                  top: y(1302),
                  width: 151,
                  height: 17,
                  color: const Color(0xFFCDCDCD),
                  radius: 7.5,
                ),
                _DesignText(
                  scale: scale,
                  left: 503,
                  top: y(1353),
                  width: 122,
                  height: 42,
                  text: 'Filter',
                  fontSize: 54,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2C2C2C),
                  textAlign: TextAlign.center,
                  strokeWidth: 0.25,
                ),
                _DesignRoundRect(
                  scale: scale,
                  left: 85,
                  top: y(1450),
                  width: 955,
                  height: 4,
                  color: const Color(0xFFE1E1E1),
                  radius: 0,
                ),
                _DesignText(
                  scale: scale,
                  left: 77,
                  top: y(1493),
                  width: 151,
                  height: 35,
                  text: 'Gender',
                  fontSize: 45,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2C2C2C),
                  strokeWidth: 0.22,
                ),
                _FilterOption(
                  scale: scale,
                  hitLeft: 99,
                  hitTop: y(1567),
                  boxLeft: 99,
                  boxTop: y(1576),
                  labelRectLeft: 165,
                  labelRectTop: y(1567),
                  labelRectWidth: 315,
                  textLeft: 280,
                  textTop: y(1583),
                  textWidth: 86,
                  textHeight: 32,
                  label: 'Male',
                  selected: selectedGenders.contains('Male'),
                  onTap: () => onGenderToggled('Male'),
                ),
                _FilterOption(
                  scale: scale,
                  hitLeft: 661,
                  hitTop: y(1567),
                  boxLeft: 661,
                  boxTop: y(1576),
                  labelRectLeft: 727,
                  labelRectTop: y(1567),
                  labelRectWidth: 316,
                  textLeft: 820,
                  textTop: y(1583),
                  textWidth: 131,
                  textHeight: 32,
                  label: 'Female',
                  selected: selectedGenders.contains('Female'),
                  onTap: () => onGenderToggled('Female'),
                ),
                _FilterOption(
                  scale: scale,
                  hitLeft: 99,
                  hitTop: y(1669),
                  boxLeft: 99,
                  boxTop: y(1678),
                  labelRectLeft: 165,
                  labelRectTop: y(1669),
                  labelRectWidth: 315,
                  textLeft: 220,
                  textTop: y(1685),
                  textWidth: 207,
                  textHeight: 39,
                  label: 'Non-binary',
                  selected: selectedGenders.contains('Non-binary'),
                  onTap: () => onGenderToggled('Non-binary'),
                ),
                _FilterOption(
                  scale: scale,
                  hitLeft: 661,
                  hitTop: y(1669),
                  boxLeft: 661,
                  boxTop: y(1678),
                  labelRectLeft: 727,
                  labelRectTop: y(1669),
                  labelRectWidth: 316,
                  textLeft: 801,
                  textTop: y(1686),
                  textWidth: 170,
                  textHeight: 38,
                  label: 'Everyone',
                  selected: selectedGenders.contains('Everyone'),
                  onTap: () => onGenderToggled('Everyone'),
                ),
                _DesignText(
                  scale: scale,
                  left: 76,
                  top: y(1829),
                  width: 81,
                  height: 42,
                  text: 'Age',
                  fontSize: 45,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2C2C2C),
                  strokeWidth: 0.2,
                ),
                _DesignText(
                  scale: scale,
                  left: 854,
                  top: y(1828),
                  width: 196,
                  height: 34,
                  text: '18 — 65+',
                  fontSize: 45,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2C2C2C),
                  textAlign: TextAlign.right,
                  strokeWidth: 0.2,
                ),
                Positioned(
                  left: sliderLeft * scale,
                  top: y(1911) * scale,
                  width: 901 * scale,
                  height: 101 * scale,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (details) {
                      final local = details.localPosition.dx / scale;
                      onAgeRangeChanged(rangeFromLocalDx(local));
                    },
                    onHorizontalDragStart: (details) {
                      final local = details.localPosition.dx / scale;
                      onAgeRangeChanged(rangeFromLocalDx(local));
                    },
                    onHorizontalDragUpdate: (details) {
                      final local = details.localPosition.dx / scale;
                      onAgeRangeChanged(rangeFromLocalDx(local));
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          width: 901 * scale,
                          height: 84 * scale,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(31.5 * scale),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF808080).withOpacity(0.1),
                                  blurRadius: 8 * scale,
                                  offset: Offset(12 * scale, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 13 * scale,
                          top: 6 * scale,
                          width: activeWidth * scale,
                          height: 52 * scale,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3D2D0),
                              borderRadius: BorderRadius.circular(25.5 * scale),
                            ),
                          ),
                        ),
                        for (final center in [thumbCenterMin, thumbCenter])
                          Positioned(
                            left: (center - thumbRadius) * scale,
                            top: 6 * scale,
                            width: 52 * scale,
                            height: 52 * scale,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6928C),
                                borderRadius:
                                    BorderRadius.circular(25.5 * scale),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                _DesignText(
                  scale: scale,
                  left: 134,
                  top: y(1988),
                  width: 30,
                  height: 23,
                  text: '18',
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF6C6C70),
                ),
                _DesignText(
                  scale: scale,
                  left: endLabelLeft,
                  top: y(1989),
                  width: endLabelWidth,
                  height: 23,
                  text: endLabel,
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF6C6C70),
                ),
                _GradientDesignButton(
                  scale: scale,
                  left: 319,
                  top: y(2075),
                  width: 488,
                  height: 155,
                  radius: 30,
                  enabled: true,
                  label: 'Confirm',
                  labelLeft: 475,
                  labelTop: y(2135),
                  labelWidth: 172,
                  labelHeight: 38,
                  fontSize: 48,
                  onTap: onConfirm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final double scale;
  final double hitLeft;
  final double hitTop;
  final double boxLeft;
  final double boxTop;
  final double labelRectLeft;
  final double labelRectTop;
  final double labelRectWidth;
  final double textLeft;
  final double textTop;
  final double textWidth;
  final double textHeight;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterOption({
    required this.scale,
    required this.hitLeft,
    required this.hitTop,
    required this.boxLeft,
    required this.boxTop,
    required this.labelRectLeft,
    required this.labelRectTop,
    required this.labelRectWidth,
    required this.textLeft,
    required this.textTop,
    required this.textWidth,
    required this.textHeight,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _DesignRoundRect(
          scale: scale,
          left: labelRectLeft,
          top: labelRectTop,
          width: labelRectWidth,
          height: 64,
          color: Colors.white,
          radius: 15,
        ),
        _DesignRoundRect(
          scale: scale,
          left: boxLeft,
          top: boxTop,
          width: 44,
          height: 44,
          color: Colors.transparent,
          radius: 7.5,
          border: Border.all(
            color: const Color(0xFFA55E66),
            width: 6 * scale,
          ),
        ),
        if (selected)
          _DesignRoundRect(
            scale: scale,
            left: boxLeft + 9,
            top: boxTop + 9,
            width: 26,
            height: 26,
            color: const Color(0xFFCE888F),
            radius: 7.5,
          ),
        _DesignText(
          scale: scale,
          left: textLeft,
          top: textTop,
          width: textWidth,
          height: textHeight,
          text: label,
          fontSize: 42,
          fontWeight: FontWeight.w300,
          color: const Color(0xFF2A2A2A),
          textAlign: TextAlign.center,
        ),
        Positioned(
          left: hitLeft * scale,
          top: hitTop * scale,
          width: 382 * scale,
          height: 70 * scale,
          child: Semantics(
            button: true,
            checked: selected,
            label: label,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}

class _EditCardSurface extends StatelessWidget {
  final String? selectedStatus;
  final VoidCallback onBack;
  final ValueChanged<String> onStatusSelected;

  const _EditCardSurface({
    required this.selectedStatus,
    required this.onBack,
    required this.onStatusSelected,
  });

  bool get _canPublish => selectedStatus != null;

  @override
  Widget build(BuildContext context) {
    return _DesignCanvas(
      backgroundColor: const Color(0xFFF3F4F4),
      builder: (context, scale) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            _DesignRoundRect(
              scale: scale,
              left: 0,
              top: 275,
              width: 1125,
              height: 2161,
              color: const Color(0xFFF3F4F4),
              radius: 0,
              border: Border(
                top: BorderSide(
                  color: const Color(0xFFDDDDDD),
                  width: 3 * scale,
                ),
              ),
            ),
            Positioned(
              left: 30 * scale,
              top: 126 * scale,
              width: 112 * scale,
              height: 132 * scale,
              child: Semantics(
                button: true,
                label: 'Back',
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onBack,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: const Color(0xFF2C2C2C),
                    size: 82 * scale,
                  ),
                ),
              ),
            ),
            _DesignText(
              scale: scale,
              left: 226,
              top: 170,
              width: 674,
              height: 49,
              text: 'Polish Your Profile Card',
              fontSize: 60,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2C2C2C),
              textAlign: TextAlign.center,
              strokeWidth: 0.35,
            ),
            _DesignText(
              scale: scale,
              left: 108,
              top: 374,
              width: 583,
              height: 53,
              text: 'Nickname：BunnyBelle',
              fontSize: 54,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2C2C2C),
              strokeWidth: 0.25,
            ),
            _DesignText(
              scale: scale,
              left: 108,
              top: 486,
              width: 220,
              height: 39,
              text: 'Interests',
              fontSize: 54,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2C2C2C),
              strokeWidth: 0.25,
            ),
            _EditChip(
              scale: scale,
              left: 75,
              top: 596,
              width: 351,
              textLeft: 108,
              textTop: 609,
              textWidth: 286,
              textHeight: 35,
              label: 'Food & Coffee',
            ),
            _EditChip(
              scale: scale,
              left: 456,
              top: 597,
              width: 443,
              textLeft: 488,
              textTop: 607,
              textWidth: 387,
              textHeight: 44,
              label: 'Reading & Learning',
            ),
            _EditChip(
              scale: scale,
              left: 75,
              top: 703,
              width: 479,
              textLeft: 107,
              textTop: 714,
              textWidth: 424,
              textHeight: 43,
              label: 'Lifestyle & Daily Chat',
            ),
            _DesignRoundRect(
              scale: scale,
              left: 0,
              top: 841,
              width: 1125,
              height: 4,
              color: const Color(0xFFE1E1E1),
              radius: 0,
            ),
            _DesignText(
              scale: scale,
              left: 114,
              top: 920,
              width: 161,
              height: 41,
              text: 'Status',
              fontSize: 54,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2C2C2C),
              strokeWidth: 0.25,
            ),
            for (final option in _EditStatusOptionData.items)
              _EditStatusOption(
                scale: scale,
                data: option,
                selected: selectedStatus == option.label,
                onTap: () => onStatusSelected(option.label),
              ),
            _DesignRoundRect(
              scale: scale,
              left: 0,
              top: 1740,
              width: 1125,
              height: 3,
              color: const Color(0xFFE1E1E1),
              radius: 0,
            ),
            _GradientDesignButton(
              scale: scale,
              left: 257,
              top: 2075,
              width: 611,
              height: 155,
              radius: 30,
              enabled: _canPublish,
              label: 'Save & Start Chatting',
              labelLeft: 326,
              labelTop: 2135,
              labelWidth: 470,
              labelHeight: 47,
              fontSize: 48,
              onTap: _canPublish ? onBack : null,
            ),
          ],
        );
      },
    );
  }
}

class _EditChip extends StatelessWidget {
  final double scale;
  final double left;
  final double top;
  final double width;
  final double textLeft;
  final double textTop;
  final double textWidth;
  final double textHeight;
  final String label;

  const _EditChip({
    required this.scale,
    required this.left,
    required this.top,
    required this.width,
    required this.textLeft,
    required this.textTop,
    required this.textWidth,
    required this.textHeight,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _DesignRoundRect(
          scale: scale,
          left: left,
          top: top,
          width: width,
          height: 64,
          color: Colors.white,
          radius: 30,
        ),
        _DesignText(
          scale: scale,
          left: textLeft,
          top: textTop,
          width: textWidth,
          height: textHeight,
          text: label,
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF2C2C2C),
          strokeWidth: 0.12,
        ),
      ],
    );
  }
}

class _EditStatusOptionData {
  final String label;
  final double top;
  final double height;
  final double textLeft;
  final double textTop;
  final double textWidth;
  final double textHeight;

  const _EditStatusOptionData({
    required this.label,
    required this.top,
    required this.height,
    required this.textLeft,
    required this.textTop,
    required this.textWidth,
    required this.textHeight,
  });

  static const items = [
    _EditStatusOptionData(
      label: 'I’m bored, let’s talk.',
      top: 1020,
      height: 63,
      textLeft: 115,
      textTop: 1035,
      textWidth: 389,
      textHeight: 42,
    ),
    _EditStatusOptionData(
      label: 'Just want someone to chill with.',
      top: 1135,
      height: 64,
      textLeft: 113,
      textTop: 1150,
      textWidth: 639,
      textHeight: 35,
    ),
    _EditStatusOptionData(
      label: 'Looking for friends to game with.',
      top: 1252,
      height: 64,
      textLeft: 115,
      textTop: 1262,
      textWidth: 657,
      textHeight: 44,
    ),
    _EditStatusOptionData(
      label: 'Here to share my hobbies & interests.',
      top: 1369,
      height: 64,
      textLeft: 115,
      textTop: 1383,
      textWidth: 753,
      textHeight: 43,
    ),
    _EditStatusOptionData(
      label: 'Need someone to listen & support.',
      top: 1485,
      height: 63,
      textLeft: 115,
      textTop: 1500,
      textWidth: 692,
      textHeight: 43,
    ),
    _EditStatusOptionData(
      label: "Let's chat about daily life.",
      top: 1602,
      height: 63,
      textLeft: 115,
      textTop: 1612,
      textWidth: 506,
      textHeight: 43,
    ),
  ];
}

class _EditStatusOption extends StatelessWidget {
  final double scale;
  final _EditStatusOptionData data;
  final bool selected;
  final VoidCallback onTap;

  const _EditStatusOption({
    required this.scale,
    required this.data,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _DesignRoundRect(
          scale: scale,
          left: 82,
          top: data.top,
          width: 976,
          height: data.height,
          color: selected ? const Color(0xFFEE9791) : Colors.white,
          radius: 30,
        ),
        _DesignText(
          scale: scale,
          left: data.textLeft,
          top: data.textTop,
          width: data.textWidth,
          height: data.textHeight,
          text: data.label,
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: selected ? Colors.white : const Color(0xFF2C2C2C),
          strokeWidth: selected ? 0.05 : 0.12,
        ),
        Positioned(
          left: 82 * scale,
          top: data.top * scale,
          width: 976 * scale,
          height: math.max(data.height * scale, 44),
          child: Semantics(
            button: true,
            selected: selected,
            label: data.label,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}

class _VipLimitDialog extends StatelessWidget {
  final VoidCallback onUpgrade;
  final VoidCallback onCancel;

  const _VipLimitDialog({
    required this.onUpgrade,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return _DesignCanvas(
      builder: (context, scale) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {},
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _DesignRoundRect(
                scale: scale,
                left: 143,
                top: 763,
                width: 840,
                height: 935,
                color: const Color(0xFFF2F2F2),
                radius: 45,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF808080).withOpacity(0.05),
                    blurRadius: 15 * scale,
                    offset: Offset(15 * scale, 0),
                  ),
                ],
              ),
              _DesignText(
                scale: scale,
                left: 290,
                top: 836,
                width: 544,
                height: 42,
                text: 'Come back tomorrow.',
                fontSize: 54,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF80576B),
                textAlign: TextAlign.center,
                strokeWidth: 0.25,
              ),
              _DesignRoundRect(
                scale: scale,
                left: 208,
                top: 930,
                width: 709,
                height: 3,
                color: const Color(0xFFE3E3E3),
                radius: 0,
              ),
              _DesignText(
                scale: scale,
                left: 213,
                top: 1018,
                width: 700,
                height: 241,
                text:
                    'You’ve reached your daily swipe\nlimit.\nUpgrade to VIP to unlock extra\nswipes today!',
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF80576B),
                textAlign: TextAlign.center,
                maxLines: 4,
                lineHeight: 1.35,
              ),
              _GradientDesignButton(
                scale: scale,
                left: 284,
                top: 1342,
                width: 557,
                height: 145,
                radius: 22.5,
                enabled: true,
                label: 'Upgrade to VIP',
                labelLeft: 353,
                labelTop: 1391,
                labelWidth: 419,
                labelHeight: 58,
                fontSize: 60,
                onTap: onUpgrade,
              ),
              Positioned(
                left: 289 * scale,
                top: 1512 * scale,
                width: 547 * scale,
                height: 90 * scale,
                child: Semantics(
                  button: true,
                  label: 'Cancel',
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onCancel,
                    child: Stack(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3DDE0),
                            borderRadius: BorderRadius.circular(22.5 * scale),
                          ),
                          child: const SizedBox.expand(),
                        ),
                        _DesignText(
                          scale: scale,
                          left: 199,
                          top: 26,
                          width: 148,
                          height: 37,
                          text: 'Cancel',
                          fontSize: 48,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF80576B),
                          textAlign: TextAlign.center,
                          strokeWidth: 0.2,
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
  }
}
