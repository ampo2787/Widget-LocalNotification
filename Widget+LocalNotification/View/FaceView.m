//
//  FaceView.m
//  Happiness_02_201402356
//
//  Created by JihoonPark on 2018. 9. 10..
//  Copyright © 2018년 JihoonPark. All rights reserved.
//

#import "FaceView.h"

#pragma mark - Declaration of Private Methods
@interface FaceView()

@property (nonatomic,readwrite) CGFloat faceScale;
@property (nonatomic,readonly) CGFloat smileness;

-(void) drawCircleAtCenterPoint:(CGPoint) centerPoint withRadius:(CGFloat) radius inContext:(CGContextRef) context;
-(void) drawFaceAtCenterPoint:(CGPoint) centerPoint withRadius:(CGFloat) radius inContext:(CGContextRef) context;
-(void) drawEyesBasedOnFaceCenterPoint:(CGPoint) faceCenterPoint withRadius:(CGFloat) faceRadius inContext:(CGContextRef) context;
-(void) drawNoseBasedOnFaceCenterPoint:(CGPoint) faceCenterPoint withRadius:(CGFloat) faceRadius inContext:(CGContextRef) context;
-(void) drawMouthBasedOnFaceCenterPoint:(CGPoint) faceCenterPoint withRadius:(CGFloat) faceRadius inContext:(CGContextRef) context;
-(void) drawEyebrowBasedOnFaceCenterPoint:(CGPoint) faceCenterPoint withRadius:(CGFloat) faceRadius inContext:(CGContextRef)context;
-(void) drawEyebrow2BasedOnFaceCenterPoint:(CGPoint) faceCenterPoint withRadius:(CGFloat) faceRadius inContext:(CGContextRef)context;
@end

#pragma mark - Implementation of "FaceView" methods

@implementation FaceView

#pragma mark - Class Method

#define MIN_FACE_SCALE  0.05
#define MAX_FACE_SCALE  1.5
#define DEFAULT_FACE_SCALE  0.9

-(void) reset {
    self.faceScale = DEFAULT_FACE_SCALE;
}

- (void) setFaceScale:(CGFloat)newScale {
    if(newScale < MIN_FACE_SCALE){
        _faceScale = MIN_FACE_SCALE;
    }
    else if(newScale > MAX_FACE_SCALE){
        _faceScale = MAX_FACE_SCALE;
    }
    else{
        _faceScale = newScale;
    }
}

#pragma mark - Property Implementation

#define MAX_SMILENESS   +1.0
#define MIN_SMILENESS   -1.0

-(CGFloat) smileness{
    CGFloat _smileness = [self.delegate smilenessForFaceView:self];
    if(_smileness < MIN_SMILENESS){
        _smileness = MIN_SMILENESS;
    }
    else if(_smileness > MAX_SMILENESS){
        _smileness = MAX_SMILENESS;
    }
    return _smileness;
}

-(void)drawRect:(CGRect)dirtyRect {
    CGPoint faceCenterPoint;
    faceCenterPoint.x = self.bounds.origin.x + self.bounds.size.width / 2;
    faceCenterPoint.y = self.bounds.origin.y + self.bounds.size.height / 2;
    
    CGFloat faceRadius = self.bounds.size.width / 2;
    if(self.bounds.size.width > self.bounds.size.height){
        faceRadius = self.bounds.size.height / 2;
    }
    faceRadius *= self.faceScale;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawFaceAtCenterPoint:faceCenterPoint withRadius:faceRadius inContext:context];
    [self drawEyesBasedOnFaceCenterPoint:faceCenterPoint withRadius:faceRadius inContext:context];
    [self drawMouthBasedOnFaceCenterPoint:faceCenterPoint withRadius:faceRadius inContext:context];
    [self drawNoseBasedOnFaceCenterPoint:faceCenterPoint withRadius:faceRadius inContext:context];
    [self drawEyebrowBasedOnFaceCenterPoint:faceCenterPoint withRadius:faceRadius inContext:context];
    [self drawEyebrow2BasedOnFaceCenterPoint:faceCenterPoint withRadius:faceRadius inContext:context];
    
}

