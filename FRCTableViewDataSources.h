//
//  FRCTableViewDataSources.h
//  FRCTableViewDataSources
//
//  Created by Daniel Tull on 09.11.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Availability.h>

#if !defined dct_weak && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
#define frc_weak weak
#define __frc_weak __weak
#define frc_nil(x)
#define FRCTableViewDataSourceTableViewRowAnimationAutomatic UITableViewRowAnimationAutomatic
#elif !defined dct_weak && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_3
#define frc_weak unsafe_unretained
#define __frc_weak __unsafe_unretained
#define frc_nil(x) x = nil
#define FRCTableViewDataSourceTableViewRowAnimationAutomatic UITableViewRowAnimationFade
#else
#warning "This library uses ARC which is only available in iOS SDK 4.3 and later."
#endif

#ifndef frctableviewdatasources
#define frctableviewdatasources_1_0     10000
#define frctableviewdatasources_1_0_1   10001
#define frctableviewdatasources_1_0_2   10002
#define frctableviewdatasources         frctableviewdatasources_1_0_2
#endif
