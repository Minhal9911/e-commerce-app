import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AppBottomSheet {
  AppBottomSheet._(); // prevent instantiation

  static Future<T?> show<T>(
      BuildContext context, {
        required Widget child,
        bool isScrollControlled = true,
        bool enableDrag = true,
        bool showCloseButton = true,
      }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      barrierColor: const Color.fromARGB(124, 63, 72, 81),
      elevation: 0,
      builder: (sheetContext) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // CLOSE BUTTON
              if (showCloseButton)
                InkWell(
                  onTap: () => Navigator.pop(sheetContext),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 80.h, bottom: 20.h),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ),

              // CONTENT CONTAINER
              Material(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Container(
                  padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 2.h),
                  width: MediaQuery.of(sheetContext).size.width,
                  child: SafeArea(
                    top: false,
                    child: child,
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