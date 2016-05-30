//
//  AboutViewController.m
//  Plutocrat
//
//  Created by Pavel Dolgov on 16-05-03.
//  Copyright © 2016 Whitefly Ventures. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutHeader.h"
#import <WebKit/WebKit.h>

#define FAQ_ADDRESS @"https://www.whiteflyventuresinc.com/plutocrat_about.html"

@interface AboutViewController ()
{
    WKWebView * webView;
    UIProgressView * progress;
}
@end

@implementation AboutViewController

static NSString * progressKeyPath = @"estimatedProgress";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    AboutHeader * header = [[AboutHeader alloc] initWithFrame:
                            CGRectMake(0.0f,
                                       0.0f,
                                       self.view.bounds.size.width,
                                       [Globals cellHeight] + 20.0f)];
    [self.view addSubview:header];

    webView = [[WKWebView alloc] initWithFrame:
               CGRectMake(0.0f,
                          header.frame.size.height,
                          self.view.bounds.size.width,
                          self.view.bounds.size.height - header.frame.size.height - 48.0f)];
    [webView addObserver:self forKeyPath:progressKeyPath options:0 context:nil];
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:FAQ_ADDRESS]]];
    
    progress = [[UIProgressView alloc] initWithFrame:
                CGRectMake([Globals horizontalOffset],
                           webView.frame.size.height / 2,
                           webView.frame.size.width - [Globals horizontalOffset] * 2,
                           10.0f)];
    [webView addSubview:progress];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:progressKeyPath])
    {
        [progress setHidden:(webView.estimatedProgress == 1.0f)];
        [progress setProgress:webView.estimatedProgress];
    }
}

@end
