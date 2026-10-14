import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';

const textFieldRadius = 16.0;
const iconSize = 35.0;
/* font sizes*/
const textSizeSmall = 12.0;
const textSizeSMedium = 14.0;
const textSizeMedium = 16.0;
const textSizeLargeMedium = 18.0;
const textSizeNormal = 20.0;
const textSizeMLarge = 22.0;
const textSizeLarge = 24.0;
const textSizeLarge1 = 28.0;
const textSizeXLarge = 30.0;
const textSizeXXLarge = 35.0;

enum FoodDateCategory { today, yesterday, other }

enum Gender {
  male,
  female,
  other,
}

final BoxShadow cardBoxShadow = BoxShadow(
    color: boxShadow.withValues(alpha: 0.08),
    blurRadius: 60,
    offset: const Offset(0, 4));

final BoxShadow cardBoxShadow2 = BoxShadow(
    color: gradient1.withValues(alpha: 0.20),
    blurRadius: 32,
    offset: const Offset(4, 12));

final Shader linearGradient = const LinearGradient(
  colors: <Color>[gradient1, gradient2],
).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

Widget text(
  String? text, {
  var fontSize = textSizeLargeMedium,
  Color? textColor,
  var fontFamily,
  var isCentered = false,
  var maxLine = 1,
  var latterSpacing = 0.5,
  bool textAllCaps = false,
  var isLongText = false,
  bool lineThrough = false,
}) {
  return Text(
    textAllCaps ? text!.toUpperCase() : text!,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: textColor ?? colorPrimary,
      height: 1.5,
      letterSpacing: latterSpacing,
      decoration:
          lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    ),
  );
}

Widget commonCacheImageWidget(String? url, double height,
    {double? width, BoxFit? fit, Color? color}) {
  if (url.validate().startsWith('http')) {
    if (isMobile) {
      return CachedNetworkImage(
        placeholder:
            placeholderWidgetFn() as Widget Function(BuildContext, String)?,
        imageUrl: '$url',
        height: height,
        width: width,
        color: color,
        fit: fit ?? BoxFit.cover,
        errorWidget: (_, __, ___) {
          return SizedBox(height: height, width: width);
        },
      );
    } else {
      return Image.network(url!,
          height: height, width: width, fit: fit ?? BoxFit.cover);
    }
  } else {
    return Image.asset(url!,
        height: height, width: width, fit: fit ?? BoxFit.cover);
  }
}

Widget? Function(BuildContext, String) placeholderWidgetFn() =>
    (_, s) => placeholderWidget();

Widget placeholderWidget() =>
    Image.asset('assets/placeholder.jpg', fit: BoxFit.cover);

PreferredSizeWidget fdCommonAppBarWidget(
  BuildContext context, {
  String? titleText,
  Widget? actionWidget,
  Widget? actionWidget2,
  Widget? actionWidget3,
  Widget? leadingWidget,
  Color? backgroundColor,
  bool? isTitleCenter,
  bool isback = true,
}) {
  Color bgColor =
      getIt<ThemeController>().isDarkMode ? darkPrimary : Colors.white;
  return AppBar(
    centerTitle: isTitleCenter ?? false,
    backgroundColor: backgroundColor ?? bgColor,
    titleSpacing: 0,
    leading: isback
        ? IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.router.maybePop();
            },
          )
        : leadingWidget,
    actions: [
      actionWidget ?? const SizedBox(),
      actionWidget2 ?? const SizedBox(),
      actionWidget3 ?? const SizedBox()
    ],
    title: Text(
      titleText ?? "",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold, fontFamily: 'Urbanist', fontSize: 20),
    ),
    elevation: 0.0,
  );
}

InputDecoration inputDecoration(
  BuildContext context, {
  String? prefixIcon,
  IconData? prefixIconData,
  String? suffixIcon,
  IconData? suffixIconData,
  Widget? suffixWidget,
  String? labelText,
  double? borderRadius,
  String? hintText,
  bool? isSvg,
  Color? fillColor,
  Color? inputBorderColor,
  Color? hintColor,
  Color? prefixIconColor,
  double? leftContentPadding,
  double? rightContentPadding,
  double? topContentPadding,
  double? bottomContentPadding,
  double? borderWidth,
}) {
  return InputDecoration(
    // prefixIconColor: prefixIconColor,
    counterText: "",

    contentPadding: EdgeInsets.fromLTRB(
        leftContentPadding ?? 20,
        topContentPadding ?? 20,
        rightContentPadding ?? 20,
        bottomContentPadding ?? 20),
    labelText: labelText,
    labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: hintColor ?? textColor.withValues(alpha: 0.6),
        fontWeight: FontWeight.w400,
        fontFamily: ''),
    alignLabelWithHint: true,
    hintText: hintText.validate(),
    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: hintColor ?? textColor.withValues(alpha: 0.6),
        fontWeight: FontWeight.w400,
        fontFamily: ''),
    isDense: true,
    prefixIcon: prefixIcon != null
        ? prefixIconData != null
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Icon(
                  prefixIconData,
                  color: prefixIconColor ?? textColor,
                  size: 18,
                  blendMode: BlendMode.srcIn,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: isSvg == null
                    ? SvgPicture.asset(
                        prefixIcon,
                        width: 18,
                        height: 18,
                        colorFilter: ColorFilter.mode(
                            prefixIconColor ?? textColor, BlendMode.srcIn),
                      )
                    : Image.asset(
                        prefixIcon,
                        width: 24,
                        height: 24,
                      ),
              )
        : null,
    prefixIconConstraints: const BoxConstraints(
      minWidth: 20,
      minHeight: 20,
    ),
    suffixIconConstraints: const BoxConstraints(
      minWidth: 20,
      minHeight: 20,
    ),
    suffixIcon: suffixIcon != null
        ? suffixIconData != null
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Icon(
                  suffixIconData,
                  color: prefixIconColor ?? textColor,
                  size: 18,
                  blendMode: BlendMode.srcIn,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: isSvg == null
                    ? SvgPicture.asset(
                        suffixIcon,
                        width: 18,
                        height: 18,
                        colorFilter: ColorFilter.mode(
                            prefixIconColor ?? textColor, BlendMode.srcIn),
                      )
                    : Image.asset(
                        suffixIcon,
                        width: 24,
                        height: 24,
                      ),
              )
        : suffixWidget,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(
          color: inputBorderColor ?? borderColor, width: borderWidth ?? 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(
          color: inputBorderColor ?? borderColor, width: borderWidth ?? 1.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: borderWidth ?? 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: borderWidth ?? 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(
        color: Colors.red, size: 13, fontFamily: AppTheme.fontFamily),
    filled: true,
    fillColor: fillColor ?? Colors.white,
  );
}

// extension Ext on BuildContext {
//   ThemeData get theme => Theme.of(this);

//   double get w => MediaQuery.of(this).size.width;

//   double get h => MediaQuery.of(this).size.height;
// }
