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


@interface DCTTableViewDataSource (DCTTableViewDataSources)
- (void)dct_logTableViewDataSourcesLevel:(NSInteger)level;
@end
@implementation DCTTableViewDataSource (DCTTableViewDataSources)

- (void)dct_logTableViewDataSourcesLevel:(NSInteger)level {
	
	NSMutableString *string = [[NSMutableString alloc] init];
	
	for (NSInteger i = 0; i < level; i++)
		[string appendString:@"    "];
	
	NSLog(@"%@%@", string, self);
	
	if ([self isKindOfClass:[DCTParentTableViewDataSource class]]) {
		for (id object in [(DCTParentTableViewDataSource *)self childTableViewDataSources])
			[object dct_logTableViewDataSourcesLevel:level+1];
	}
}

@end

@implementation UITableView (DCTTableViewDataSources)

- (void)dct_logTableViewDataSources {
	
	id ds = self.dataSource;
	if (![ds isKindOfClass:[DCTTableViewDataSource class]]) return;
	
	DCTTableViewDataSource *dataSource = (DCTTableViewDataSource *)ds;
	
	NSLog(@"-------------");
	NSLog(@"Logging data sources for %@", self);
	NSLog(@"-------------");
	[dataSource dct_logTableViewDataSourcesLevel:0];
	NSLog(@"-------------");
}

- (NSInteger)dct_convertSection:(NSInteger)section fromChildTableViewDataSource:(DCTTableViewDataSource *)dataSource {
	
	DCTParentTableViewDataSource *parent = dataSource.parent;
	
	while (parent) {
		section = [parent convertSection:section fromChildTableViewDataSource:dataSource];
		dataSource = parent;
		parent = dataSource.parent;
	}
	
	NSAssert(parent == nil, @"Parent should equal nil at this point");
	NSAssert(dataSource == self.dataSource, @"dataSource should now be the tableview's dataSource");
	
	return section;
}

- (NSIndexPath *)dct_convertIndexPath:(NSIndexPath *)indexPath fromChildTableViewDataSource:(DCTTableViewDataSource *)dataSource {
	
	DCTParentTableViewDataSource *parent = dataSource.parent;
	
	while (parent) {
		indexPath = [parent convertIndexPath:indexPath fromChildTableViewDataSource:dataSource];
		dataSource = parent;
		parent = dataSource.parent;
	}
	
	NSAssert(parent == nil, @"Parent should equal nil at this point");
	NSAssert(dataSource == self.dataSource, @"dataSource should now be the tableview's dataSource");
	
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
