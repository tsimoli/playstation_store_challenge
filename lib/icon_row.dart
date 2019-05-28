import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconRow extends StatefulWidget {
  final Function setInitAnimationReady;
  final Color iconColor;
  final double currentPage;
  const IconRow(
      {Key key, this.setInitAnimationReady, this.iconColor, this.currentPage})
      : super(key: key);

  @override
  _IconRowState createState() => _IconRowState();
}

class _IconRowState extends State<IconRow> with SingleTickerProviderStateMixin {
  AnimationController _logoAnimationController;
  Animation<double> _logoSizeAnimation;
  Animation<double> _logoOpacityAnimation;
  Animation<Alignment> _logoAlignmentAnimation;
  Animation<double> _menuIconsOpacityAnimation;
  bool isReady = false;

  final _iconSize = 35.0;

  @override
  void initState() {
    super.initState();

    _logoAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));

    _logoSizeAnimation = Tween<double>(begin: 100, end: _iconSize).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Interval(
          0.7,
          1,
          curve: Curves.easeInOut,
        ),
      ),
    )..addListener(() {
        setState(() {});
      });

    _logoOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Interval(
          0,
          0.5,
          curve: Curves.easeInOut,
        ),
      ),
    )..addListener(() {
        setState(() {});
      });
    _logoAlignmentAnimation =
        Tween<Alignment>(begin: Alignment.center, end: Alignment.topCenter)
            .animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Interval(
          0.7,
          1,
          curve: Curves.easeInOut,
        ),
      ),
    )..addListener(() {
                setState(() {});
              });

    _menuIconsOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Interval(
          0.8,
          1,
          curve: Curves.easeInOut,
        ),
      ),
    )..addListener(() {
        setState(() {});
      });
    _logoAnimationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        widget.setInitAnimationReady();
        setState(() {
          isReady = true;
        });
      }
    });
    _logoAnimationController.forward();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: _logoAlignmentAnimation.value,
          child: Opacity(
            opacity: _logoOpacityAnimation.value,
            child: Icon(
              FontAwesomeIcons.playstation,
              color: widget.iconColor,
              size: isReady
                  ? _iconSize -
                      (10 *
                          (widget.currentPage > 0
                              ? widget.currentPage
                              : -widget.currentPage))
                  : _logoSizeAnimation.value,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Opacity(
            opacity: _menuIconsOpacityAnimation.value,
            child: Align(
              alignment: Alignment.topLeft,
              child: Icon(
                FontAwesomeIcons.bars,
                color: widget.iconColor,
                size: _iconSize,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Opacity(
            opacity: _menuIconsOpacityAnimation.value,
            child: Align(
              alignment: Alignment.topRight,
              child: Icon(
                FontAwesomeIcons.solidComment,
                color: widget.iconColor,
                size: _iconSize,
              ),
            ),
          ),
        )
      ],
    );
  }
}
