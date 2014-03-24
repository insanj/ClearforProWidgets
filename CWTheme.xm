// Clear for ProWidgets
// Created by Julian (insanj) Weiss
// Source and license fully available on GitHub.

#import "CWTheme.h"

@implementation CWTheme

- (UIColor *)preferredBarTextColor{
    return [UIColor whiteColor];
}

- (BOOL)wantsDarkKeyboard {
    return YES;
}

- (UIColor *)tintColor {
    return [UIColor colorWithRed:232/255.0 green:73/255.0 blue:34/255.0 alpha:1.0];
}

- (UIColor *)sheetForegroundColor {
    return [UIColor colorWithRed:235/255.0 green:117/255.0 blue:34/255.0 alpha:1.0];
}

- (UIColor *)sheetBackgroundColor {
    return [self tintColor];
}

- (UIColor *)navigationBarBackgroundColor {
    return [self tintColor];
}

- (UIColor *)navigationTitleTextColor {
    return [UIColor whiteColor];
}

- (UIColor *)navigationButtonTextColor {
    return [UIColor whiteColor];
}

/*
- (UIColor *)cellSeparatorColor;
- (UIColor *)cellBackgroundColor;
- (UIColor *)cellTitleTextColor;
- (UIColor *)cellValueTextColor;
- (UIColor *)cellButtonTextColor;
- (UIColor *)cellInputTextColor;
- (UIColor *)cellInputPlaceholderTextColor;
- (UIColor *)cellPlainTextColor;

- (UIColor *)cellSelectedBackgroundColor;
- (UIColor *)cellSelectedTitleTextColor;
- (UIColor *)cellSelectedValueTextColor;
- (UIColor *)cellSelectedButtonTextColor;

- (UIColor *)cellHeaderFooterViewBackgroundColor;
- (UIColor *)cellHeaderFooterViewTitleTextColor;

- (UIColor *)switchThumbColor;
- (UIColor *)switchOnColor;
- (UIColor *)switchOffColor;*/

@end
