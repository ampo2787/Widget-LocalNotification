//
//  AirKoreaData.h
//  TodayWidget
//
//  Created by SangGil Lee on 02/12/2018.
//  Copyright © 2018 Forscher Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AIRKOREA_KEY_STATION_NAME   @"stationName"
#define AIRKOREA_KEY_MANG_NAME      @"mangName"
#define AIRKOREA_KEY_DATA_TIME      @"dataTime"

#define AIRKOREA_KEY_SO2            @"so2Value"
#define AIRKOREA_KEY_CO             @"coValue"
#define AIRKOREA_KEY_O3             @"o3Value"
#define AIRKOREA_KEY_PM10           @"pm10Value"
#define AIRKOREA_KEY_PM10_24HOUR    @"pm10Value24"
#define AIRKOREA_KEY_PM25           @"pm25Value"
#define AIRKOREA_KEY_PM25_24HOUR    @"pm25Value24"


typedef void (^completionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

@interface AirKoreaData : NSObject
+ (NSString *)AirKoreaRestURL;
+ (void)getDataFromServer:(NSString *)url completionHandler:(completionHandler _Nullable )handler;
@end
