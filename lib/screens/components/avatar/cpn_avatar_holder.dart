import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sleer/config/config_api_routes.dart';
import 'package:sleer/config/config_images.dart';

class CpnAvatarHolder extends StatefulWidget {
  final double? size;
  final String? pathImage;
  final void Function()? onTap;

  const CpnAvatarHolder({
    super.key,
    this.size,
    this.pathImage,
    this.onTap,
  });

  @override
  State<CpnAvatarHolder> createState() => CpnAvatarHolderState();
}

class CpnAvatarHolderState extends State<CpnAvatarHolder> {
  String? _pathImage;

  @override
  void initState() {
    super.initState();
    _pathImage = widget.pathImage;
  }

  void updateImage(String pathImage) {
    debugPrint("updateImage");
    setState(() {
      _pathImage = pathImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLocalFile = _pathImage != null && File(_pathImage!).existsSync();
    debugPrint('Path Image: $_pathImage');
    debugPrint('Is Local File: $isLocalFile');
    return ClipOval(
      child: InkWell(
        onTap: widget.onTap,
        child: _pathImage != null
            ? isLocalFile
                ? Image.file(
                    File(_pathImage!),
                    height: widget.size ?? 50,
                    width: widget.size ?? 50,
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: '${ConfigApiRoutes.baseURL}$_pathImage',
                    height: widget.size ?? 50,
                    width: widget.size ?? 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )
            : SvgPicture.asset(
                ConfigImages.avatarHolder,
                height: widget.size ?? 50,
                width: widget.size ?? 50,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
