// Clear for ProWidgets
// Created by Julian (insanj) Weiss
// Source and license fully available on GitHub.

#import "CWViewController.h"
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

- (void)loadLists {
	// Load list values from IPC...
	CWItemListValue *item = (CWItemListValue *)[self itemWithKey:@"list"];
	[item setListItemTitles:@[@"Create List..."] values:@[@(NSIntegerMax)]];
}

- (void)itemValueChangedEventHandler:(PWWidgetItem *)item oldValue:(id)oldValue {
	NSLog(@"item:%@, oldValue:%@", item, oldValue);
	if ([item.key isEqualToString:@"list"]) {
		NSArray *value = (NSArray *) item.value;

		// If the value (integer association) is equal to the last value in the list, prompt
		// to Create. Since the last value inserted is NSIntegerMax, if the item that's tapped
		// is also NSIntegerMax, then it's clear we should Create.
		if ([value[0] isEqual:[[(PWWidgetItemListValue *)item listItemValues] lastObject]]) {
			__block NSArray *oldListValue = [oldValue retain];
			[self.widget prompt:@"What would you like to name your new Clear list?" title:@"Create List" buttonTitle:@"Add" defaultValue:nil style:UIAlertViewStylePlainTextInput completion:^(BOOL cancelled, NSString *firstValue, NSString *secondValue) {
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

- (void)createList:(NSString *)name {
	NSString *scheme = [@"clearapp://list/create?listName=" stringByAppendingString:name];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[scheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

	[self loadLists];
}

- (void)submitEventHandler:(NSDictionary *)values {
	[self.widget dismiss];

	NSString *task = values[@"task"];
	NSString *scheme;
	if (_lists && _lists.count > 1) {
		scheme = [@"clearapp://task/create?listPosition=0&taskName=" stringByAppendingString:task];
	}

	else {
		NSUInteger selectedListIndex = [(values[@"list"])[0] unsignedIntegerValue];
		scheme = [NSString stringWithFormat:@"clearapp://task/create?taskName=%@&listName=%@", task, _lists[selectedListIndex]];
	}

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[scheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)dealloc {
	[_lists release];
	[super dealloc];
}

@end
