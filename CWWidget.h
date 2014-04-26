#include <libprowidgets/libprowidgets.h>
#include <libprowidgets/WidgetItems/items.h>
#include <UIKit/UIImage+Private.h>
// #include <libobjcipc/objcipc.h>

@interface CWWidget : PWWidget {
	CWViewController *_viewController;
	SBApplication *_clearApp;
}

@property(nonatomic, retain) UIImage *addTaskImage;

@end
