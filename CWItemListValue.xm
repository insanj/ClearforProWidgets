// Clear for ProWidgets
// Created by Julian (insanj) Weiss
// Source and license fully available on GitHub.

#import "CWItemListValue.h"

@implementation CWItemListValue

// - (void)setListItemTitles:(NSArray *)titles values:(NSArray *)values;
// - (void)updateItem:(PWWidgetItem *)item;
// - (void)setTitle:(NSString *)title;
// - (void)setIcon:(UIImage *)icon;
// - (void)setValue:(id)value;
// - (void)willAppear;

- (NSString *)displayTextForValues:(NSArray *)values {
	NSLog(@"-display text for values %@, %@", values, [super displayTextForValues:values]);
	if ([values count] == 1 && [values[0] integerValue] == NSIntegerMax) {
		return @""; // @"Create List...";
	}

	return [super displayTextForValues:values];
}

@end
