//
//  ViewController.m
//  Horizontal Demo
//
//  Created by Daniel Tull on 21.12.2011.
//  Copyright (c) 2011 Daniel Tull Limited. All rights reserved.
//

#import "ViewController.h"
#import "FRCHorizontalTableViewDataSource.h"
#import "TestTableViewDataSource.h"

@implementation ViewController {
	__strong FRCHorizontalTableViewDataSource *dataSource;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	dataSource = [FRCHorizontalTableViewDataSource new];
	
	TestTableViewDataSource *ds = [TestTableViewDataSource new];
	
	dataSource.childTableViewDataSource = ds;
	
	dataSource.tableView = self.tableView;
	self.tableView.dataSource = dataSource;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *text = [dataSource objectAtIndexPath:indexPath];
	return [text sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]].width + 21.0f;
}

@end
