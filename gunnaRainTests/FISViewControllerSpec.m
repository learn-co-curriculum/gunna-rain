//
//  FISViewControllerSpec.m
//  gunnaRain
//
//  Created by Tom OMalley on 5/12/15.
//  Copyright 2015 Joe Burgess. All rights reserved.
//
#import "FISViewController.h"
#import "FISAppDelegate.h"
#import <Forecastr.h>
#import "OHHTTPStubs.h"
#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

SpecBegin(FISViewController)

describe(@"FISViewController", ^{

    __block UIWindow *mainWindow;
    __block FISViewController *fisVC;
    __block NSDictionary *fakeSON;
    __block id<OHHTTPStubsDescriptor> httpStub;
    
    beforeEach(^
    {
        // just make sure we have a clean slate :)
        [OHHTTPStubs removeAllStubs];
        [[Forecastr sharedManager] performSelector:@selector(flushCache)];
    });
    
    it(@"weatherStatus == 'Yep' when precipProbability == 1", ^{
        fakeSON = @{@"currently": @{@"precipProbability": @"1"} };
        httpStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request)
                    {
                        return [request.URL.host isEqualToString: @"api.forecast.io"];
                    }
                                       withStubResponse:^OHHTTPStubsResponse* (NSURLRequest *request)
                    {  
                        return [OHHTTPStubsResponse responseWithJSONObject:fakeSON statusCode:200 headers:@{ @"Content-type": @"application/json"}];
                    }];
        
        mainWindow = ((FISAppDelegate*)[UIApplication sharedApplication].delegate).window;
        fisVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        [mainWindow setRootViewController: fisVC];
        expect(fisVC.weatherStatus.text).will.equal(@"Yep");
    });

    it(@"weatherStatus == 'Nope' when precipProbability != 1",
       ^{
           fakeSON = @{@"currently": @{@"precipProbability": @"0"} };
           httpStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request){
               return [request.URL.host isEqualToString: @"api.forecast.io"];
           }
                                          withStubResponse:^OHHTTPStubsResponse* (NSURLRequest *request)
                       {
                           return [OHHTTPStubsResponse responseWithJSONObject:fakeSON statusCode:200 headers:@{ @"Content-type": @"application/json"}];
                       }];
           
           mainWindow = ((FISAppDelegate*)[UIApplication sharedApplication].delegate).window;
           fisVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
           [mainWindow setRootViewController: fisVC];
           expect(fisVC.weatherStatus.text).will.equal(@"Nope");
       });
    
    afterEach(^{
        [OHHTTPStubs removeAllStubs];
        [[Forecastr sharedManager] performSelector:@selector(flushCache)];
    });
});

SpecEnd
