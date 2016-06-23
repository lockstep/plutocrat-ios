//
//  AttackerView.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-12.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BigUserView.h"

@class AttackerView;

@protocol AttackerViewDelegate <NSObject>
@required

- (void)attackerViewDidAcceptDefeat:(AttackerView *)view;
- (void)attackerViewDidMatchShares:(AttackerView *)view;

@end

@interface AttackerView : UIView

@property (nonatomic, weak) id <AttackerViewDelegate> delegate;
@property (nonatomic, strong) BigUserView * attacker;

@end
