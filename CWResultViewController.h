// Clear for ProWidgets
// Created by Julian (insanj) Weiss
// Source and license fully available on GitHub.

#import <libprowidgets/PWContentItemViewController.h>
#import <libprowidgets/WidgetItems/PWWidgetItemWebView.h>
#import "CWTheme.h"

@interface CWResultViewController : PWContentItemViewController {
	NSString *_content;
}

@property(nonatomic, copy) NSString *content;

@end
