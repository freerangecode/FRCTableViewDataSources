//
//  DCTObjectTableViewDataSource.m
//  DCTTableViewDataSource
//
//  Created by Daniel Tull on 19.09.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "DCTObjectTableViewDataSource.h"

@implementation DCTObjectTableViewDataSource {
	UITableViewCell *cell;
}

@synthesize object;
@synthesize cell;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	return self.object;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	return self.cell;
}

- (void)reloadData {
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	if (self.parent != nil) indexPath = [self.parent childTableViewDataSource:self tableViewIndexPathForDataIndexPath:indexPath];
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
