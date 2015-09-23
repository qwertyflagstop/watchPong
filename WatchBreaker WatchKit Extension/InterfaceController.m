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
    CGRect playerPaddle;
    CGRect aiPaddle;
    NSMutableArray *paddlItems;
    NSInteger AILevel;
    NSInteger p1Score;
    NSInteger p2Score;
    BOOL paused;

}


@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    ballSize = CGSizeMake(10, 10);
    CGRect currentScreen = [WKInterfaceDevice currentDevice].screenBounds;
    
    gameSize = CGSizeMake(currentScreen.size.width-3, currentScreen.size.height-20);
    
    aiPaddle = CGRectMake(gameSize.width/2.0-(25/2.0), 0, 25, 10);
    paddlItems = [NSMutableArray new];
    for (int i = 0; i<30; i++)
    {
        WKImage *image = [WKImage imageWithImageName:[NSString stringWithFormat:@"p%i",i]];
        WKPickerItem *item = [[WKPickerItem alloc]init];
        item.contentImage = image;
        [paddlItems addObject:item];
    }
    [self.paddlePicker setItems:[NSArray arrayWithArray:paddlItems]];
    [self.paddlePicker setSelectedItemIndex:paddlItems.count/2];
    [self resetBall];
    [NSTimer scheduledTimerWithTimeInterval:0.033 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
    p1Score = 0;
    p2Score = 0;
    
    paused = true;
    // Configure interface objects here.
}

-(void)resetBall
{
    
    ballPosition = CGPointMake(gameSize.width/2.0-ballSize.width/2.0, gameSize.height/2.0-ballSize.height/2.0);
    float xDir = arc4random()%10>=4 ? -1.5-(arc4random()%50/50.0) : 1.2+-(arc4random()%50/50.0);
    float yDir = arc4random()%10>=4 ? -1.5-(arc4random()%50/50.0) : 1.3+(arc4random()%50/50.0);
    ballVelocity = CGVectorMake(xDir, yDir);
    paused = true;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        paused = false;
    });
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    paused = true;
    [self setTitle:[NSString stringWithFormat:@"%i - %i",p1Score,p2Score]];
    [self resetBall];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void)gameLoop
{
    if (paused) {
        [self.ballContainer setContentInset:UIEdgeInsetsMake(ballPosition.y, ballPosition.x, 0, 0)];
        return;
    }
    
    ballPosition = CGPointMake(ballPosition.x+ballVelocity.dx, ballPosition.y+ballVelocity.dy);
    
    if (ballPosition.x<=0) {
        ballVelocity = CGVectorMake(ballVelocity.dx*-1, ballVelocity.dy);
        ballPosition = CGPointMake(1, ballPosition.y);
    }
    if (ballPosition.x+ballSize.width>=gameSize.width) {
        ballVelocity = CGVectorMake(ballVelocity.dx*-1, ballVelocity.dy);
        ballPosition = CGPointMake(gameSize.width-ballSize.width, ballPosition.y);
    }
    
    
    if (ballPosition.y+ballSize.height>=gameSize.height-playerPaddle.size.height-10) {
        if (ballVelocity.dy>0) {
            if (ballPosition.x >= playerPaddle.origin.x - ballSize.width&& ballPosition.x<playerPaddle.origin.x+playerPaddle.size.width)
            {
                CGFloat xFaster = (arc4random()%200)/1000.0;
                CGFloat yFaster = (arc4random()%200)/1000.0;
                ballVelocity = CGVectorMake(ballVelocity.dx*(1+xFaster), ballVelocity.dy*-(1+yFaster));
            }
        }
    }
    
    if (ballPosition.y<=0) {
        
        if(ballPosition.x > aiPaddle.origin.x-ballSize.width && ballPosition.x<aiPaddle.origin.x+aiPaddle.size.width)
        {
            ballVelocity = CGVectorMake(ballVelocity.dx, ballVelocity.dy*-1.0);
            ballPosition = CGPointMake(ballPosition.x, 1);
        }
    }
    //what
    //why
    //time money
    [self.ballContainer setContentInset:UIEdgeInsetsMake(ballPosition.y, ballPosition.x, 0, 0)];
    [self makeAIMove];
    
}


-(void)makeAIMove
{
   
    CGFloat aix = ballPosition.x-aiPaddle.size.width*0.5;
    if (aix<0) {
        aix=0;
    }
    if (aix>gameSize.width-aiPaddle.size.width) {
        aix = gameSize.width-aiPaddle.size.width;
    }
    aiPaddle = CGRectMake(aix, 0, 25, 10);
    [self.computerPlayerContainer setContentInset:UIEdgeInsetsMake(0, aix, 0, 0)];
}

- (IBAction)pickerItemSelectedNSIntegerindex:(NSInteger)value
{
    playerPaddle = CGRectMake((value/(CGFloat)paddlItems.count)*gameSize.width-(gameSize.width*0.1), 0, gameSize.width*0.2 , 10);
    
}
@end



