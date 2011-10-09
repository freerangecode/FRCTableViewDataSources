/*
 UITableView+DCTTableViewDataSources.m
 DCTTableViewDataSources
 
 Created by Daniel Tull on 08.10.2011.
 
 
 
 Copyright (c) 2011 Daniel Tull. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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
