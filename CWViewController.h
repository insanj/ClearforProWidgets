// Clear for ProWidgets
// Created by Julian (insanj) Weiss (c) 2014
// Source and license fully available on GitHub.

#include <libprowidgets/PWContentItemViewController.h>
#include <libprowidgets/WidgetItems/PWWidgetItemWebView.h>
#include <SpringBoard/SBApplicationController.h>
#include <SpringBoard/SBApplication.h>
#include <libobjcipc/objcipc.h>
#import "CWDynamicReader.h"

@interface CWViewController : PWContentItemViewController {
	CWDynamicReader *_reader;
}

@end
