// Clear for ProWidgets
// Created by Julian (insanj) Weiss 2014
// Source and license fully available on GitHub.

#import "CWViewController.h"
#import "CWWidget.h"

@implementation CWWidget
@synthesize addTaskImage;

- (void)configure {
	self.layout = PWWidgetLayoutCustom;
	[self loadThemeNamed:@"CWTheme"];
}

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

	addTaskImage = [[UIImage imageNamed:@"AddListPlus" inBundle:[NSBundle bundleWithPath:clearApp.path]] retain];

	_viewController = [[CWViewController alloc] initForWidget:self];
	[self pushViewController:_viewController animated:NO];
}

- (void)dealloc {
	[_viewController release];
	[addTaskImage release];
	[super dealloc];
}

@end
