// Clear for ProWidgets
// Created by Julian (insanj) Weiss 2014
// Source and license fully available on GitHub.

#include <libprowidgets/libprowidgets.h>
#include <libprowidgets/WidgetItems/items.h>
#include <UIKit/UIImage+Private.h>
// #include <libobjcipc/objcipc.h>
#import "CWDynamicReader.h"
#import "CWViewController.h"

#define DEBUG_LOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface CWWidget : PWWidget {
	CWViewController *_viewController;
	SBApplication *_clearApp;
}

// @property(nonatomic, retain) UIImage *addTaskImage;

@end
