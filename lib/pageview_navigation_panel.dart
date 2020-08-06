library pageview_navigation_panel;

import 'package:flutter/material.dart';

class NavigationPanel extends StatefulWidget {

  /// used for notifying about page changes
  final ValueNotifier<double> currentPageNotifier;
  /// pageController of [PageView] for which this [NavigationPanel] is used
  final PageController pageController;
  /// widgets to be placed as the children of the buttons ([buttonChildren.length] should equal the number of pages of the [PageView])
  final List<Widget> buttonChildren;

  final double panelHeight;
  final Color panelColor;
  final double buttonWidth;
  final double buttonHeight;
  final Color buttonColor;
  final bool indicatorAtTop;
  final Color indicatorColor;
  final double indicatorPadding;

  /// [currentPageNotifier] used for notifying about page changes
  /// [pageController] pageController of [PageView] for which this [NavigationPanel] is used
  /// [buttonChildren] widgets to be placed as the children of the buttons ([buttonChildren.length] should equal the number of pages of the [PageView])
  /// [panelHeight] the height of the [NavigationPanel]
  /// [buttonWidth] the width of the buttons
  /// [buttonHeight] the height of the buttons
  /// [buttonColor] the background color of the buttons
  /// [indicatorAtTop] indicates, whether the currentPage indicator will be displayed at the top of the [NavigationPanel] or bottom
  /// [indicatorColor] the color of the indicator
  /// [indicatorPadding] the padding between the buttons and the indicator
  /// [panelColor] background color of the [NavigationPanel]
  const NavigationPanel({
    Key key,
    @required this.currentPageNotifier,
    @required this.pageController,
    @required this.buttonChildren,
    this.panelHeight : 60.0,
    this.panelColor : Colors.blue,
    this.buttonWidth : 50.0,
    this.buttonHeight : 50.0,
    this.buttonColor : Colors.white10,
    this.indicatorAtTop : true,
    this.indicatorColor : Colors.white,
    this.indicatorPadding : 5.0,
  }) : assert(currentPageNotifier != null),
        assert(pageController != null),
        assert(buttonChildren != null && buttonChildren.length > 0),
        super(key: key);


  @override
  State<StatefulWidget> createState() => new _NavigationPanelState();

}

class _NavigationPanelState extends State<NavigationPanel> with SingleTickerProviderStateMixin {

  /// Animation controller used for the indicator animation
  AnimationController _animationController;

  /// current page of PageView
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: ((1/widget.buttonChildren.length) * 100).toInt()),// page takes 1 sec -> should be (1/views.length)secs
      upperBound: widget.buttonChildren.length.toDouble() - 1.0,
    );

    _currentPage = widget.currentPageNotifier.value;
    widget.currentPageNotifier.addListener(_handlePageChange);
  }

  @override
  void dispose() {
    // clean listener
    widget.currentPageNotifier.removeListener(_handlePageChange);

    super.dispose();
  }

  /// Listener for the ValueNotifier
  /// updates [_currentPage] and starts animation of indicator
  void _handlePageChange() {
    _currentPage = widget.currentPageNotifier.value;

    _animationController.animateTo(_currentPage);
  }

  /// method for building the "button" of the NavigationPanel
  Widget _buildViewElement(Widget view) {
    return InkWell(
      child: Container(
        width: widget.buttonWidth,
        height: widget.buttonHeight,
        color: widget.buttonColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: view,
          ),
        ),
      ),
      onTap: () {
        widget.pageController.animateToPage(widget.buttonChildren.indexOf(view), duration: Duration(seconds: 1), curve: Curves.ease);
      },
    );
  }

  /// calculates the distance between two buttons
  /// there are #buttons + 1 spaces between the buttons and the border
  /// -> due to spaceEvenly each of these spaces has the same width
  double _getDistanceBetweenElements(double maxWidth) {
    double totalBtnLength = widget.buttonWidth * widget.buttonChildren.length;
    return (maxWidth - totalBtnLength) / (widget.buttonChildren.length + 1);
  }

  /// method for building the indicator
  /// essentially just a Container wrapped by an AnimationBuilder for the Transform
  /// and an offset to skip the space between the left border and the first button
  Widget _buildIndicator(double maxWidth) {
    return Padding(
      padding: EdgeInsets.only(left: _getDistanceBetweenElements(maxWidth)),
      child: AnimatedBuilder(
        animation: _animationController,
        child: Container(height: 5, width: widget.buttonWidth, color: widget.indicatorColor,),
        builder: (context, child) => Transform.translate(
          offset: Offset(_animationController.value * (_getDistanceBetweenElements(maxWidth) + widget.buttonWidth), 0),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.panelHeight,
      color: widget.panelColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(widget.indicatorAtTop)
            _buildIndicator(MediaQuery.of(context).size.width),
          Padding(
            padding: EdgeInsets.only(top: (widget.indicatorAtTop ? 5 : 0), bottom: (widget.indicatorAtTop ? 0 : 5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.buttonChildren.map((e) => _buildViewElement(e)).toList(),
            ),
          ),
          if(!widget.indicatorAtTop)
            _buildIndicator(MediaQuery.of(context).size.width),
        ],
      ),
    );
  }


}