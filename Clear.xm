// Clear for ProWidgets
// Created by Julian (insanj) Weiss 2014
// Source and license fully available on GitHub.

#import <libprowidgets/libprowidgets.h>
#import <libprowidgets/WidgetItems/items.h>
#import "CWResultViewController.h"

@interface CWWidget : PWWidget {
	CWResultViewController *_resultViewController;
}

- (void)addItem:(NSString *)item;
- (void)setFirstResponder;
@end

@implementation CWWidget

- (void)configure {
	[super configure];
	[self loadThemeNamed:[CWTheme class]];
}

- (void)submitEventHandler:(NSDictionary *)values {
	NSString *item = values[@"item"];
	if (item != nil && [item length] > 0) {
		[self addItem:item];
	} else {
		[self setFirstResponder];
	}
}

- (void)addItem:(NSString *)item {
	NSString *scheme = [@"clearapp://task/create?taskName=" stringByAppendingString:item];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[scheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)setFirstResponder {
	PWWidgetItem *item = [self.defaultItemViewController itemWithKey:@"item"];
	[item becomeFirstResponder];
}

- (void)dealloc {
	[_resultViewController release];
	[super dealloc];
}

@end
