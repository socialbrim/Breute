import 'package:cached_network_image/cached_network_image.dart';
import '../../models/StoryModel.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// ignore: must_be_immutable
class StoryScreen extends StatefulWidget {
  List<StoryModel> stories;
  int currentIndex;
  StoryScreen({this.stories, this.currentIndex});
  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  PageController _pageController;

  AnimationController _animationController;

  @override
  void initState() {
    _pageController = PageController();
    _animationController = AnimationController(vsync: this);
    final StoryModel firstStory = widget.stories[widget.currentIndex];
    _loadStory(story: firstStory, animateToPage: false);
    super.initState();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.stop();
        _animationController.reset();
        setState(() {
          if (widget.currentIndex + 1 < widget.stories.length) {
            widget.currentIndex += 1;
            _loadStory(story: widget.stories[widget.currentIndex]);
          } else {
            // Out of bounds - loop story
            // You can also Navigator.of(context).pop() here
            Navigator.of(context).pop();
            widget.currentIndex = 0;
            _loadStory(story: widget.stories[widget.currentIndex]);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();

    super.dispose();
  }

  void _loadStory({StoryModel story, bool animateToPage = true}) {
    _animationController.stop();
    _animationController.reset();
    _animationController.duration = Duration(seconds: 10);
    _animationController.forward();
    if (animateToPage) {
      _pageController.animateToPage(
        widget.currentIndex,
        duration: Duration(microseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onTapDown(TapDownDetails details, StoryModel quote) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (widget.currentIndex - 1 >= 0) {
          widget.currentIndex -= 1;
          _loadStory(story: widget.stories[widget.currentIndex]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (widget.currentIndex + 1 < widget.stories.length) {
          widget.currentIndex += 1;
          _loadStory(story: widget.stories[widget.currentIndex]);
        } else {
          Navigator.of(context).pop();
          widget.currentIndex = 0;
          _loadStory(story: widget.stories[widget.currentIndex]);
        }
      });
    } else {
      _animationController.forward();
    }
  }

  bool pauseButton = false;

  @override
  Widget build(BuildContext context) {
    final StoryModel quote = widget.stories[widget.currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: GestureDetector(
            onTapDown: (details) {
              _onTapDown(details, quote);
              setState(() {
                pauseButton = false;
              });
            },
            onLongPress: () {
              _animationController.stop();
              setState(() {
                pauseButton = true;
              });
            },
            child: Stack(
              children: [
                PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemCount: widget.stories.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Center(
                          child: CachedNetworkImage(
                            imageUrl:
                                widget.stories[widget.currentIndex].imageurl,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 60,
                          left: 300,
                          right: 10,
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        pauseButton
                            ? Container(
                                child: Center(
                                  child: Icon(
                                    MdiIcons.play,
                                    color: Colors.white,
                                    size: 80,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    );
                  },
                ),
                Positioned(
                  top: 40.0,
                  left: 10.0,
                  right: 10.0,
                  child: Row(
                    children: widget.stories
                        .asMap()
                        .map((i, e) {
                          return MapEntry(
                            i,
                            AnimatedBar(
                              animController: _animationController,
                              position: i,
                              currentIndex: widget.currentIndex,
                            ),
                          );
                        })
                        .values
                        .toList(),
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

class AnimatedBar extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const AnimatedBar({
    Key key,
    @required this.animController,
    @required this.position,
    @required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                        animation: animController,
                        builder: (context, child) {
                          return _buildContainer(
                            constraints.maxWidth * animController.value,
                            Colors.white,
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildContainer(double width, Color color) {
    return Container(
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}
