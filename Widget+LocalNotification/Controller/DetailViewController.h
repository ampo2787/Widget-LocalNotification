//
//  DetailViewController.h
//  Widget+LocalNotification
//
//  Created by JihoonPark on 05/12/2018.
//  Copyright © 2018 JihoonPark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirKoreaData.h"
#import "FaceView.h"

@interface DetailViewController : UIViewController<FaceViewDelegate>

@property (nonatomic, strong)NSDictionary *dataDic;

@end
