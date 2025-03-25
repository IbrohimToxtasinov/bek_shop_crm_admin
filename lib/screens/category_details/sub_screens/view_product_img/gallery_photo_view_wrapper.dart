import 'package:bek_shop/screens/widgets/buttons/main_back_button.dart';
import 'package:bek_shop/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  final String productImage;

  const GalleryPhotoViewWrapper({super.key, required this.productImage});

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  Offset _offset = Offset.zero;

  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this)
      ..addListener(() {
        setState(() {
          _offset = _animation.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _offset += details.delta;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_offset.dy > 100 || _offset.dx.abs() > 100) {
      Navigator.pop(context);
    } else {
      _animation = Tween<Offset>(begin: _offset, end: Offset.zero).animate(_controller);
      _controller.forward(from: 0.0);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            GestureDetector(
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
              onHorizontalDragUpdate: _onVerticalDragUpdate,
              onHorizontalDragEnd: _onVerticalDragEnd,
              child: Center(
                child: Transform.translate(
                  offset: _offset,
                  child: PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(widget.productImage),
                        initialScale: PhotoViewComputedScale.contained,
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 10,
                        heroAttributes: PhotoViewHeroAttributes(tag: widget.productImage),
                        errorBuilder:
                            (context, error, stackTrace) => PhotoView(
                              imageProvider: const AssetImage("assets/img_2.png"),
                              minScale: PhotoViewComputedScale.contained,
                              maxScale:
                                  PhotoViewComputedScale.covered * 2, // adjust maxScale if needed
                            ),
                      );
                    },
                    onPageChanged: _onPageChanged,
                    itemCount: 1,
                    loadingBuilder: (context, event) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.cFFC34A),
                      );
                    },
                  ),
                ),
              ),
            ),
            const Positioned(top: 60.0, left: 16.0, child: MainBackButton()),
          ],
        ),
      ),
    );
  }
}
