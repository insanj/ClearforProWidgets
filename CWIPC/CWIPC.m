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
			RMThemeManager *manager = [[objc_getClass("RMTheme") alloc] sharedThemeManager];
			RMTheme *theme = manager.currentTheme;
			NSLog(@"[CWIPC] Recieved IPC message for shared theme [%@]...", theme);
			return @{@"tintColor" : theme.tasksBackgroundColor, @"textColor" : theme.taskTextColor};
		}];
	}
}

/*** The message is never recieved by this listener, here's the log:

SpringBoard[13011]: *** libobjcipc: <Connection> Reset auto disconnect timer
SpringBoard[13011]: *** libobjcipc: <Connection> NSStreamEventHasBytesAvailable: <__NSCFInputStream: 0x1784852d0>
SpringBoard[13011]: *** libobjcipc: <Connection> Reset auto disconnect timer
SpringBoard[13011]: *** libobjcipc: <Connection> NSStreamEventEndEncountered: <__NSCFInputStream: 0x1784852d0>
SpringBoard[13011]: *** libobjcipc: <Connection> Close connection <<OBJCIPCConnection 0x178334280> <App identifier: com.realmacsoftware.clear.universal> <Reply handlers: 1>>
SpringBoard[13011]: [CWWidget] Received proper reply from CWIPC for theme request [(null)]...
SpringBoard[13011]: *** libobjcipc: Connection is closed <<OBJCIPCConnection 0x178334280> <App identifier: com.realmacsoftware.clear.universal> <Reply handlers: 0>>
com.apple.launchd[1] (UIKitApplication:com.realmacsoftware.clear.universal[0xb615][13043]): (UIKitApplication:com.realmacsoftware.clear.universal[0xb615]) Job appears to have crashed: Segmentation fault: 11
SpringBoard[13011]: *** libobjcipc: Set app with identifier <com.realmacsoftware.clear.universal> in background <NO>
SpringBoard[13011]: *** libobjcipc: Remove connection <<OBJCIPCConnection 0x178334280> <App identifier: com.realmacsoftware.clear.universal> <Reply handlers: 0>>
SpringBoard[13011]: *** libobjcipc: objcipc: Remove active connection <key: com.realmacsoftware.clear.universal>
SpringBoard[13011]: *** libobjcipc: objcipc: Invalidate process assertion: <BKSProcessAssertion: 0x1702b25a0>
backboardd[13012]: Application 'UIKitApplication:com.realmacsoftware.clear.universal[0xb615]' exited abnormally with signal 11: Segmentation fault: 11
ReportCrash[13044]: Saved crashreport to /var/mobile/Library/Logs/CrashReporter/ClearPlus_201plist using uid: 0 gid: 0, synthetic_euid: 501 egid: 0


*/
