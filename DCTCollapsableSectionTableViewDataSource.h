//
//  DCTCollapsableSectionTableViewDataSource.h
//  DCTTableViewSectionController
//
//  Created by Daniel Tull on 30.06.2011.
//  Copyright 2011 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTTableViewDataSource.h"

typedef enum {
	DCTCollapsableSectionTableViewDataSourceTypeNotCollapsable = 0,
	DCTCollapsableSectionTableViewDataSourceTypeCell,
	DCTCollapsableSectionTableViewDataSourceTypeDisclosure
} DCTCollapsableSectionTableViewDataSourceType;

@interface DCTCollapsableSectionTableViewDataSource : NSObject<DCTTableViewDataSource, DCTTableViewDataSourceParent>

@property (nonatomic, strong) id<DCTTableViewDataSource> tableViewDataSource;

@property (nonatomic, assign) DCTCollapsableSectionTableViewDataSourceType type;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) BOOL greyWhenEmpty;
@property (nonatomic, assign) BOOL opened;

@end
