//
//  DCTTableViewTitledDataSource.m
//  DCTTableViewSectionController
//
//  Created by Daniel Tull on 30.06.2011.
//  Copyright 2011 Daniel Tull. All rights reserved.
//

#import "DCTTableViewTitledDataSource.h"

@interface DCTTableViewTitledDataSource ()
- (void)dctInternal_setupTableViewDataSource;
@end

@implementation DCTTableViewTitledDataSource {
	BOOL opened;
}

@synthesize tableView;
@synthesize tableViewDataSource;
@synthesize sectionController;
@synthesize greyWhenEmpty;
@synthesize title;

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	return [self.tableViewDataSource tableView:tv numberOfRowsInSection:section] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) {
		
		NSString *identifier = [NSString stringWithFormat:@"title"];
		
		UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
		
		if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		
		cell.textLabel.text = self.title;
		
		UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapped:)]; 
		[cell addGestureRecognizer:gr];
		
		if (self.greyWhenEmpty && [self.tableViewDataSource tableView:tv numberOfRowsInSection:indexPath.section] == 0) {
			cell.textLabel.textColor = [UIColor lightGrayColor];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		} else {
			//cell.accessoryView = [self dctInternal_disclosureButton];
			
			//if (self.opened) 
			//	cell.accessoryView.layer.transform = CATransform3DMakeRotation(self.opened ? (CGFloat)M_PI : 0.0f, 0.0f, 0.0f, 1.0f);	
		}
		
		return cell;
		
	}
	
	NSIndexPath *ip = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
	
	return [self.tableViewDataSource tableView:tv cellForRowAtIndexPath:ip];
}

- (IBAction)titleTapped:(UITapGestureRecognizer *)sender {
	//[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForCell:sender.view] animated:YES];
}

- (UIButton *)dctInternal_disclosureButton {
	UIImage *image = [UIImage imageNamed:@"DisclosureArrow.png"];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);	
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
	button.backgroundColor = [UIColor clearColor];
	return button;
}

- (void)setTableView:(UITableView *)tv {
	
	if (tv == self.tableView) return;
	
	tableView = tv;
	
	[self dctInternal_setupTableViewDataSource];
}

- (void)setTableViewDataSource:(id<UITableViewDataSource>)ds {
	
	if (self.tableViewDataSource == ds) return;
	
	tableViewDataSource = ds;
	
	[self dctInternal_setupTableViewDataSource];	
}

- (void)dctInternal_setupTableViewDataSource {
	
	SEL setTableViewSelector = @selector(setTableView:);
	if ([self.tableViewDataSource respondsToSelector:setTableViewSelector])
		[self.tableViewDataSource performSelector:setTableViewSelector withObject:self.tableView];
	
}

@end
