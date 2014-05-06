// Clear for ProWidgets
// Created by Julian (insanj) Weiss (c) 2014
// Source and license fully available on GitHub.

#import "CWViewController.h"
#import "CWWidget.h"
#import "CWItemListValue.h"

@implementation CWViewController

- (void)load {
	[self loadPlist:@"CWAddItem"];

	_reader = [[CWDynamicReader alloc] init];
	[self setupClearLists];

	[self setItemValueChangedEventHandler:self selector:@selector(itemValueChangedEventHandler:oldValue:)];
	[self setSubmitEventHandler:self selector:@selector(submitEventHandler:)];
}

// Load list values from SQLite database
- (void)setupClearLists {
	NSArray *lists = [_reader listsFromDatabase];
	NSArray *values = [NSArray arrayWithArray:lists];

	CWItemListValue *item = (CWItemListValue *)[self itemWithKey:@"list"];
	[item setListItemTitles:[lists arrayByAddingObject:@"Create List..."] values:[values arrayByAddingObject:@(NSIntegerMax)]];

	NSString *savedValue = [[NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.clearforprowidgets.plist"]] objectForKey:@"defaultList"];
	if ([lists containsObject:savedValue]) {
		item.value = savedValue;
	}
}

- (void)itemValueChangedEventHandler:(PWWidgetItem *)item oldValue:(id)oldValue {
	if ([item.key isEqualToString:@"list"]) {
		NSArray *value = (NSArray *)item.value;

		// If the value (integer association) is equal to the last value in the list, prompt
		// to Create. Since the last value inserted is NSIntegerMax, if the item that's tapped
		// is also NSIntegerMax, then it's clear we should Create.
		if ([value[0] isEqual:[[(PWWidgetItemListValue *)item listItemValues] lastObject]]) {
			__block NSArray *oldListValue = oldValue;
			[self.widget prompt:@"What would you like to name your new Clear list?" title:@"Create List" buttonTitle:@"Add" defaultValue:nil style:UIAlertViewStylePlainTextInput completion:^(BOOL cancelled, NSString *firstValue, NSString *secondValue) {
				if (cancelled) {
					[item setValue:oldListValue];
				}

				else {
					[self createList:firstValue];
				}
			}];
		}
	}
}

- (void)createList:(NSString *)name {
	NSString *scheme = [@"clearapp://list/create?listName=" stringByAppendingString:name];
	NSURL *schemeURL = [NSURL URLWithString:[scheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	CWLOG(@"Creating list using URL-scheme [%@]...", schemeURL);
	SBApplication *frontMostApp = [(SpringBoard *)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
	NSString __block *displayIdentifier = frontMostApp.displayIdentifier;
	
	NSObject __block *observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		CWLOG(@"Daisy chaining!");
		[[UIApplication sharedApplication] quitTopApplication:nil];
		if (![displayIdentifier isEqualToString:@"com.apple.springboard"]) {
			CWLOG(@"Springboard chaining!");
			[[UIApplication sharedApplication] launchApplicationWithIdentifier:displayIdentifier suspended:NO];
		}

		CWLOG(@"Done chaining!");
		[[NSNotificationCenter defaultCenter] removeObserver:observer];
	}];

	CWLOG(@"Opening app...");
	BOOL loaded = [[UIApplication sharedApplication] openURL:schemeURL];
	CWLOG(@"App loading: %@", loaded ? @"success" : @"failure");
}

- (void)submitEventHandler:(NSDictionary *)values {
	[self.widget dismiss];

	NSString *list = values[@"list"][0];
	NSString *task = values[@"task"];
	NSString *scheme = [NSString stringWithFormat:@"clearapp://task/create?listName=%@&taskName=%@", list, task];
	NSURL *schemeURL = [NSURL URLWithString:[scheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	CWLOG(@"Creating task with values [%@] using URL-scheme [%@]...", values, schemeURL);
	SBApplication *frontMostApp = [(SpringBoard *)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
	NSString *displayIdentifier = frontMostApp.displayIdentifier;
	if (!displayIdentifier) {
		displayIdentifier = @"com.apple.springboard";
	}

	CWLOG(@"Opening app...");
	BOOL loaded = [[UIApplication sharedApplication] openURL:schemeURL];
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"CWIPC.Kill" object:nil userInfo:@{ @"identifier" : displayIdentifier }];

	CWLOG(@"App loading: %@", loaded ? @"success" : @"failure");
}

@end
