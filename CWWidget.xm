// Clear for ProWidgets
// Created by Julian (insanj) Weiss 2014
// Source and license fully available on GitHub.

#import "CWViewController.h"
#import "CWWidget.h"

@implementation CWWidget

- (void)configure {
	[self setupAppIfNeeded];
	self.title = @"Clear";

	NSDictionary *ipcResponse = [OBJCIPC sendMessageToAppWithIdentifier:_clearApp.displayIdentifier messageName:@"CWCurrentTheme" dictionary:nil];
	NSLog(@"[CWWidget] Received proper reply from CWIPC for theme request [%@]...", ipcResponse);
	self.preferredTintColor = ipcResponse[@"tintColor"];
	self.preferredBarTextColor = ipcResponse[@"textColor"];
}

- (void)load {
	[self setupAppIfNeeded];

	_addTaskImage = [[UIImage imageNamed:@"AddListPlus" inBundle:[NSBundle bundleWithPath:_clearApp.path]] retain];
	_viewController = [[CWViewController alloc] initForWidget:self];
	[self pushViewController:_viewController animated:NO];
}

- (void)setupAppIfNeeded {
	if (!_clearApp) {
		SBApplicationController *controller = [%c(SBApplicationController) sharedInstance];

		SBApplication *clear = [controller applicationWithDisplayIdentifier:@"com.realmacsoftware.clear"];
		SBApplication *clearplus = [controller applicationWithDisplayIdentifier:@"com.realmacsoftware.clear.universal"];

		if (!clear) {
			if (!clearplus) {
				[self showMessage:@"You need to install Clear or Clear+ from App Store to use this widget."];
				[self dismiss];
				return;
			}

			_clearApp = clearplus;
		}

		else {
			_clearApp = clear;
		}
	}
}

- (void)dealloc {
	[_viewController release];
	[_clearApp release];
	[_addTaskImage release];
	[super dealloc];
}

@end
