//
//  DCTTableViewCell.h
//  Issues
//
//  Created by Daniel Tull on 9.07.2011.
//  Copyright 2011 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^DCTTableViewDataSourceCellConfigureBlock)(UITableViewCell *cell, id object);


@protocol DCTTableViewCell <NSObject>
- (void)configureWithObject:(id)object;
@end


@interface DCTTableViewCell : UITableViewCell <DCTTableViewCell>

+ (NSString *)reuseIdentifier;
+ (NSString *)nibName;

@property (nonatomic, copy) DCTTableViewDataSourceCellConfigureBlock cellConfigurer;

@end



@interface UITableView (DCTTableViewCell)
- (void)dct_registerDCTTableViewCellSubclass:(Class)tableViewCellSubclass;
@end
