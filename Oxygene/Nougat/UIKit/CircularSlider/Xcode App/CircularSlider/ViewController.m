//
//  ViewController.m
//  CircularSlider
//
//  Created by marc hoffman on 4/26/13.
//  Copyright (c) 2013 RemObjects Software. All rights reserved.
//

#import "ViewController.h"
#import "libTBCircularSlider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    
    //Create the Circular Slider
    TBCircularSlider *slider = [[TBCircularSlider alloc] initWithFrame:CGRectMake(0, 60, TBCircularSlider_TB_SLIDER_SIZE, TBCircularSlider_TB_SLIDER_SIZE)];
    
    //Define Target-Action behaviour
    [slider addTarget:self action:@selector(newValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
}

- (void)newValue:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
