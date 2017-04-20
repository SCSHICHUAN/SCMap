//
//  PlateViewController.m
//  SCMap
//
//  Created by SHICHUAN on 2017/4/19.
//  Copyright © 2017年 SHICHUAN. All rights reserved.
//

#import "PlateViewController.h"
@interface PlateViewController ()

@end

@implementation PlateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor redColor];
    [self testButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)testButton
{
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    testButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-150/2, 100, 150, 44);
    [testButton setTitle:@"test" forState:UIControlStateNormal];
    [testButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    testButton.titleLabel.font = [UIFont systemFontOfSize:20];
    testButton.layer.shadowColor = [UIColor blackColor].CGColor;
    testButton.layer.shadowOpacity = 0.1;
    testButton.layer.shadowOffset = CGSizeMake(0, 0);
    testButton.layer.cornerRadius = 5;
    testButton.backgroundColor = [UIColor whiteColor];
    [testButton addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
}


-(void)test
{
    NSLog(@"%s",__func__);
    

}


@end
