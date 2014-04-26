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
	[self loadLists];

	[self setItemValueChangedEventHandler:self selector:@selector(itemValueChangedEventHandler:oldValue:)];
	[self setSubmitEventHandler:self selector:@selector(submitEventHandler:)];
}

- (void)setupAppIfNeeded {
	if (!_clearApp) {
		SBApplicationController *controller = [%c(SBApplicationController) sharedInstance];

		SBApplication *clear = [controller applicationWithDisplayIdentifier:@"com.realmacsoftware.clear"];
		SBApplication *clearplus = [controller applicationWithDisplayIdentifier:@"com.realmacsoftware.clear.universal"];

		if (!clear) {
			if (!clearplus) {
				[self showMessage:@"You need to install Clear or Clear+ from App Store to use this widget."];
				[self dismiss];
				return;
			}

			_clearApp = clearplus;
		}

		else {
			_clearApp = clear;
		}
	}
}


- (void)loadLists {
	// Load list values from SQLite database...
	NSArray *listsAndValues = [self listsandValuesFromDatabase];
	CWItemListValue *item = (CWItemListValue *)[self itemWithKey:@"list"];
	[item setListItemTitles:[listsAndValues[0] arrayByAddingObject:@"Create List..."] values:[listsAndValues[1] arrayByAddingObject:@(NSIntegerMax)]];
}

// Returns an array with two sub-arrays, first for names, second for indices
- (NSArray *)listsandValuesFromDatabase {
	NSString *resourcePath = [[NSBundle bundleWithPath:_clearApp.path] resourcePath];
	NSString *databasePath = [resourcesPath stringByReplacingOccurrencesOfString:@"Clear.app" withString:@"Library/Application Support/com.realmacsoftware.clear/BackendTasks.sqlite"];

	NSArray *sqliteData = [self parsedSQLiteListNamesForPath:databasePath];
	NSMutableArray *values = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < sqliteData.count; i++) {
		[values addObject:@(i)];
	}

	return [NSArray arrayWithObjects:sqliteData, values];
}

// Derived from infragistics (Torrey Betts) Sqlite example 
-(NSArray *)parsedSQLiteListNamesForPath:(NSString *)path {
	NSMutableArray *listNames = [[[NSMutableArray alloc] init] autorelease]; 
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
		NSUInteger selectedListIndex = [(values[@"list"])[0] unsignedIntegerValue];
		scheme = [NSString stringWithFormat:@"clearapp://task/create?taskName=%@&listName=%@", task, _lists[selectedListIndex]];
	}

	else {
		scheme = [@"clearapp://task/create?taskName=" stringByAppendingString:task];
	}

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[scheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)dealloc {
	[_lists release];
	[super dealloc];
}

@end
