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
@synthesize viewController;

#pragma mark - DCTTableViewDataSource

- (void)setTableView:(UITableView *)tv {
	
	if (self.tableView == tv) return;
	
	tableView = tv;
	
	tableView.dataSource = self;	
}

- (void)setViewController:(UIViewController *)vc {
	
	if (self.viewController == vc) return;
	
	viewController = vc;
	
	SEL setTableViewDataSourceSelector = @selector(setTableViewDataSource:);
	
	if ([viewController respondsToSelector:setTableViewDataSourceSelector])
		[viewController performSelector:setTableViewDataSourceSelector withObject:self];
}

- (void)reloadData {}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
	
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
	
	cell.textLabel.text = [NSString stringWithFormat:@"Cell with indexPath: %i.%i", indexPath.section, indexPath.row];
	
	return cell;
}

@end
