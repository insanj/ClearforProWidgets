// Clear for ProWidgets
// Created by Julian (insanj) Weiss (c) 2014
// Source and license fully available on GitHub.

#include <libprowidgets/libprowidgets.h>
#include <libprowidgets/WidgetItems/items.h>
#include <UIKit/UIImage+Private.h>
#import "CWDynamicReader.h"
#import "CWViewController.h"

@interface CWWidget : PWWidget {
	CWViewController *_viewController;
	SBApplication *_clearApp;
}

@end
