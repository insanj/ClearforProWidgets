// Clear for ProWidgets
// Created by Julian (insanj) Weiss 2014
// Source and license fully available on GitHub.

#import <objc/runtime.h>
#import <libobjcipc/objcipc.h>

@interface RMTheme : NSObject
@property(nonatomic, retain) UIColor *tasksBackgroundColor;
@property(nonatomic, retain) UIColor *taskTextColor;
+ (id)sharedThemeManager;
@end

@interface RMThemeManager
@property(nonatomic, retain) RMTheme *currentTheme;
@end

static inline __attribute__((constructor)) void init() {
	@autoreleasepool {
		[OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:@"CWCurrentTheme" handler:^NSDictionary *(NSDictionary *dict) {
			NSLog(@"[CWIPC] Detected IPC incoming message...");
			RMThemeManager *manager = [objc_getClass("RMThemeManager") sharedThemeManager];
			RMTheme *theme = manager.currentTheme;
			NSLog(@"[CWIPC] Recieved IPC message for shared theme [%@]...", theme);
			return @{@"tintColor" : theme.tasksBackgroundColor, @"textColor" : theme.taskTextColor};
		}];
	}
}
