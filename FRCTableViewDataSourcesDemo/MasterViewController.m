//
//  MasterViewController.m
//  FRCTableViewDataSources
//
//  Created by Daniel Tull on 12.10.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "FRCSplitTableViewDataSource.h"
#import "FRCFetchedResultsTableViewDataSource.h"
#import "FRCObjectTableViewDataSource.h"
#import "Event.h"
#import "EventTableViewCell.h"

@interface MasterViewController ()
- (void)saveContext;
@end

@implementation MasterViewController {
	__strong FRCSplitTableViewDataSource *dataSource;
}

@synthesize managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.leftBarButtonItem = self.editButtonItem;

	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
	self.navigationItem.rightBarButtonItem = addButton;
	
	dataSource = [[FRCSplitTableViewDataSource alloc] init];
	dataSource.type = FRCSplitTableViewDataSourceTypeSection;
	
	FRCFetchedResultsTableViewDataSource *frcDS = [[FRCFetchedResultsTableViewDataSource alloc] init];
	frcDS.cellClass = [EventTableViewCell class];
	frcDS.managedObjectContext = self.managedObjectContext;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[Event entityInManagedObjectContext:self.managedObjectContext]];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:EventAttributes.timeStamp ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    [request setFetchBatchSize:20];
	frcDS.fetchRequest = request;
	
	[dataSource addChildTableViewDataSource:frcDS];
	
	self.tableView.dataSource = dataSource;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete)
        [self.managedObjectContext deleteObject:[dataSource objectAtIndexPath:indexPath]];
	
	[self saveContext];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *selectedObject = [dataSource objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:selectedObject];
    }
}

- (void)insertNewObject {
	
	Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:[Event entityName]
													inManagedObjectContext:self.managedObjectContext];
	newEvent.timeStamp = [NSDate date];
	
	[self saveContext];
}

- (void)saveContext {
	NSError *error = nil;
	if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end
