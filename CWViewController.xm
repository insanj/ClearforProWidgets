// Clear for ProWidgets
// Created by Julian (insanj) Weiss
// Source and license fully available on GitHub.

#import "CWViewController.h"
#import "CWWidget.h"
#import "CWItemListValue.h"

#define CWCONTENTHEIGHT 270.0

@implementation CWViewController

- (void)load {
	[self setupAppIfNeeded];
	[self loadPlist:@"CWAddItem"];
	[self setupClearLists];

	[self setItemValueChangedEventHandler:self selector:@selector(itemValueChangedEventHandler:oldValue:)];
	[self setSubmitEventHandler:self selector:@selector(submitEventHandler:)];
}

- (void)setupAppIfNeeded {
	if (!_clearApp) {
		SBApplicationController *controller = [%c(SBApplicationController) sharedInstance];

		SBApplication *clear = [controller applicationWithDisplayIdentifier:@"com.realmacsoftware.clear"];
		SBApplication *clearplus = [controller applicationWithDisplayIdentifier:@"com.realmacsoftware.clear.universal"];

		_clearApp = clear ? clear : clearplus;
	}
}

- (void)setupClearLists {
	// Load list values from SQLite database...
	NSArray *listsAndValues = [self listsandValuesFromDatabase];
	CWItemListValue *item = (CWItemListValue *)[self itemWithKey:@"list"];
	[item setListItemTitles:[listsAndValues[0] arrayByAddingObject:@"Create List..."] values:[listsAndValues[1] arrayByAddingObject:@(NSIntegerMax)]];
}

// Returns an array with two sub-arrays, first for names, second for indices
- (NSArray *)listsandValuesFromDatabase {
	NSString *resourcePath = [[NSBundle bundleWithPath:_clearApp.path] resourcePath];
	NSString *databasePath = [resourcePath stringByReplacingOccurrencesOfString:@"Clear.app" withString:@"Library/Application Support/com.realmacsoftware.clear/BackendTasks.sqlite"];

	NSMutableArray *sqliteData = [self parsedSQLiteListNamesForPath:databasePath];
	NSMutableArray *values = [[NSMutableArray alloc] init];
	for (int i = 0; i < sqliteData.count; i++) {
		[values addObject:@(i)];
	}

	return @[sqliteData, values];
}

// Derived from infragistics (Torrey Betts) Sqlite3 example 
-(NSMutableArray *)parsedSQLiteListNamesForPath:(NSString *)path {
	NSMutableArray *listNames = [[NSMutableArray alloc] init]; 
	sqlite3 *database;

	if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		const char *sql = "select title from lists"; 
		sqlite3_stmt *selectStatement; 
		if (sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL) == SQLITE_OK) { 
			while(sqlite3_step(selectStatement) == SQLITE_ROW) { 
				[listNames addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0)]]; 
			}
		}
	}

	sqlite3_close(database);
	return listNames;
}

- (void)itemValueChangedEventHandler:(PWWidgetItem *)item oldValue:(id)oldValue {
	if ([item.key isEqualToString:@"list"]) {
		NSArray *value = (NSArray *) item.value;

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

	NSLog(@"[ClearForProWidgets] Creating list with using URL-scheme [%@]", scheme);
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[scheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)submitEventHandler:(NSDictionary *)values {
	[self.widget dismiss];

	int list = [values[@"list"][0] intValue] + 1;
	NSString *task = values[@"task"];
	NSString *scheme = [NSString stringWithFormat:@"clearapp://task/create?listPosition=%i&taskName=%@", list, task];

	NSLog(@"[ClearForProWidgets] Creating task with values [%@] using URL-scheme [%@]", values, scheme);
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[scheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}


@end