-(void) drawFaceAtCenterPoint:(CGPoint)centerPoint withRadius:(CGFloat)radius inContext:(CGContextRef)context{
    [[UIColor darkGrayColor]setFill];
    [self drawCircleAtCenterPoint:centerPoint withRadius:radius inContext:context];
}

#pragma mark - private methods for drawRect()
#define CLOCKWISE 1;
- (void) drawCircleAtCenterPoint:(CGPoint)centerPoint withRadius:(CGFloat)radius inContext:(CGContextRef)context{
    CGFloat startAngle = 0.0;
    CGFloat endAngle = 2.0 * M_PI;
    int drawingDirection = CLOCKWISE;
    
    UIGraphicsPushContext(context);
    {
        CGContextBeginPath(context);
        {
            CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, drawingDirection);
            CGContextFillPath(context);
        }
        CGContextStrokePath(context);
    }
    UIGraphicsPopContext();
    
}

#define NOSE_HorizontalOffsetRatio  0.0
#define NOSE_VerticalOffsetRatio    0.1
#define NOSE_RadiusRatio            0.09

- (void) drawNoseBasedOnFaceCenterPoint:(CGPoint)faceCenterPoint withRadius:(CGFloat)faceRadius inContext:(CGContextRef)context{
    CGPoint noseCenterPoint = faceCenterPoint;
    noseCenterPoint.y = faceCenterPoint.y + faceRadius * NOSE_VerticalOffsetRatio;
    [[UIColor orangeColor] setFill];
    [self drawCircleAtCenterPoint:noseCenterPoint withRadius:faceRadius*NOSE_RadiusRatio inContext:context];
}

#define EYEBROW_HorizontalOffsetRatio 0.6
#define EYEBROW_VerticalOffsetRatio 0.5
#define EYEBROW_RadiusRatio 0.02

-(void) drawEyebrowBasedOnFaceCenterPoint:(CGPoint) faceCenterPoint withRadius:(CGFloat) faceRadius inContext:(CGContextRef)context
{
    CGPoint eyebrowLeftPoint;
    CGFloat eyebrowHorizontalOffset = faceRadius * EYEBROW_HorizontalOffsetRatio;
    CGFloat eyebrowVerticalOffset = faceRadius * EYEBROW_VerticalOffsetRatio;
    eyebrowLeftPoint.x = faceCenterPoint.x - eyebrowHorizontalOffset;
    eyebrowLeftPoint.y = faceCenterPoint.y - eyebrowVerticalOffset;
    
    CGPoint eyebrowRightPoint;
    eyebrowRightPoint.x = faceCenterPoint.x - eyebrowHorizontalOffset/5;
    eyebrowRightPoint.y = faceCenterPoint.y - eyebrowVerticalOffset;
    
    CGPoint eyebrowLeftControlPoint = eyebrowLeftPoint;
    //eyebrowLeftControlPoint.x -= eyebrowHorizontalOffset/100;
    CGPoint eyebrowRightControlPoint = eyebrowRightPoint;
    //eyebrowRightControlPoint.x -= eyebrowHorizontalOffset/20;
    
    CGFloat smileOffset = (faceRadius * EYEBROW_RadiusRatio) * self.smileness;
    eyebrowLeftControlPoint.y -= smileOffset;
    eyebrowRightControlPoint.y -= smileOffset;
    
    CGContextSetLineWidth(context, 0.5);
    [[UIColor redColor] setStroke];
    [[UIColor redColor] setFill];
    
    UIGraphicsPushContext(context);
    {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, eyebrowLeftPoint.x, eyebrowLeftPoint.y);
        if(fabs(smileOffset) < 1){
            CGContextAddLineToPoint(context, eyebrowRightPoint.x, eyebrowRightPoint.y);
            CGContextStrokePath(context);
        }
        else{
            CGContextAddCurveToPoint(context, eyebrowLeftControlPoint.x, eyebrowLeftControlPoint.y, eyebrowRightControlPoint.x, eyebrowRightControlPoint.y, eyebrowRightPoint.x, eyebrowRightPoint.y);
            CGContextMoveToPoint(context, eyebrowRightPoint.x, eyebrowRightPoint.y);
            CGContextAddCurveToPoint(context, eyebrowRightControlPoint.x, eyebrowRightControlPoint.y-smileOffset/2, eyebrowLeftControlPoint.x, eyebrowLeftControlPoint.y-smileOffset/2, eyebrowLeftPoint.x, eyebrowLeftPoint.y);
            CGContextFillPath(context);
        }
    }
    UIGraphicsPopContext();
}

