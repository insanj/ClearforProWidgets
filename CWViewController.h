// Clear for ProWidgets
// Created by Julian (insanj) Weiss
// Source and license fully available on GitHub.

#include <libprowidgets/PWContentItemViewController.h>
#include <libprowidgets/WidgetItems/PWWidgetItemWebView.h>
#include <SpringBoard/SBApplicationController.h>
#include <SpringBoard/SBApplication.h>

@interface CWViewController : PWContentItemViewController {
	SBApplication *_clearApp;
	NSArray *_lists;
}

@end
