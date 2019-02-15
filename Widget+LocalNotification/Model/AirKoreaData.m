
//
//  AirKoreaData.m
//  TodayWidget
//
//  Created by SangGil Lee on 02/12/2018.
//  Copyright © 2018 Forscher Labs. All rights reserved.
//

#import "AirKoreaData.h"
#define AIRKOREA_SERVICE_KEY    @"13DR0sgUtG429ie0YvnWTUCy1HdZtYPgjteJyxk2PFMi%2FxcsG5yfei0p6ppH1wjnJeWIQQAnecrHKdxURHOuoQ%3D%3D"
#define AIRKOREA_ENDPOINT_URL   @"http://openapi.airkorea.or.kr/"

@implementation AirKoreaData
+ (NSString *)EndPointURL
{
    return AIRKOREA_ENDPOINT_URL;
}
+ (NSString *)ServiceURL:( NSString * _Nullable )cityName
{
    if(cityName == nil) {
        cityName =@"대전";
    }
    // 한글 URL 깨짐 문제 해결
    NSCharacterSet *allowedCharacterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *requestCityName = [cityName stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    NSString * returnUrl =[NSString stringWithFormat:@"openapi/services/rest/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty?sidoName=%@&pageNo=1&numOfRows=10&ServiceKey=%@&ver=1.3"
                           , requestCityName
                           , [self ServiceKEY]];
    
    return returnUrl ;
}
+ (NSString *)ServiceKEY
{
    return AIRKOREA_SERVICE_KEY;
}
+ (NSString *)AirKoreaRestURL
{
    return [NSString stringWithFormat:@"%@%@", [self EndPointURL], [self ServiceURL:nil]];
}

+ (void)getDataFromServer:(NSString *)url completionHandler:(completionHandler _Nullable )handler
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask * getDataTask = [session dataTaskWithURL:[NSURL URLWithString:url]
                                                completionHandler:handler];
    
    
    [getDataTask resume];
}

@end