-(void) drawEyebrow2BasedOnFaceCenterPoint:(CGPoint) faceCenterPoint withRadius:(CGFloat) faceRadius inContext:(CGContextRef)context
{
    CGPoint eyebrowLeftPoint;
    CGFloat eyebrowHorizontalOffset = faceRadius * EYEBROW_HorizontalOffsetRatio;
    CGFloat eyebrowVerticalOffset = faceRadius * EYEBROW_VerticalOffsetRatio;
    eyebrowLeftPoint.x = faceCenterPoint.x + eyebrowHorizontalOffset/5;
    eyebrowLeftPoint.y = faceCenterPoint.y - eyebrowVerticalOffset;
    
    CGPoint eyebrowRightPoint;
    eyebrowRightPoint.x = faceCenterPoint.x + eyebrowHorizontalOffset;
    eyebrowRightPoint.y = faceCenterPoint.y - eyebrowVerticalOffset;
    
    CGPoint eyebrowLeftControlPoint = eyebrowLeftPoint;
    //eyebrowLeftControlPoint.x -= eyebrowHorizontalOffset/100;
    CGPoint eyebrowRightControlPoint = eyebrowRightPoint;
    //eyebrowRightControlPoint.x -= eyebrowHorizontalOffset/20;
    
    CGFloat smileOffset = (faceRadius * EYEBROW_RadiusRatio) * self.smileness;
    eyebrowLeftControlPoint.y -= smileOffset;
    eyebrowRightControlPoint.y -= smileOffset;
    
    CGContextSetLineWidth(context, 0.5);
    [[UIColor redColor] setStroke];
    [[UIColor redColor] setFill];
    
    UIGraphicsPushContext(context);
    {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, eyebrowLeftPoint.x, eyebrowLeftPoint.y);
        if(fabs(smileOffset) < 1){
            CGContextAddLineToPoint(context, eyebrowRightPoint.x, eyebrowRightPoint.y);
            CGContextStrokePath(context);
        }
        else{
            CGContextAddCurveToPoint(context, eyebrowLeftControlPoint.x, eyebrowLeftControlPoint.y, eyebrowRightControlPoint.x, eyebrowRightControlPoint.y, eyebrowRightPoint.x, eyebrowRightPoint.y);
            CGContextMoveToPoint(context, eyebrowRightPoint.x, eyebrowRightPoint.y);
            CGContextAddCurveToPoint(context, eyebrowRightControlPoint.x, eyebrowRightControlPoint.y-smileOffset/2, eyebrowLeftControlPoint.x, eyebrowLeftControlPoint.y-smileOffset/2, eyebrowLeftPoint.x, eyebrowLeftPoint.y);
            CGContextFillPath(context);
        }
    }
    UIGraphicsPopContext();
}


#define EYE_HorizontalOffsetRatio  0.35
#define EYE_VerticalOffsetRatio    0.30
#define EYE_RadiusRatio            0.15

