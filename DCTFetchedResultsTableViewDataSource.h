//
//  DCTFetchedResultsTableViewDataSource.h
//  DCTTableViewDataSource
//
//  Created by Daniel Tull on 30/05/2011.
//  Copyright 2011 Daniel Tull. All rights reserved.
//

#import "DCTTableViewDataSource.h"
#import <CoreData/CoreData.h>

typedef NSFetchRequest *(^DCTFetchRequestBlock)();

@interface DCTFetchedResultsTableViewDataSource : DCTTableViewDataSource <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) NSFetchRequest *fetchRequest;
@property (nonatomic, copy) DCTFetchRequestBlock fetchRequestBlock;

- (void)loadFetchRequest;
- (void)loadFetchedResultsController;

@end
