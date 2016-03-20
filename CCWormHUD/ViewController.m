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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.4];
    CCWormView *wormView = [[CCWormView alloc] initWithFrame:CGRectMake(150, 200, 80, 80)];
//    wormView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:wormView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
