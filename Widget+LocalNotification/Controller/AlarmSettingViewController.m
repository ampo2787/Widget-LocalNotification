//
//  AlarmSettingViewController.m
//  Widget+LocalNotification
//
//  Created by JihoonPark on 05/12/2018.
//  Copyright © 2018 JihoonPark. All rights reserved.
//

#import "AlarmSettingViewController.h"
@import UserNotifications;
@interface AlarmSettingViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *dpAlarmData;
@end

@implementation AlarmSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)saveAlarm:(UIBarButtonItem *)sender{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
    
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"미세먼지확인";
    content.body = @"오늘의 미세먼지를 확인해보세요!";
    content.sound = [UNNotificationSound defaultSound];
    
    NSDate *date = self.dpAlarmData.date;
    NSDateComponents *triggerDate =[[NSCalendar currentCalendar]components:NSCalendarUnitYear + NSCalendarUnitMonth + NSCalendarUnitDay + NSCalendarUnitHour + NSCalendarUnitMinute + NSCalendarUnitSecond fromDate:date];
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:YES];
    
    NSString *identifier = @"UYLLocalNotification";
    UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Something went wrong: %@", error);
        }
    }];
}

@end
