// Clear for ProWidgets
// Created by Julian (insanj) Weiss
// Source and license fully available on GitHub.

#import "CWTheme.h"

@implementation CWTheme

- (CGFloat)cornerRadius {
    return 7.0;
}

- (UIColor *)navigationBarBackgroundColor {
    return [UIColor colorWithRed:232/255.0 green:73/255.0 blue:34/255.0 alpha:1.0];
}

- (UIColor *)navigationTitleTextColor {
    return [UIColor whiteColor];
}

- (UIColor *)navigationButtonTextColor {
    return [UIColor colorWithWhite:0.9 alpha:1.0];
}

/*
- (UIColor *)sheetForegroundColor {
    return [UIColor colorWithRed:235/255.0 green:117/255.0 blue:34/255.0 alpha:1.0];
}

- (UIColor *)sheetBackgroundColor {
    return [self tintColor];
}
*/

@end
