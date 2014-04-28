// Clear for ProWidgets
// Created by Julian (insanj) Weiss
// Source and license fully available on GitHub.

#import <Preferences/PSListController.h>
#import <UIKit/UIKit.h>
#import "../CWDynamicReader.h"
#include <Foundation/NSDistributedNotificationCenter.h>

@interface CWListController : PSListController {
	CWDynamicReader *_reader;
}

@end

@implementation CWListController

- (id)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"CWPrefs" target:self] retain];
	}

	return _specifiers;
}

- (void)twitter {
	NSString *user = @"insanj";
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];
	}

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name="  stringByAppendingString:user]]];
	}

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];
	}

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];
	}

	else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
	}
}

- (void)github {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/insanj/ClearforProWidgets"]];
}

- (void)viewWillAppear:(BOOL)arg1 {
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"CWSavePath" object:nil];
	[super viewWillAppear:arg1];
}

- (NSArray *)listTitles:(id)target {
	if (!_reader) {
		_reader = [[CWDynamicReader alloc] initWithSavedPath];
	}

	NSArray *lists = [_reader listsFromDatabase];
	return lists;
}

- (NSArray *)listValues:(id)target {
	return [self listTitles:target];
}

- (void)dealloc {
	[_reader release];
	[super dealloc];
}

@end
