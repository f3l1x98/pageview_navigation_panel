# pageview_navigation_panel

Widget for displaying the current page of a PageView and navigating said PageView using buttons.

## Example

![](demo/demo.gif)

```dart
import 'package:flutter/material.dart';
import 'package:pageview_navigation_panel/pageview_navigation_panel.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => new _HomePageState();
}

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final PageController _pageController = new PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<double>(0.0);


  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      _currentPageNotifier.value = _pageController.page;
    });
  }

  Widget _buildNavigationItem(String text, IconData icon) {
    return Column(
      children: [
        Icon(icon),
        Text('$text', style: Theme.of(context).textTheme.button.copyWith(fontSize: 16, fontWeight: FontWeight.bold),),
      ],
    );
  }

  Widget _buildViewWidget(String text) {
    return Center(
      child: Text('$text'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 50,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 180,
                child: PageView(
                  controller: _pageController,
                  children: [
                    _buildViewWidget("View Widget 1"),
                    _buildViewWidget("View Widget 2"),
                    _buildViewWidget("View Widget 3"),
                    _buildViewWidget("View Widget 4"),
                  ],
                ),
              ),
              NavigationPanel(
                currentPageNotifier: _currentPageNotifier,
                pageController: _pageController,
                panelHeight: 100,
                buttonWidth: 80.0,
                buttonHeight: 60.0,
                indicatorColor: Theme.of(context).selectedRowColor,
                buttonChildren: [
                  _buildNavigationItem('View1', Icons.looks_one),
                  _buildNavigationItem('View2', Icons.looks_two),
                  _buildNavigationItem('View3', Icons.looks_3),
                  _buildNavigationItem('View4', Icons.looks_4),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```
