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
- (IBAction)insertNewEvent:(id)sender;
@end

@implementation MasterViewController {
	__strong FRCSplitTableViewDataSource *dataSource;
	__strong FRCObjectTableViewDataSource *addDataSource;
}

@synthesize managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
	
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
	
	
	addDataSource = [[FRCObjectTableViewDataSource alloc] init];
	addDataSource.object = @"Add new timestamp";
	[dataSource addChildTableViewDataSource:addDataSource];
	
	
	self.tableView.dataSource = dataSource;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tv deselectRowAtIndexPath:indexPath animated:YES];
	
	id object = [dataSource objectAtIndexPath:indexPath];
	
	if (![object isEqual:addDataSource.object]) return;
	
	[self insertNewEvent:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *selectedObject = [dataSource objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:selectedObject];
    }
}

- (IBAction)insertNewEvent:(id)sender {
	
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
