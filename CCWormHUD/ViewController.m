//
//  ViewController.m
//  CCWormHUD
//
//  Created by 郑克明 on 16/3/17.
//  Copyright © 2016年 郑克明. All rights reserved.
//

#import "ViewController.h"
#import "CCWormView.h"

@interface ViewController ()
@property (nonatomic,strong) CCWormView *ccView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CCWormView *wormView = [CCWormView wormHUDWithStyle:CCWormHUDStyleLarge toView:self.view];
    self.ccView = wormView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)showOrHide:(id)sender {
    if (self.ccView.isShowing == NO) {
        [self.ccView startLodingWormHUD];
    }else{
        [self.ccView endLodingWormHUD];
    }
}

@end
