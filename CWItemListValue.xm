// Clear for ProWidgets
// Created by Julian (insanj) Weiss
// Source and license fully available on GitHub.

#import "CWItemListValue.h"

@implementation CWItemListValue

- (NSString *)displayTextForValues:(NSArray *)values {
	if ([values count] == 1 && [values[0] integerValue] == NSIntegerMax) {
		return @""; // @"Create List...";
	}

	return [super displayTextForValues:values];
}

@end
