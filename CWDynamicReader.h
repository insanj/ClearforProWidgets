// Clear for ProWidgets
// Created by Julian (insanj) Weiss (c) 2014
// Source and license fully available on GitHub.

#include <UIKit/UIKit.h>
#include <sqlite3.h>

#ifdef DEBUG
	#define CWLOG(fmt, ...) NSLog((@"[ClearForProWidgets] %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
	#define CWLOG(fmt, ...) NSLog((@"[ClearForProWidgets]" fmt), ##__VA_ARGS__)
#endif

@interface CWDynamicReader : NSObject

@property(nonatomic, retain) NSString *clearIdentifier;
@property(nonatomic, retain) NSString *clearPath;

// Overrode initializer which dynamically grabs Clear path.
- (CWDynamicReader *)init;

// Initializer with given Clear app path.
- (CWDynamicReader *)initWithPath:(NSString *)path;

// Initializer with given saved app path from SpringBoard.
- (CWDynamicReader *)initWithSavedPath;

// Returns an dictionary with the current preferredTintColor and
// preferredBarTextColor read from the Clear settings plist file.
- (NSDictionary *)themeFromSettings;

// Returns an array with the current lists read from the Clear
// sqlite backend database, and with trival value numbers.
- (NSArray *)listsFromDatabase;

// Saves Clear app path from SpringBoard, for use in other processes.
- (BOOL)savePath;

@end