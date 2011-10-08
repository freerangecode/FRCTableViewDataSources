//
//  UITableView+DCTTableViewDataSources.m
//  Issues
//
//  Created by Daniel Tull on 08.10.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "UITableView+DCTTableViewDataSources.h"
#import "DCTTableViewCell.h"

@implementation UITableView (DCTTableViewDataSources)

- (void)dct_registerDCTTableViewCellSubclass:(Class)tableViewCellClass {
	
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0	
	
	if (![tableViewCellClass isSubclassOfClass:[DCTTableViewCell class]]) return;
	
	NSString *nibName = [tableViewCellClass nibName];
	
	if (nibName == nil || [nibName length] < 1) return;
	
	UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
	NSString *reuseIdentifier = [tableViewCellClass reuseIdentifier];
	
	[self registerNib:nib forCellReuseIdentifier:reuseIdentifier];
	
#endif
	
}

@end
