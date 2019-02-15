//
//  TodayViewController.m
//  TodayPannel
//
//  Created by JihoonPark on 12/12/2018.
//  Copyright © 2018 JihoonPark. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "AirKoreaData.h"
#import "FaceView.h"

@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic, strong) NSString * elementName;
@property (nonatomic, strong) NSString * nodeValue;
@property (nonatomic, weak) IBOutlet FaceView * faceViewPm25;
@property (nonatomic, weak) IBOutlet FaceView * faceViewPm10;
@property (nonatomic) int happiness;

@property (weak, nonatomic) IBOutlet UILabel * pm25Value;
@property (weak, nonatomic) IBOutlet UILabel * pm10Value;
@property (nonatomic) int happinessPm10;
@property (nonatomic) int happinessPm25;
@property (weak, nonatomic) IBOutlet UILabel *lbStationName;

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableDictionary *dataDic;


@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AirKoreaData getDataFromServer:[AirKoreaData AirKoreaRestURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSXMLParser * xmlParser = [[NSXMLParser alloc]initWithData:data];
        
        [xmlParser setDelegate:self];
        [xmlParser parse];
    }];
}


#pragma mark - NSXMLParesetDelegate
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"pareserDidStartDocument");
}
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    NSLog(@"parser:didStartElement::(%@)",elementName);
    if ([elementName isEqualToString:@"items"]) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    else if([elementName isEqualToString:@"item"]) {
        self.dataDic = [[NSMutableDictionary alloc]init];
    }
    else {
        self.elementName = [NSString stringWithString:elementName];
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"parser:didEndElement");
    if ([elementName isEqualToString:@"item"]) {
        [self.dataArray addObject:self.dataDic];
    }
    else if([elementName isEqualToString:@"items"]) {
        NSLog(@"complete parse");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateFaceView];
        });
    }
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSString *replaceString = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    replaceString = [replaceString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    replaceString = [replaceString stringByReplacingOccurrencesOfString:@"  " withString:@""];
    if(replaceString.length > 0 && !(
        [self.elementName isEqualToString:@"items"] || [self.elementName isEqualToString:@"item"]
                                     || ([self.elementName isEqualToString:@"body"])|| [self.elementName isEqualToString:@"header"]
                                     || [self.elementName isEqualToString:@"response"] || [self.elementName isEqualToString:@"resultCode"]
                                     || [self.elementName isEqualToString:@"resultMsg"]
                                     )
       ){
        NSLog(@"elementName::%@", self.elementName);
        NSLog(@"parser:foundCharacters(%@)", replaceString);
        [self classify:replaceString];
    }
}

-(void)classify:(NSString *)string{
    if(!self.dataDic) return;
    [self.dataDic setObject:[NSString stringWithString:string] forKey:[NSString stringWithString:self.elementName]];
}

-(void) updateFaceView{
    NSUInteger index = arc4random() % 10;
    self.dataDic = [self.dataArray objectAtIndex:index];
    
    [self.lbStationName setText:[self.dataDic objectForKey:AIRKOREA_KEY_STATION_NAME]];
    NSString * pm25 = [self.dataDic objectForKey:AIRKOREA_KEY_PM25];
    if(pm25 == nil || [pm25 isEqualToString:@"-"]){
        pm25 = [self.dataDic objectForKey:AIRKOREA_KEY_PM25_24HOUR];
    }
    [self.pm25Value setText:pm25];
    if(pm25.integerValue > 100){
        self.happinessPm25 = 0;
    }
    else if(pm25.integerValue > 30){
        self.happinessPm25 = 50;
    }
    else{
        self.happinessPm25 = 100;
    }
    NSString * pm10 = [self.dataDic objectForKey:AIRKOREA_KEY_PM10];
    if(pm10==nil || [pm10 isEqualToString:@"-"]){
        pm10 = [self.dataDic objectForKey:AIRKOREA_KEY_PM10_24HOUR];
    }
    [self.pm10Value setText:pm10];
    if(pm10.integerValue > 100){
        self.happinessPm10 = 0;
    }
    else if(pm10.integerValue > 30){
        self.happinessPm10 = 50;
    }
    else{
        self.happinessPm10 = 100;
    }
    [self.faceViewPm10 reset];
    [self.faceViewPm10 setDelegate:self];
    [self.faceViewPm10 setNeedsDisplay];
    
    [self.faceViewPm25 reset];
    [self.faceViewPm25 setDelegate:self];
    [self.faceViewPm25 setNeedsDisplay];
}
-(CGFloat)smilenessForFaceView:(FaceView *)requestor{
    CGFloat smileness = 0.0;
    if(requestor == self.faceViewPm10){
        smileness = [[self class] happinessToSmileness:self.happinessPm10];
    }
    if(requestor == self.faceViewPm25){
        smileness = [[self class] happinessToSmileness:self.happinessPm25];
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

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

@end