-(void) drawEyesBasedOnFaceCenterPoint:(CGPoint)faceCenterPoint withRadius:(CGFloat)faceRadius inContext:(CGContextRef)context{
    CGPoint eyePoint;
    CGFloat eyeHorizontalOffset = faceRadius * EYE_HorizontalOffsetRatio;
    CGFloat eyeVerticalOffset = faceRadius * EYE_VerticalOffsetRatio;
    CGFloat eyeRadius = faceRadius * EYE_RadiusRatio;
    
    eyePoint.x = faceCenterPoint.x - eyeHorizontalOffset;
    eyePoint.y = faceCenterPoint.y - eyeVerticalOffset;
    
    [[UIColor cyanColor] setFill];
    [self drawCircleAtCenterPoint:eyePoint withRadius:eyeRadius inContext:context];
    eyePoint.x = faceCenterPoint.x + eyeHorizontalOffset;
    [self drawCircleAtCenterPoint:eyePoint withRadius:eyeRadius inContext:context];
}

#define MOUTH_HorizontalOffsetRatio  0.45
#define MOUTH_VerticalOffsetRatio    0.5
#define MOUTH_RadiusRatio            0.3

-(void)drawMouthBasedOnFaceCenterPoint:(CGPoint)faceCenterPoint withRadius:(CGFloat)faceRadius inContext:(CGContextRef)context{
   
    CGPoint mouthLeftPoint;
    CGFloat mouthHorizontalOffset = faceRadius * MOUTH_HorizontalOffsetRatio;
    CGFloat mouthVerticalOffset = faceRadius * MOUTH_VerticalOffsetRatio;
    mouthLeftPoint.x = faceCenterPoint.x - mouthHorizontalOffset;
    mouthLeftPoint.y = faceCenterPoint.y + mouthVerticalOffset;
    
    CGPoint mouthRightPoint;
    mouthRightPoint.x = faceCenterPoint.x + mouthHorizontalOffset;
    mouthRightPoint.y = faceCenterPoint.y + mouthVerticalOffset;
    
    CGPoint mouthLeftControlPoint = mouthLeftPoint;
    mouthLeftControlPoint.x += mouthHorizontalOffset * (2.0/3.0);
    CGPoint mouthRightControlPoint = mouthRightPoint;
    mouthRightControlPoint.x -= mouthHorizontalOffset * (2.0/3.0);
    
    CGFloat smileOffset = (faceRadius * MOUTH_RadiusRatio) * self.smileness;
    mouthLeftControlPoint.y += smileOffset;
    mouthRightControlPoint.y += smileOffset;
    
    CGContextSetLineWidth(context, 0.5);
    [[UIColor greenColor] setStroke];
    [[UIColor greenColor] setFill];
    
    UIGraphicsPushContext(context);
    {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, mouthLeftPoint.x, mouthLeftPoint.y);
        if(fabs(smileOffset) < 1){
            CGContextAddLineToPoint(context, mouthRightPoint.x, mouthRightPoint.y);
            CGContextStrokePath(context);
        }
        else{
            CGContextAddCurveToPoint(context, mouthLeftControlPoint.x, mouthLeftControlPoint.y, mouthRightControlPoint.x, mouthRightControlPoint.y, mouthRightPoint.x, mouthRightPoint.y);
            CGContextMoveToPoint(context, mouthRightPoint.x, mouthRightPoint.y);
            CGContextAddCurveToPoint(context, mouthRightControlPoint.x, mouthRightControlPoint.y-smileOffset/2, mouthLeftControlPoint.x, mouthLeftControlPoint.y-smileOffset/2, mouthLeftPoint.x, mouthLeftPoint.y);
            CGContextFillPath(context);
        }
    }
    UIGraphicsPopContext();
}

#pragma mark - Reflect the new face scale By Pinch Gesture
-(IBAction)pinchGestureRecognized:(UIPinchGestureRecognizer *)sender{
    if((sender.state == UIGestureRecognizerStateChanged) || (sender.state == UIGestureRecognizerStateEnded)){
        self.faceScale *= sender.scale;
        sender.scale = 1.0;
        [self setNeedsDisplay];
    }
}



@end
