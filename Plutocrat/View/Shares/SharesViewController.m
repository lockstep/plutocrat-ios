//
//  SharesViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-03.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "SharesViewController.h"
#import "CommonHeader.h"
#import "UserManager.h"

@interface SharesViewController ()
{
    CommonHeader * header;
    UITableView * table;
    NSArray * source;
}
@end

@implementation SharesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    header = [[CommonHeader alloc] initWithFrame:CGRectMake(0.0f,
                                                            0.0f,
                                                            self.view.bounds.size.width,
                                                            [Globals headerHeight])];
    [self.view addSubview:header];

    table = [[UITableView alloc] initWithFrame:
             CGRectMake(0.0f,
                        header.frame.size.height,
                        self.view.bounds.size.width,
                        self.view.bounds.size.height - header.frame.size.height - [Globals tabBarHeight])
                                         style:UITableViewStylePlain];
    [table setDelegate:self];
    [table setDataSource:self];
    [table setSeparatorColor:[UIColor grayWithIntense:222.0f]];
    [table setSeparatorInset:UIEdgeInsetsMake(0.0f,
                                              [Globals horizontalOffsetInTable],
                                              0.0f,
                                              [Globals horizontalOffsetInTable])];
    [self.view addSubview:table];
    
    [self stub];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [source count];
}

static NSString * identifier = @"SharesCellIdentifier";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SharesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[SharesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setDelegate:self];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self stubCell:(SharesTableViewCell *)cell onIndexPath:indexPath];
}

#pragma mark – Table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Globals cellHeight];
}

#pragma mark - Shares Cell Delegate

- (void)buttonTappedToByOnCell:(SharesTableViewCell *)cell
{
    SKProductsRequest * req = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"com.whiteflyventuresinc.Plutocrat.One"]];
    [req setDelegate:self];
   // [req start];
}

#pragma mark - Products Request Delegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct * product = [response.products lastObject];
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction * trans in transactions)
    {
        if (trans.transactionState == SKPaymentTransactionStatePurchased)
        {
            NSURL * receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
            NSData * receipt = [NSData dataWithContentsOfURL:receiptURL];
            NSLog(@"Length of receipt is: %lu", (unsigned long)[receipt length]);
            NSLog(@"%@", [receipt base64EncodedStringWithOptions:0]);
          //  [[SKPaymentQueue defaultQueue] finishTransaction:trans];
        }
    }
}

#pragma mark - stub

- (void)stub
{
    [header setText:[NSString stringWithFormat:NSLocalizedStringFromTable(@"UnusedSharesFormat", @"Labels", nil), [UserManager availableShares]]];
    source = @[@1, @5, @10, @50];
    [table reloadData];
}

- (void)stubCell:(SharesTableViewCell *)cell onIndexPath:(NSIndexPath *)indexPath
{
    NSArray * prices = @[@25, @125, @200, @750];
    NSArray * amts = @[@(SharesAmountFew), @(SharesAmountAverage), @(SharesAmountAverage), @(SharesAmountMany)];
    NSUInteger shares = [[source objectAtIndex:indexPath.row] integerValue];
    NSUInteger price = [[prices objectAtIndex:indexPath.row] integerValue];
    NSUInteger visualAmount = [[amts objectAtIndex:indexPath.row] integerValue];
    [cell setShares:shares price:price visualAmount:visualAmount];
}

@end
