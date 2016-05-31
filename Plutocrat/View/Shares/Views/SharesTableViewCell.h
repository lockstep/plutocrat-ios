//
//  SharesTableViewCell.h
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-31.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, SharesAmount)
{
    SharesAmountFew,
    SharesAmountAverage,
    SharesAmountMany
};

@class SharesTableViewCell;
@protocol SharesCellDelegate <NSObject>

- (void)buttonTappedToByOnCell:(SharesTableViewCell *)cell;

@end

@interface SharesTableViewCell : UITableViewCell

@property (nonatomic, weak) id <SharesCellDelegate> delegate;

- (void)setShares:(NSUInteger)shares price:(NSUInteger)price visualAmount:(SharesAmount)amount;

@end
