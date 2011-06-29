//
//  DCTTableViewDataSource.m
//  DCTTableViewDataSource
//
//  Created by Daniel Tull on 30/05/2011.
//  Copyright 2011 Daniel Tull. All rights reserved.
//

#import "DCTTableViewDataSource.h"

@implementation DCTTableViewDataSource

@synthesize tableView;

#pragma mark -

- (void)dealloc {
	[tableView release], tableView = nil;
	[super dealloc];
}

#pragma mark - DCTTableViewDataSource

- (void)reloadData {}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
	
	if (cell == nil)
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
	
	cell.textLabel.text = [NSString stringWithFormat:@"Cell with indexPath: %i.%i", indexPath.section, indexPath.row];
	
	return cell;
}

@end
