//
//  DCTCollapsableSectionTableViewDataSource.h
//  DCTTableViewSectionController
//
//  Created by Daniel Tull on 30.06.2011.
//  Copyright 2011 Daniel Tull. All rights reserved.
//

#import "DCTParentTableViewDataSource.h"

typedef enum {
	DCTCollapsableSectionTableViewDataSourceTypeNotCollapsable = 0,
	DCTCollapsableSectionTableViewDataSourceTypeCell,
	DCTCollapsableSectionTableViewDataSourceTypeDisclosure
} DCTCollapsableSectionTableViewDataSourceType;

typedef void (^DCTCollapsableSectionTableViewDataSourceSelectionBlock) ();

@interface DCTCollapsableSectionTableViewDataSource : DCTParentTableViewDataSource <DCTParentTableViewDataSource>

@property (nonatomic, strong) id<DCTTableViewDataSource> tableViewDataSource;
- (void)loadTableViewDataSource;

@property (nonatomic, assign) DCTCollapsableSectionTableViewDataSourceType type;

@property (nonatomic, assign) Class titleCellClass;
@property (nonatomic, copy) DCTCollapsableSectionTableViewDataSourceSelectionBlock titleSelectionHandler;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) BOOL greyWhenEmpty;
@property (nonatomic, assign) BOOL opened;

@end
