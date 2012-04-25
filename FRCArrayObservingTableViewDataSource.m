//
//  FRCArrayObservingTableViewDataSource.m
//  NespressoTasting
//
//  Created by Daniel Tull on 24.04.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import "FRCArrayObservingTableViewDataSource.h"
#import "UITableView+FRCTableViewDataSources.h"

void* arrayObservingContext = &arrayObservingContext;

@interface NSArray (FRCArrayObservingTableViewDataSource)
- (NSIndexSet *)frcArrayObservingTableViewDataSource_indexesOfObject:(id)object;
@end

@implementation FRCArrayObservingTableViewDataSource {
	__strong NSMutableArray *_array;
	__weak id _object;
	__strong NSString *_keyPath;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_array count];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	return [_array objectAtIndex:indexPath.row];
}

- (void)reloadData {
	
	NSUInteger count = [_array count];
	
	NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:count];
	
	for (NSUInteger i = 0; i < count; i++) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
		indexPath = [self.tableView frc_convertIndexPath:indexPath fromChildTableViewDataSource:self];
		[indexPaths addObject:indexPath];
	}
	
	[self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)observeArrayInObject:(id)object keyPath:(NSString *)keyPath {
	
	[_object removeObserver:self
				 forKeyPath:_keyPath
					context:arrayObservingContext];
	
	_object = object;
	_keyPath = keyPath;
	[self reloadData];
	
	[_object addObserver:self 
			  forKeyPath:keyPath
				 options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
				 context:arrayObservingContext];	
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	if (context != arrayObservingContext)
		return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	
	_array = [change objectForKey:NSKeyValueChangeNewKey];
	
	NSKeyValueChange changeType = [[change objectForKey:NSKeyValueChangeKindKey] unsignedIntegerValue];
	NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
	
	NSMutableArray *indexPaths = [NSMutableArray new];
	[indexSet enumerateIndexesUsingBlock:^(NSUInteger i, BOOL *stop) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
		indexPath = [self.tableView frc_convertIndexPath:indexPath fromChildTableViewDataSource:self];
		[indexPaths addObject:indexPath];
	}];
	
	if (changeType == NSKeyValueChangeInsertion)
		[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
		
	else if (changeType == NSKeyValueChangeRemoval)
		[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
		
	else if (changeType == NSKeyValueChangeReplacement)
		[self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
	
	[self.tableView beginUpdates];
}

@end





@implementation NSArray (FRCArrayObservingTableViewDataSource)

- (NSIndexSet *)frcArrayObservingTableViewDataSource_indexesOfObject:(id)object {
	
	NSMutableIndexSet *set = [NSMutableIndexSet new];
	
	[self enumerateObjectsUsingBlock:^(id o, NSUInteger i, BOOL *stop) {
		if ([object isEqual:o]) 
			[set addIndex:i];
	}];
	
	return [set copy];	
}

@end













