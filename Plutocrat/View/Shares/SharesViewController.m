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
#import "ApiConnector.h"

@interface SharesViewController ()
{
    CommonHeader * header;
    UITableView * table;
    NSArray * source;
    UIActivityIndicatorView * iView;
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
    [table setSeparatorInset:UIEdgeInsetsMake(0.0f,
                                              [Globals horizontalOffsetInTable],
                                              0.0f,
                                              [Globals horizontalOffsetInTable])];
    [self.view addSubview:table];

    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadHeaderData];
}

#pragma mark - TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [source count];
}

#pragma mark - TableView

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
    [self configureCell:(SharesTableViewCell *)cell onIndexPath:indexPath];
}

- (void)configureCell:(SharesTableViewCell *)cell onIndexPath:(NSIndexPath *)indexPath
{
    SKProduct * product = [source objectAtIndex:indexPath.row];
    NSArray * amts = @[@(SharesAmountFew), @(SharesAmountAverage), @(SharesAmountAverage), @(SharesAmountMany), @(SharesAmountMany)];
    NSArray * bundleParts = [product.productIdentifier componentsSeparatedByString:@"."];
    NSUInteger shares = [[bundleParts lastObject] integerValue];
    CGFloat price = [product.price floatValue];
    
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];

    NSLocale * storeLocale = product.priceLocale;
    NSString * currency = (NSString *)CFLocaleGetValue((CFLocaleRef)storeLocale, kCFLocaleCurrencySymbol);

    NSUInteger visualAmount = SharesAmountMany;
    if ([amts count] > indexPath.row)
        visualAmount = [[amts objectAtIndex:indexPath.row] integerValue];
    [cell setShares:shares price:price currency:currency visualAmount:visualAmount];
    cell.tag = indexPath.row;
}

#pragma mark – Table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Globals cellHeight];
}

#pragma mark - Shares Cell Delegate

- (void)buttonTappedToByOnCell:(SharesTableViewCell *)cell
{
    SKProduct * product = [source objectAtIndex:cell.tag];
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - Products Request Delegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    source = [response.products sortedArrayUsingComparator:^NSComparisonResult(SKProduct * first, SKProduct * second) {
        NSArray * bundleParts = [first.productIdentifier componentsSeparatedByString:@"."];
        NSUInteger firstVal = [[bundleParts lastObject] integerValue];
        bundleParts = [second.productIdentifier componentsSeparatedByString:@"."];
        NSUInteger secondVal = [[bundleParts lastObject] integerValue];
        if (firstVal < secondVal)
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
    }];
    [iView removeFromSuperview];
    [table setScrollEnabled:YES];
    [table setSeparatorColor:[UIColor grayWithIntense:222.0f]];
    [table reloadData];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction * trans in transactions)
    {
        if (trans.transactionState == SKPaymentTransactionStatePurchased)
        {
            NSURL * receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
            NSData * receipt = [NSData dataWithContentsOfURL:receiptURL];
            [ApiConnector purchaseSharesWithAppleReceiptData:receipt
                                                  completion:^(NSString * error) {
                                                      if (!error)
                                                      {
                                                          [[SKPaymentQueue defaultQueue] finishTransaction:trans];
                                                          [self loadHeaderData];
                                                      }
                                                  }];
        }
    }
}

#pragma mark - load data

- (void)loadHeaderData
{
    [self updateHeaderData];
    [ApiConnector getProfileWithUserId:[UserManager currentUserId]
                            completion:^(User * user, NSString * error) {
                                [self updateHeaderData];
     }];
}

- (void)updateHeaderData
{
    [header setText:NSLocalizedStringFromTable(@"YourAccount", @"Labels", nil) descText:[NSString stringWithFormat:NSLocalizedStringFromTable(@"UnusedSharesFormat", @"Labels", nil), [UserManager availableShares]]];
}

- (void)loadData
{
    iView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [iView setCenter:CGPointMake(table.frame.size.width / 2, table.frame.size.height / 2)];
    [table addSubview:iView];
    [table setScrollEnabled:NO];
    [table setSeparatorColor:[UIColor clearColor]];
    [iView startAnimating];

    SKProductsRequest * req = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:@"com.whiteflyventuresinc.plutocrat.shares.1", @"com.whiteflyventuresinc.plutocrat.shares.10", @"com.whiteflyventuresinc.plutocrat.shares.50", @"com.whiteflyventuresinc.plutocrat.shares.100", @"com.whiteflyventuresinc.plutocrat.shares.500", nil]];
    [req setDelegate:self];
    [req start];
}

@end
