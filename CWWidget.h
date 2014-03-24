#include <libprowidgets/libprowidgets.h>
#include <libprowidgets/WidgetItems/items.h>
#include <UIKit/UIImage+Private.h>

@interface CWWidget : PWWidget {
	CWViewController *_viewController;
}

@property(nonatomic, retain) UIImage *addTaskImage;

@end
