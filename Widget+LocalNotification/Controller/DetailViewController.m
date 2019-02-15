//
//  DetailViewController.m
//  Widget+LocalNotification
//
//  Created by JihoonPark on 05/12/2018.
//  Copyright © 2018 JihoonPark. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *pm10Value;
@property (weak, nonatomic) IBOutlet UILabel *pm25Value;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet FaceView *faceView;
@property (nonatomic) int happiness;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.dataDic){
        self.title = [self.dataDic objectForKey:AIRKOREA_KEY_STATION_NAME];
        NSString *pm10 = [self.dataDic objectForKey:AIRKOREA_KEY_PM10];
        if(pm10 == nil || [pm10 isEqualToString:@"-"]){
            pm10 = [self.dataDic objectForKey:AIRKOREA_KEY_PM10_24HOUR];
        }
        [self.pm10Value setText:pm10];
        NSString * pm25 = [self.dataDic objectForKey:AIRKOREA_KEY_PM25];
        if(pm25 == nil || [pm25 isEqualToString:@"-"]){
            pm25 = [self.dataDic objectForKey:AIRKOREA_KEY_PM25_24HOUR];
        }
        [self.pm25Value setText:pm25];
        
        [self.dateTime setText:[self.dataDic objectForKey:AIRKOREA_KEY_DATA_TIME]];
        
        if(pm25.integerValue > 100 || pm10.integerValue > 30){
            self.happiness = 0;
        }
        else if(pm25.integerValue > 30 || pm10.integerValue > 30){
            self.happiness = 50;
        }
        else{
            self.happiness = 100;
        }
        [self.faceView reset];
        self.faceView.delegate = self;
        
        [self updateFaceView];
    }
}
    
-(void) updateFaceView{
    [self.faceView setNeedsDisplay];
}

#pragma mark - FaceViewDelegate Protocol
-(CGFloat)smilenessForFaceView:(FaceView *)requestor{
    CGFloat smileness = 0.0;
    if(requestor == self.faceView){
        smileness = [[self class] happinessToSmileness:self.happiness];
    }
    return smileness;
}

#define MAX_HAPPINESS 100
#define MIN_HAPPINESS 0
+(CGFloat)happinessToSmileness:(int) happiness{
    CGFloat ratioOfHappiness = (CGFloat)(happiness - MIN_HAPPINESS) / (CGFloat)(MAX_HAPPINESS - MIN_HAPPINESS);
    CGFloat smileness = ratioOfHappiness * 2.0 - 1.0;
    return smileness;
}

@end
