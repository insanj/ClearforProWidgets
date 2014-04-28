// Clear for ProWidgets
// Created by Julian (insanj) Weiss (c) 2014
// Source and license fully available on GitHub.

#import <objc/runtime.h>
#import <libobjcipc/objcipc.h>

#ifdef DEBUG
	#define CWLOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
	#define CWLOG(fmt, ...) NSLog((@"" fmt), ##__VA_ARGS__)
#endif

%ctor {
	CWLOG(@"Registering IPC listener for widget SpringBoard messages...");
	[OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:@"CWIPC.Create" handler:^NSDictionary *(NSDictionary *message) {
		NSURL *schemeURL = message[@"schemeURL"];
		UIApplication *app = [UIApplication sharedApplication];
		BOOL loaded = [app openURL:schemeURL];

		CWLOG(@"Received incoming Create message from SpringBoard (%@ -> %@)...", app, schemeURL);
		return @{ @"loaded" : @(loaded) };
	 }];
}
