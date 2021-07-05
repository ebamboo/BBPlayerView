//
//  RootViewController.m
//  BBPlayerView
//
//  Created by ebamboo on 2021/7/3.
//

#import "RootViewController.h"
#import "SingleVideoViewController.h"
#import "MultiVideoViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BBPlayerView";
}

- (IBAction)singleVideoAction:(id)sender {
    [self.navigationController pushViewController:[SingleVideoViewController new] animated:YES];
}

- (IBAction)videoListAction:(id)sender {
    [self.navigationController pushViewController:[MultiVideoViewController new] animated:YES];
}

@end
