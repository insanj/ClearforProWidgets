// Clear for ProWidgets
// Created by Julian (insanj) Weiss (c) 2014
// Source and license fully available on GitHub.

#include <objc/runtime.h>
#include <libobjcipc/objcipc.h>
#include <sqlite3.h>
#import "../CWDynamicReader.h"

%ctor {
	CWLOG(@"Registering IPC listener for widget SpringBoard messages...");
	@autoreleasepool {
		[OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:@"CWIPC.Create" handler:^NSDictionary *(NSDictionary *message) {
			NSURL *schemeURL = message[@"schemeURL"];
			UIApplication *app = [UIApplication sharedApplication];
			BOOL loaded = [app openURL:schemeURL];

			CWLOG(@"Received incoming Create message from SpringBoard (%@ -> %@)...", app, schemeURL);
			return @{ @"loaded" : @(loaded) };
		 }];

		[OBJCIPC registerIncomingMessageFromAppHandlerForMessageName:@"CWIPC.Save" handler:^NSDictionary *(NSDictionary *message) { 
			CWDynamicReader *saver = [[CWDynamicReader alloc] init];
			BOOL worked = [saver savePath];

			CWLOG(@"Saved path to Clear app from SpringBoard using %@...", saver);
			return @{ @"worked" : @(worked) };
		}];
	}

	[OBJCIPC sendMessageToSpringBoardWithMessageName:@"CWIPC.Save" dictionary:@{} replyHandler:^(NSDictionary *response) { 
		CWLOG(@"Received reply from SpringBoard (to SpringBoard) for -savePath call..."); 
	}];
}
