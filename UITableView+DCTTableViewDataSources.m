//
//  UITableView+DCTTableViewDataSources.m
//  Issues
//
//  Created by Daniel Tull on 08.10.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "UITableView+DCTTableViewDataSources.h"
#import "DCTTableViewCell.h"
#import "DCTParentTableViewDataSource.h"
#import "DCTTableViewDataSource.h"

@implementation UITableView (DCTTableViewDataSources)

- (NSInteger)dct_convertSection:(NSInteger)section fromChildTableViewDataSource:(id<DCTTableViewDataSource>)dataSource {
	
	id<DCTParentTableViewDataSource> parent = dataSource.parent;
	
	while (parent) {
		section = [parent convertSection:section fromChildTableViewDataSource:dataSource];
		dataSource = parent;
		parent = dataSource.parent;
	}
	
	return section;
}

- (NSIndexPath *)dct_convertIndexPath:(NSIndexPath *)indexPath fromChildTableViewDataSource:(id<DCTTableViewDataSource>)dataSource {
	id<DCTParentTableViewDataSource> parent = dataSource.parent;
	
	while (parent) {
		indexPath = [parent convertIndexPath:indexPath fromChildTableViewDataSource:dataSource];
		dataSource = parent;
		parent = dataSource.parent;
	}
	
	return indexPath;
}

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
