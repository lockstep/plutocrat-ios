//
//  BuyoutsViewController.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-17.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "TargetsBuyoutsBaseViewController.h"
#import "BuyoutsCell.h"
#import "InitiateViewController.h"

@interface BuyoutsViewController : TargetsBuyoutsBaseViewController <TargetsBuyoutsCellDelegate, InitiateViewControllerDelegate>

@end
