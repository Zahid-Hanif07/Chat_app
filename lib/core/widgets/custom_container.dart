import 'package:flutter/material.dart';
import 'package:chat_app/core/theme/app_colors.dart';

class CustomContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color color;
  final double borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? shadows;
  final Gradient? gradient;
  final AlignmentGeometry? alignment;
  final Clip clipBehavior;

  const CustomContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color = AppColors.surface,
    this.borderRadius = 16.0,
    this.border,
    this.shadows,
    this.gradient,
    this.alignment,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        gradient: gradient,
        boxShadow: shadows ?? [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
