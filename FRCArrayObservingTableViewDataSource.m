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

@implementation FRCArrayObservingTableViewDataSource {
	BOOL _shouldSetup;
	__strong NSArray *_array;
}
@synthesize object = _object;
@synthesize keyPath = _keyPath;

- (void)dealloc {
	[_object removeObserver:self 
				 forKeyPath:_keyPath
					context:arrayObservingContext];
}

- (id)initWithObject:(id)object arrayKeyPath:(NSString *)keyPath {
	if (!(self = [self init])) return nil;
	
	_object = object;
	_keyPath = keyPath;
	_array = [_object valueForKeyPath:_keyPath];
	
	[_object addObserver:self 
			  forKeyPath:keyPath
				 options:NSKeyValueObservingOptionNew
				 context:arrayObservingContext];
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	if (context != arrayObservingContext)
		return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	
	_array = [_object valueForKeyPath:_keyPath];
	
	if (!_shouldSetup) return;
	
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

#pragma mark - FRCTableViewDataSource

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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	_shouldSetup = YES;
	return [_array count];
}

@end
