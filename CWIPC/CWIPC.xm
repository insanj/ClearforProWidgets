// Clear for ProWidgets
// Created by Julian (insanj) Weiss (c) 2014
// Source and license fully available on GitHub.

#include <objc/runtime.h>
#include <libobjcipc/objcipc.h>
#include <sqlite3.h>
#include <UIKit/UIApplication.h>
#include <UIKit/UIApplication+Private.h>
#include <SpringBoard/SBApplicationController.h>
#include <SpringBoard/SBApplication.h>
#include <SpringBoard/SpringBoard.h>
#include <Foundation/NSDistributedNotificationCenter.h>
#import "../CWDynamicReader.h"

static NSString* ipcWatchingIdentifier;

%ctor {
	CWLOG(@"Registering IPC listener for widget SpringBoard messages...");

	[OBJCIPC registerIncomingMessageFromAppHandlerForMessageName:@"CWIPC.Lists" handler:^NSDictionary *(NSDictionary *message) { 
		CWDynamicReader *reader = [[CWDynamicReader alloc] init];
		NSArray *lists = [reader listsFromDatabase];
		[reader release];

		return @{ @"lists" : lists };
	}];

	/*[[NSDistributedNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		if (ipcWatchingIdentifier) {
			CWLOG(@"Daisy chaining: %@", ipcWatchingIdentifier);
			[[UIApplication sharedApplication] quitTopApplication:nil];
			if (![ipcWatchingIdentifier isEqualToString:@"com.apple.springboard"]) {
				CWLOG(@"Springboard chaining!");
				[[UIApplication sharedApplication] launchApplicationWithIdentifier:ipcWatchingIdentifier suspended:NO];
			}

			CWLOG(@"Done chaining!");
			ipcWatchingIdentifier = nil;
		}

		else {
			CWLOG(@"Not watching, so forget it...");
		}
	}];*/

	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"CWIPC.Kill" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		NSString *killIdentifier = notification.userInfo[@"identifier"];

		CWLOG(@"Fire ze missles! %@", killIdentifier);
		[[UIApplication sharedApplication] quitTopApplication:nil];
		if (![killIdentifier isEqualToString:@"com.apple.springboard"]) {
			CWLOG(@"Go back home...");
			[[UIApplication sharedApplication] launchApplicationWithIdentifier:ipcWatchingIdentifier suspended:NO];
		}

		CWLOG(@"Done chaining!");
		//CWLOG(@"Time to watch: %@", ipcWatchingIdentifier);
	}];

	
}
