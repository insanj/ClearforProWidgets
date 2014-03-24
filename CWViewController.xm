// Clear for ProWidgets
// Created by Julian (insanj) Weiss
// Source and license fully available on GitHub.

#import "CWViewController.h"
#import "CWTheme.h"
#import "CWWidget.h"
#import "CWItemListValue.h"

#define CWCONTENTHEIGHT 270.0

@implementation CWViewController

- (void)load {
	[self loadPlist:@"CWAddItem"];
	[self loadLists];

	[self setItemValueChangedEventHandler:self selector:@selector(itemValueChangedEventHandler:oldValue:)];
	[self setSubmitEventHandler:self selector:@selector(submitEventHandler:)];
}

- (NSString *)title {
	return @"Clear";
}

- (void)loadLists {
	CWItemListValue *item = (CWItemListValue *)[self itemWithKey:@"list"];
	[item setListItemTitles:@[@"Feature pending..."] values:@[@(NSIntegerMax)]];
	[item setValue:@(0)];
}

- (void)itemValueChangedEventHandler:(PWWidgetItem *)item oldValue:(id)oldValue {
	if ([item.key isEqualToString:@"list"]) {
		NSArray *value = (NSArray *)item.value;
		if ([value count] == 1) {
			if ([value[0] isEqual:[[(PWWidgetItemListValue *)item listItemValues] lastObject]]) {
				__block NSArray *oldListValue = [oldValue retain];
				[self.widget prompt:@"Enter the list name" title:@"Create List" buttonTitle:@"Create" defaultValue:nil style:UIAlertViewStylePlainTextInput completion:^(BOOL cancelled, NSString *firstValue, NSString *secondValue) {
					if (cancelled) {
						[item setValue:oldListValue];
					}

					else {
						[self createList:firstValue];
					}

					[oldListValue release], oldListValue = nil;
				}];
			}
		}
	}
}

- (void)createList:(NSString *)name {
	NSString *scheme = [@"clearapp://task/create?listName=" stringByAppendingString:name];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[scheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)submitEventHandler:(NSDictionary *)values {
	[self.widget dismiss];

	NSString *scheme = [@"clearapp://task/create?taskName=" stringByAppendingString:values[@"task"]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[scheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)dealloc {
	[super dealloc];
}

@end
