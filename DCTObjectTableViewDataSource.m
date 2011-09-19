//
//  DCTObjectTableViewDataSource.m
//  DCTTableViewDataSource
//
//  Created by Daniel Tull on 19.09.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "DCTObjectTableViewDataSource.h"

@implementation DCTObjectTableViewDataSource

@synthesize object;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
	return self.object;
}

@end
