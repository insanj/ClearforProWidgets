// Clear for ProWidgets
// Created by Julian (insanj) Weiss
// Source and license fully available on GitHub.

#import "CWResultViewController.h"

@implementation CWResultViewController

- (void)load {
	self.requiresKeyboard = YES;
	self.shouldMaximizeContentHeight = YES;
	[self loadPlist:@"ClearResultItems"];
}

- (void)willBePresentedInNavigationController:(UINavigationController *)navigationController {
	CWTheme *theme = [[CWTheme alloc] initWithName:@"CWTheme" bundle:[NSBundle bundleForClass:self.class] widget:self.widget disabledBlur:NO];

	PWWidgetItemWebView *item = (PWWidgetItemWebView *)[self itemWithKey:@"webView"];
	NSString *content = nil;

	NSString *textRGBA = [PWTheme RGBAFromColor:[theme cellTitleTextColor]];
	NSString *separatorRGBA = [PWTheme RGBAFromColor:[theme cellSeparatorColor]];
	if (textRGBA && separatorRGBA) {
		content = [NSString stringWithFormat:@"%@<style>* { color:%@ !important; background:none !important; border-color:%@ !important;  }</style>", _content, textRGBA, separatorRGBA];
	} else {
		content = _content;
	}

	[item loadHTMLString:content baseURL:nil];
	[_content release], _content = nil;
}

- (void)dealloc {
	[_content release];
	[super dealloc];
}

@end
