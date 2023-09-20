import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:xyz_utils/gallery.dart';

class PhotoViewerPage extends StatefulWidget {
  final List<String> urls;
  final List<Object> tags;
  final int index;
  const PhotoViewerPage({
    super.key,
    required this.urls,
    required this.index,
    required this.tags,
  }) : assert(tags.length == urls.length);

  @override
  State<StatefulWidget> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<PhotoViewerPage> {
  late PageController pageController;
  int index = 0;

  @override
  void initState() {
    super.initState();

    index = widget.index;
    pageController = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.urls;
    return Scaffold(
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: pageController,
            backgroundDecoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            scrollPhysics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            onPageChanged: (i) => setState(() {
              index = i;
            }),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(urls[index]),
                initialScale: PhotoViewComputedScale.contained,
                minScale: 0.1,
                maxScale: 10.0,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: widget.tags[index]),
              );
            },
            itemCount: urls.length,
            loadingBuilder: (context, event) => Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : ((event.expectedTotalBytes != null &&
                              event.expectedTotalBytes! > 0)
                          ? (event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!)
                          : 0),
                ),
              ),
            ),
          ),
          Positioned(
            top: Theme.of(context).useMaterial3
                ? MediaQuery.of(context).viewPadding.top
                : 0,
            left: 0,
            right: 0,
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text('${index + 1} / ${urls.length}'),
              actions: [
                IconButton(
                  onPressed: () => download(context),
                  icon: const Icon(
                    Icons.download,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  download(BuildContext context) async {
    final i = pageController.page?.toInt() ?? -1;
    if (i < 0 || i >= widget.urls.length) {
      return;
    }
    String url = widget.urls[i];
    final r = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download'),
        content:
            const Text('Do you want to download this image to your device?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Yes',
            ),
          ),
        ],
      ),
    );
    if (r != true || !context.mounted) {
      return;
    }
    downloadImage(url);
  }
}

gotoSinglePhotoViewPage(BuildContext context, String url, String tag) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PhotoViewerPage(urls: [url], index: 0, tags: [tag]),
    ),
  );
}
