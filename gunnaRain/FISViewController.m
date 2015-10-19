//
//  FISViewController.m
//  gunnaRain
//
//  Created by Joe Burgess on 6/27/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"
#import <Forecastr/Forecastr.h>

@interface FISViewController ()
@property (strong, nonatomic) Forecastr *forecastr;
@end

@implementation FISViewController

static NSString *const FORECASTR_KEY = @"<#getcha own key#>"; //sorry :(

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.forecastr = [Forecastr sharedManager];
    self.forecastr.apiKey = FORECASTR_KEY;
    
    [self.forecastr getForecastForLatitude:34.6939 longitude:135.5022 time:nil exclusions:nil extend:nil success:^(id JSON) {
        NSLog(@"%@",JSON);
        
        NSString *rainProbString = JSON[@"currently"][@"precipProbability"];
        double rainProb = [rainProbString doubleValue];
        self.weatherStatus.text = rainProb == 1 ? @"Yep" : @"Nope";
        [self updateLabelColorWithProbability:rainProb];
        
    } failure:^(NSError *error, id response) {
        NSLog(@"%@", response);
    }];
}

// arbitrary ranges to make it more useful
-(void)updateLabelColorWithProbability:(double)probability
{
    if (probability < 0.3) {
        self.weatherStatus.backgroundColor = [UIColor greenColor];
        self.weatherStatus.textColor = [UIColor blackColor];
    } else if (probability < 1.0){
        self.weatherStatus.backgroundColor = [UIColor blackColor];
        self.weatherStatus.textColor = [UIColor whiteColor];
    } else {
        self.weatherStatus.backgroundColor = [UIColor redColor];
        self.weatherStatus.textColor = [UIColor blackColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
