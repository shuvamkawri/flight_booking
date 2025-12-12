import 'package:flutter/material.dart';

class TextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  // Captions
  static const TextStyle caption = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    height: 1.2,
  );

  // Buttons
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // Helper methods for theme
  static TextTheme getTextTheme(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryColor = isDark ? Colors.white70 : Colors.black87;
    final disabledColor = isDark ? Colors.white54 : Colors.black54;

    return TextTheme(
      displayLarge: heading1.copyWith(color: textColor),
      displayMedium: heading2.copyWith(color: textColor),
      displaySmall: heading3.copyWith(color: textColor),
      headlineMedium: heading4.copyWith(color: textColor),
      titleLarge: heading4.copyWith(color: textColor),
      titleMedium: bodyLarge.copyWith(fontWeight: FontWeight.w600, color: textColor),
      titleSmall: bodyMedium.copyWith(fontWeight: FontWeight.w600, color: textColor),
      bodyLarge: bodyLarge.copyWith(color: secondaryColor),
      bodyMedium: bodyMedium.copyWith(color: secondaryColor),
      bodySmall: bodySmall.copyWith(color: disabledColor),
      labelLarge: labelLarge.copyWith(color: textColor),
      labelMedium: labelMedium.copyWith(color: textColor),
      labelSmall: labelSmall.copyWith(color: textColor),
    );
  }

  // Custom text styles for specific use cases
  static TextStyle flightPrice(BuildContext context) {
    return heading2.copyWith(
      color: Theme.of(context).primaryColor,
    );
  }

  static TextStyle flightTime(BuildContext context) {
    return heading3.copyWith(
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle flightAirportCode(BuildContext context) {
    return bodyLarge.copyWith(
      fontWeight: FontWeight.w600,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle flightDuration(BuildContext context) {
    return bodySmall.copyWith(
      color: Theme.of(context).disabledColor,
    );
  }

  static TextStyle flightAirline(BuildContext context) {
    return bodyLarge.copyWith(
      fontWeight: FontWeight.w600,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle flightDetails(BuildContext context) {
    return bodySmall.copyWith(
      color: Theme.of(context).disabledColor,
    );
  }

  static TextStyle passengerName(BuildContext context) {
    return bodyLarge.copyWith(
      fontWeight: FontWeight.w600,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle passengerDetails(BuildContext context) {
    return bodySmall.copyWith(
      color: Theme.of(context).disabledColor,
    );
  }

  static TextStyle bookingReference(BuildContext context) {
    return bodyMedium.copyWith(
      fontFamily: 'monospace',
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle barcodeText(BuildContext context) {
    return bodySmall.copyWith(
      fontFamily: 'monospace',
      color: Theme.of(context).disabledColor,
    );
  }

  // Gradient text style
  static TextStyle gradientText(BuildContext context) {
    return heading2.copyWith(
      foreground: Paint()
        ..shader = LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColorLight,
          ],
        ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
    );
  }

  // Text with shadow
  static TextStyle textWithShadow(BuildContext context) {
    return heading2.copyWith(
      color: Colors.white,
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.3),
          offset: const Offset(2, 2),
          blurRadius: 4,
        ),
      ],
    );
  }

  // Error text
  static TextStyle errorText(BuildContext context) {
    return bodyMedium.copyWith(
      color: Theme.of(context).colorScheme.error,
    );
  }

  // Success text
  static TextStyle successText(BuildContext context) {
    return bodyMedium.copyWith(
      color: Colors.green,
    );
  }

  // Warning text
  static TextStyle warningText(BuildContext context) {
    return bodyMedium.copyWith(
      color: Colors.orange,
    );
  }

  // Info text
  static TextStyle infoText(BuildContext context) {
    return bodyMedium.copyWith(
      color: Theme.of(context).primaryColor,
    );
  }
}

// Text theme extensions
extension TextThemeExtension on BuildContext {
  TextTheme get textTheme => TextStyles.getTextTheme(this);

  TextStyle get heading1 => TextStyles.heading1.copyWith(
    color: Theme.of(this).textTheme.displayLarge?.color,
  );

  TextStyle get heading2 => TextStyles.heading2.copyWith(
    color: Theme.of(this).textTheme.displayMedium?.color,
  );

  TextStyle get heading3 => TextStyles.heading3.copyWith(
    color: Theme.of(this).textTheme.displaySmall?.color,
  );

  TextStyle get heading4 => TextStyles.heading4.copyWith(
    color: Theme.of(this).textTheme.headlineMedium?.color,
  );

  TextStyle get bodyLarge => TextStyles.bodyLarge.copyWith(
    color: Theme.of(this).textTheme.bodyLarge?.color,
  );

  TextStyle get bodyMedium => TextStyles.bodyMedium.copyWith(
    color: Theme.of(this).textTheme.bodyMedium?.color,
  );

  TextStyle get bodySmall => TextStyles.bodySmall.copyWith(
    color: Theme.of(this).textTheme.bodySmall?.color,
  );

  TextStyle get flightPrice => TextStyles.flightPrice(this);
  TextStyle get flightTime => TextStyles.flightTime(this);
  TextStyle get flightAirportCode => TextStyles.flightAirportCode(this);
  TextStyle get flightDuration => TextStyles.flightDuration(this);
  TextStyle get flightAirline => TextStyles.flightAirline(this);
  TextStyle get flightDetails => TextStyles.flightDetails(this);
  TextStyle get passengerName => TextStyles.passengerName(this);
  TextStyle get passengerDetails => TextStyles.passengerDetails(this);
  TextStyle get bookingReference => TextStyles.bookingReference(this);
  TextStyle get barcodeText => TextStyles.barcodeText(this);
}