// Clear for ProWidgets
// Created by Julian (insanj) Weiss (c) 2014
// Source and license fully available on GitHub.

#include <objc/runtime.h>
#include <libobjcipc/objcipc.h>
#include <sqlite3.h>
#import "../CWDynamicReader.h"

%ctor {
	CWLOG(@"Registering IPC listener for widget SpringBoard messages...");
	[OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:@"CWIPC.Create" handler:^NSDictionary *(NSDictionary *message) {
		BOOL loaded = [[UIApplication sharedApplication] openURL:message[@"schemeURL"]];
		return @{ @"loaded" : @(loaded) };
	 }];

	[OBJCIPC registerIncomingMessageFromAppHandlerForMessageName:@"CWIPC.Lists" handler:^NSDictionary *(NSDictionary *message) { 
		CWDynamicReader *reader = [[CWDynamicReader alloc] init];
		NSArray *lists = [reader listsFromDatabase];
		[reader release];

		return @{ @"lists" : lists };
	}];
}
