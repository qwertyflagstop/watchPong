//
//  InterfaceController.m
//  WatchBreaker WatchKit Extension
//
//  Created by Nicholas Peretti on 9/14/15.
//  Copyright © 2015 Nicholas Peretti. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()
{
    CGPoint ballPosition;
    CGVector ballVelocity;
    CGSize ballSize;
    CGSize gameSize;

}


@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    ballSize = CGSizeMake(10, 10);
    CGRect currentScreen = [WKInterfaceDevice currentDevice].screenBounds;

    gameSize = CGSizeMake(currentScreen.size.height-19, currentScreen.size.width-3);

    
    
    ballPosition = CGPointMake(0, 0);
    ballVelocity = CGVectorMake(1.5, 1.5);
    [NSTimer scheduledTimerWithTimeInterval:0.033 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [self animateWithDuration:2.0 animations:^{
        
    }];
    
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void)gameLoop
{
    
    ballPosition = CGPointMake(ballPosition.x+ballVelocity.dx, ballPosition.y+ballVelocity.dy);
    
    if (ballPosition.x<=0) {
        ballVelocity = CGVectorMake(ballVelocity.dx*-1, ballVelocity.dy);
    }
    if (ballPosition.y<=0) {
        ballVelocity = CGVectorMake(ballVelocity.dx, ballVelocity.dy*-1);
    }
    
    if (ballPosition.x+ballSize.width>=gameSize.width) {
        ballVelocity = CGVectorMake(ballVelocity.dx*-1, ballVelocity.dy);
    }
    if (ballPosition.y+ballSize.height>=gameSize.height) {
        ballVelocity = CGVectorMake(ballVelocity.dx, ballVelocity.dy*-1);
    }
    
    [self.ballContainer setContentInset:UIEdgeInsetsMake(ballPosition.x, ballPosition.y, 0, 0)];
    
    
}

@end



