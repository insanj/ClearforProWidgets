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

%ctor {
	CWLOG(@"Registering IPC listener for %@ messages...", [[UIApplication sharedApplication] displayIdentifier]);

	[OBJCIPC registerIncomingMessageFromAppHandlerForMessageName:@"CWIPC.Lists" handler:^NSDictionary *(NSDictionary *message) { 
		CWDynamicReader *reader = [[CWDynamicReader alloc] init];
		NSArray *lists = [reader listsFromDatabase];
		[reader release];

		return @{ @"lists" : lists };
	}];

	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"CWIPC.Kill" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
		NSString *killIdentifier = notification.userInfo[@"identifier"];

		CWLOG(@"Fire ze missles! %@", killIdentifier);
		if ([killIdentifier isEqualToString:@"com.apple.springboard"]) {
			[[UIApplication sharedApplication] quitTopApplication:nil];
		}

		else {
			CWLOG(@"Go back home...");
			[[UIApplication sharedApplication] launchApplicationWithIdentifier:killIdentifier suspended:NO];
		}

		CWLOG(@"Done chaining!");
	}];
}
