//
//  TestTableViewDataSource.m
//  Horizontal Demo
//
//  Created by Daniel Tull on 21.12.2011.
//  Copyright (c) 2011 Daniel Tull Limited. All rights reserved.
//

#import "TestTableViewDataSource.h"

@implementation TestTableViewDataSource {
	__strong NSArray *objects;
}

- (id)init {
	if (!(self = [super init])) return nil;
	
	objects = [[NSArray alloc] initWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", nil];
	
	return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [objects count];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	return [objects objectAtIndex:indexPath.row];
}

@end
