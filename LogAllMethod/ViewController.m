//
//  ViewController.m
//  LogAllMethod
//
//  Created by walen on 2017/5/17.
//  Copyright © 2017年 dafyit. All rights reserved.
//

#import "ViewController.h"
#import "MethodLogManager.h"
#import "Cat.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [MethodLogManager logAllMethodForClass:Cat.class callback:^(LogMethod *method) {
        NSLog(@"log method:%@", method);
    }];
    
    Cat *cat = [[Cat alloc] init];
    [cat fee];
    NSLog(@"catName:%@", [cat name]);
    [cat eat:@"mice"];
    
    cat.catBlock = ^{
        NSLog(@"this is cat block");
    };
    
    NSLog(@"cat.catBlock:%@", cat.catBlock);
    cat.catBlock();
    
    NSLog(@"%@", [Cat classFunc:10]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
