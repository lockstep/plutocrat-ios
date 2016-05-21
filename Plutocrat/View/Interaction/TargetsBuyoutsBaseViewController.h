//
//  TargetsBuyoutsBaseViewController.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-17.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TargetsBuyoutsHeader.h"

@interface TargetsBuyoutsBaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, TargetsBuyotsHeaderDelegate>

@property (nonatomic, strong) TargetsBuyoutsHeader * header;
@property (nonatomic, strong) UITableView * table;
@property (nonatomic, copy) NSArray * source;

@end
