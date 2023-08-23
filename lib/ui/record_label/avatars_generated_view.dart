import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:intheloopapp/domains/generation_bloc/generation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:share_plus/share_plus.dart';

class AvatarsGeneratedView extends StatefulWidget {
  const AvatarsGeneratedView({
    required this.imageUrls,
    super.key,
  });

  final List<String> imageUrls;

  @override
  State<AvatarsGeneratedView> createState() => _AvatarsGeneratedViewState();
}

class _AvatarsGeneratedViewState extends State<AvatarsGeneratedView> {
  int _focusedIndex = 0;
  bool _shareLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth - 64;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              widget.imageUrls[_focusedIndex],
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 50,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          context.pop();
                          context.read<GenerationBloc>().add(
                                const ResetGeneration(),
                              );
                        },
                        child: const Icon(
                          CupertinoIcons.xmark,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: imageSize,
                child: ScrollSnapList(
                  onItemFocus: (index) {
                    setState(() {
                      _focusedIndex = index;
                    });
                  },
                  itemSize: imageSize,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrls[index],
                        width: imageSize,
                        height: imageSize,
                      ),
                    );
                  },
                  itemCount: widget.imageUrls.length,
                  dynamicItemSize: true,
                  // dynamicSizeEquation: customEquation, //optional
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 32,
                  ),
                  child: CupertinoButton.filled(
                    onPressed: () {
                      if (_shareLoading) return;
                      setState(() {
                        _shareLoading = true;
                      });
                      try {
                        Future.wait(
                          widget.imageUrls.map((url) async {
                            final imageData =
                                await DefaultCacheManager().getSingleFile(url);
                            return XFile(imageData.path);
                          }).toList(),
                        ).then(Share.shareXFiles);
                      } catch (e, s) {
                        logger.error(
                          'sharing avatar failed',
                          error: e,
                          stackTrace: s,
                        );
                      } finally {
                        setState(() {
                          _shareLoading = false;
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: _shareLoading
                        ? const CupertinoActivityIndicator()
                        : const Text(
                            'Share',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 32,
                  ),
                  child: CupertinoButton(
                    onPressed: () {
                      try {
                        ImageDownloader.downloadImage(
                          widget.imageUrls[_focusedIndex],
                        );
                      } catch (e, s) {
                        logger.error(
                          'downloading avatar failed',
                          error: e,
                          stackTrace: s,
                        );
                      }
                    },
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    child: const Text(
                      'Download',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 34,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
