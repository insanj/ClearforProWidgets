// Clear for ProWidgets
// Created by Julian (insanj) Weiss (c) 2014
// Source and license fully available on GitHub.

#import <objc/runtime.h>
#import <libobjcipc/objcipc.h>
#define CWLOG(fmt, ...) NSLog((@"[ClearForProWidgets, Line %d] " fmt), __LINE__, ##__VA_ARGS__)

%ctor {
	CWLOG(@"[ClearForProWidgets] Registering IPC listener for widget SpringBoard messages...");
	[OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:@"CWIPC.Create.Task" handler:^NSDictionary *(NSDictionary *message) {
		NSURL *schemeURL = message[@"schemeURL"];
		UIApplication *app = [UIApplication sharedApplication];
		BOOL loaded = [app openURL:schemeURL];

		CWLOG(@"[ClearForProWidgets] Received incoming Create Task message from SpringBoard (%@ -> %@)...", app, schemeURL);
		return @{ @"loaded" : @(loaded) };
	 }];

}
