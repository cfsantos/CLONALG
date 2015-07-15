//
//  ViewController.m
//  CSA
//
//  Created by Claudio Filipi Goncalves dos Santos on 7/14/15.
//  Copyright (c) 2015 Claudio Filipi Goncalves dos Santos. All rights reserved.
//

#import "ViewController.h"
#import "CSA.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CSA *clonal = [CSA new];
    [clonal calculateBestValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
