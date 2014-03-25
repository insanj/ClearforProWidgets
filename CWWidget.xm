// Clear for ProWidgets
// Created by Julian (insanj) Weiss 2014
// Source and license fully available on GitHub.

#import "CWViewController.h"
#import "CWWidget.h"

@implementation CWWidget

- (void)load {
	SBApplicationController *controller = [%c(SBApplicationController) sharedInstance];

	SBApplication *clear = [controller applicationWithDisplayIdentifier:@"com.realmacsoftware.clear"];
	SBApplication *clearplus = [controller applicationWithDisplayIdentifier:@"com.realmacsoftware.clear.universal"];

	SBApplication *clearApp;
	if (!clear) {
		if (!clearplus) {
			[self showMessage:@"You need to install Clear or Clear+ from App Store to use this widget."];
			[self dismiss];
			return;
		}

		clearApp = clearplus;
	}

	else {
		clearApp = clear;
	}

	_addTaskImage = [[UIImage imageNamed:@"AddListPlus" inBundle:[NSBundle bundleWithPath:clearApp.path]] retain];

	// self.preferredTintColor = themed tint from app

	_viewController = [[CWViewController alloc] initForWidget:self];
	[self pushViewController:_viewController animated:NO];
}

- (void)dealloc {
	[_viewController release];
	[_addTaskImage release];
	[super dealloc];
}

@end
