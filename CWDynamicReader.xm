// Clear for ProWidgets
// Created by Julian (insanj) Weiss 2014
// Source and license fully available on GitHub.

#import "CWDynamicReader.h"
#include <SpringBoard/SBApplicationController.h>
#include <SpringBoard/SBApplication.h>

@implementation CWDynamicReader

- (CWDynamicReader *)init {
	self = [super init];
	if (self) {
		SBApplicationController *controller = [%c(SBApplicationController) sharedInstance];

		SBApplication *clear = [controller applicationWithDisplayIdentifier:@"com.realmacsoftware.clear"];
		SBApplication *clearplus = [controller applicationWithDisplayIdentifier:@"com.realmacsoftware.clear.universal"];

		_clearPath = clear ? clear.path : clearplus.path;
	}

	return self;
}

- (CWDynamicReader *)initWithPath:(NSString *)path {
	self = [super init];
	if (self) {
		_clearPath = path;
	}

	return self;
}

- (CWDynamicReader *)initWithSavedPath {
	self = [super init];
	if (self) {
		_clearPath = [[NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.clearforprowidgets.plist"]] objectForKey:@"savedPath"];
	}

	return self;
}

- (NSDictionary *)themeFromSettings {
	NSString *resourcePath = [[NSBundle bundleWithPath:_clearPath] resourcePath];
	NSString *preferencesPath = [resourcePath stringByReplacingOccurrencesOfString:@"Clear.app" withString:@"Library/Preferences/com.realmacsoftware.clear.plist"];
	NSDictionary *clearPreferences = [NSDictionary dictionaryWithContentsOfFile:preferencesPath];
	NSString *themeKey = [clearPreferences objectForKey:@"ThemeIdentifier"];
	return [self themeComponentsFromKey:themeKey];
}

// Hard-coded, key-specific theme color values self-derived from the RMThemeManager's
// currentTheme variable, which has taskTextColor, as well as -taskColourForIndex:count:.
// To ensure a nice averaged theme-proper color, I used index:24 and count:50. Larger
// counts will yeild more mellow colors, which might be preferable for default themes,
// but would be unfamiliar for complex, bonus unlock themes.
- (NSDictionary *)themeComponentsFromKey:(NSString *)key {
	NSArray *keys = @[@"THEME_WARMTH_ID", @"THEME_GRAPHITE_ID", @"THEME_PINK_ID", @"THEME_GREEN_ID", @"THEME_NOIR_ID",
	 				 @"THEME_MAGNIFICENT_ID", @"THEME_5C_BLUE_ID", @"THEME_5C_YELLOW_ID", @"THEME_SCORCHED_ID", 
	 				 @"THEME_SOCIAL_ID", @"THEME_NIGHT_OWL_ID", @"THEME_LOYALTY_ID", @"THEME_GIFTED_ID", 
	 				 @"THEME_TWEETBOT_ID", @"THEME_PATH_ID", @"THEME_BUMPY_ROAD_ID", @"THEME_HEIST_ID", @"THEME_TEMPLE_RUN_ID",
	 				 @"THEME_LETTERPRESS_ID", @"THEME_CLOUDY_ID", @"THEME_ANALOG_ID", @"THEME_VANILLA_ID"];

	switch ([keys indexOfObject:key]) {
		default:
		case 0: // Heat Map
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.883633 green:0.336134 blue:0.0977991 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithWhite:1 alpha:1] };
		case 1: // Graphite
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.396078 green:0.470668 blue:0.545258 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithWhite:1 alpha:1] };
		case 2: // Pretty Princess
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.904282 green:0.252981 blue:0.444338 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithWhite:1 alpha:1] };
		case 3: // Lucky Clover
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.506363 green:0.72565 blue:0.118207 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithWhite:1 alpha:1] };
		case 4: // Theme Noir
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.213926 green:0.213926 blue:0.213926 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithWhite:1 alpha:1] };
		case 5: // Magnificent
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.663225 green:0.376391 blue:0.981993 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithWhite:1 alpha:1] };
		case 6: // Whale
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.208163 green:0.523569 blue:0.913966 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithWhite:1 alpha:1] };
		case 7: // Sunflowers
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.954542 green:0.809284 blue:0.255862 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithWhite:1 alpha:1] };
		case 8: // Scorched ★
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.772389 green:0.358543 blue:0.095078 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithWhite:1 alpha:1] };
		case 9: // Socialite ★
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.409524 green:0.642977 blue:0.9006 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithWhite:1 alpha:1] };
		case 10: // Night Owl ★
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.208884 green:0.331893 blue:0.433533 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithWhite:1 alpha:1] };
		case 11: // Ultraviolet ★
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.447779 green:0.229532 blue:0.52445 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithWhite:1 alpha:1] };
		case 12: // Gifted ★
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.920608 green:0.920608 blue:0.920608 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithRed:0.858824 green:0.0862745 blue:0.090196 alpha:1]};
		case 13: // Tweetbot ★
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.676351 green:0.692037 blue:0.705722 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithRed:0.14902  green:0.156863 blue:0.160784 alpha:1] };
		case 14: // Path ★
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.87499  green:0.847299 blue:0.803922 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithRed:0.501961 green:0.482353 blue:0.45098 alpha:1] };
		case 15: // Bumpy Road ★
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.383033 green:0.157503 blue:0.0979592 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithRed:0.960784 green:0.909804 blue:0.705882 alpha:1] };
		case 16: // The Heist ★
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.138455 green:0.168067 blue:0.178071 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithRed:0.647059 green:0.54902  blue:0.372549 alpha:1] };
		case 17: // Temple Run ★
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.84962 green:0.532853 blue:0.0460984 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithWhite:1 alpha:1] };
		case 18: // Letterpress ★
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.761745 green:0.235454 blue:0.180232 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithRed:0.917647 green:0.843137 blue:0.835294 alpha:1] };
		case 19: // Cloudy ★
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.791357 green:0.832333 blue:0.881232 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithRed:0.219608 green:0.243137 blue:0.270588 alpha:1] };
		case 20: // Analog ★
			return @{ @"preferredTintColor" : @[[UIColor colorWithRed:0.670588 green:0.0784314 blue:0.819608 alpha:1], [UIColor colorWithRed:0.918954 green:0.186275 blue:0.538562 alpha:1], [UIColor colorWithRed:0.989542 green:0.286275 blue:0.330719 alpha:1], [UIColor colorWithRed:0.962745 green:0.407843 blue:0.127451 alpha:1], [UIColor colorWithRed:0.929412 green:0.575163 blue:0.00784314 alpha:1]][arc4random_uniform(5)],
					@"preferredBarTextColor" : [UIColor colorWithWhite:1 alpha:1] };
		case 21: // Vanilla ★
			return @{ @"preferredTintColor" : [UIColor colorWithRed:0.946619 green:0.905082 blue:0.828011 alpha:1],
					@"preferredBarTextColor" : [UIColor colorWithRed:0.376471 green:0.286275 blue:0.192157 alpha:1] };
	}
}

// Returns an array with two sub-arrays, first for names, second for indices
- (NSArray *)listsFromDatabase {
	NSString *resourcePath = [[NSBundle bundleWithPath:_clearPath] resourcePath];
	NSString *databasePath = [resourcePath stringByReplacingOccurrencesOfString:@"Clear.app" withString:@"Library/Application Support/com.realmacsoftware.clear/BackendTasks.sqlite"];
	return [self parsedSQLiteListNamesForPath:databasePath];
}

// Derived from infragistics (Torrey Betts) Sqlite3 example 
- (NSArray *)parsedSQLiteListNamesForPath:(NSString *)path {
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
	return [NSArray arrayWithArray:listNames];
}

- (BOOL)savePath {
	NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.clearforprowidgets.plist"];
	NSMutableDictionary *preferences = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	if (!preferences) {
		preferences = @{@"savedPath" : _clearPath}.mutableCopy;
	}

	else {
		[preferences setValue:_clearPath forKey:@"savedPath"]; 
	}

	return [preferences writeToFile:path atomically:YES];
}

@end