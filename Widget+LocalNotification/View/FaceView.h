//
//  FaceView.h
//  Happiness_02_201402356
//
//  Created by JihoonPark on 2018. 9. 10..
//  Copyright © 2018년 JihoonPark. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FaceView;

#pragma mark - Declaration of <FaceViewDelegate>

@protocol FaceViewDelegate

-(CGFloat) smilenessForFaceView:(FaceView *) requestor;

@end

#pragma mark - Declaration of Public methods

@interface FaceView : UIView

-(void) reset;
@property (assign) id<FaceViewDelegate> delegate;

-(IBAction) pinchGestureRecognized:(UIPinchGestureRecognizer *)sender;

@end
