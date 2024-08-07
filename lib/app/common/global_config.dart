import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore_for_file: comment_references

class GlobalConfig {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  GlobalConfig._();

  // Info about the app.

  /// Returns the title of the MaterialApp.
  static String title(BuildContext context) => (context as Element).findAncestorWidgetOfExactType<MaterialApp>()!.title;

  /// The max dp width used for layout content on the screen in the available
  /// body area.
  ///
  /// Wider content gets growing side padding, kind of like on most
  /// web pages when they are used on super wide screen. This is typically used
  /// pages in the example apps that use content that is width constrained,
  /// typically via the [PageBody] screen content wrapper widget.
  static const double maxBodyWidth = 1000;

  /// Breakpoint needed to show second panel in side-by-side view for the
  /// page view.
  ///
  /// This is available content layout width, not media size!
  ///
  /// This min width was chosen because it gives at least the primary, secondary
  /// and tertiary colors in one Wrap row on panels Input Colors and Seeded
  /// ColorScheme, also when the side-by-side code view appears.
  static const double sideBySideViewBreakpoint = 760;

  /// The minimum media size needed for desktop/large tablet menu view,
  /// this is media size.
  static const double desktopWidthBreakpoint = 1700;

  /// A medium sized desktop, in panel view we switch to vertical on
  /// left and right side, one for each theme topic panel.
  ///
  /// This is a media size breakpoint.
  static const double mediumDesktopWidthBreakpoint = 1079;

  /// This breakpoint is only used to further increase margins and insets on
  /// very large desktops.
  static const double bigDesktopWidthBreakpoint = 2800;

  /// The minimum media width treated as a phone device in this app.
  static const double phoneWidthBreakpoint = 600;

  /// The minimum media height treated as a phone device in this app.
  static const double phoneHeightBreakpoint = 700;

  /// Edge insets and margins for phone breakpoint size.
  static const double edgeInsetsPhone = 8;

  /// Edge insets and margins for tablet breakpoint size.
  static const double edgeInsetsTablet = 12;

  /// Edge insets and margins for desktop and medium desktop breakpoint sizes.
  static const double edgeInsetsDesktop = 18;

  /// Edge insets and margins for big desktop breakpoint size.
  static const double edgeInsetsBigDesktop = 24;

  /// Responsive insets based on width.
  ///
  /// The width may be from LayoutBuilder or
  /// MediaQuery, depending on what is appropriate for the use case.
  static double responsiveInsets(double width, [bool isCompact = false]) {
    if (width < phoneWidthBreakpoint || isCompact) return edgeInsetsPhone;
    if (width < desktopWidthBreakpoint) return edgeInsetsTablet;
    if (width < bigDesktopWidthBreakpoint) return edgeInsetsDesktop;
    return edgeInsetsBigDesktop;
  }

  static String? get fontFamily => GoogleFonts.poppins().fontFamily;

  static TextTheme get textTheme => GoogleFonts.poppinsTextTheme();

  /// Defining the visual density here to so we can change it in one spot when
  /// we want to try different options.
  ///
  /// Use what you prefer, I just like this one on desktop better than the
  /// default one. The default Flutter one is too dense imo.
  static VisualDensity get visualDensity => FlexColorScheme.comfortablePlatformDensity;

  static const String defaultMessageDuringLoading = 'Please wait while we are fetching';
  static const String defaultSomethingWentWrong = 'Something went wrong, please try again later';
  static const String defaultFailure = 'Failure';
}
