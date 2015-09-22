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
    NSMutableArray *paddlItems;

}


@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    ballSize = CGSizeMake(10, 10);
    CGRect currentScreen = [WKInterfaceDevice currentDevice].screenBounds;
    
    NSLog(@"%@", CGRectCreateDictionaryRepresentation([WKInterfaceDevice currentDevice].screenBounds));
    
    gameSize = CGSizeMake(currentScreen.size.width-3, currentScreen.size.height-20);
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
    if (ballPosition.y+ballSize.height>=gameSize.height-playerPaddle.size.height) {
        if (ballPosition.x >= playerPaddle.origin.x && ballPosition.x<playerPaddle.origin.x+playerPaddle.size.width) {
            ballVelocity = CGVectorMake(ballVelocity.dx, ballVelocity.dy*-1);
        } else {
            
        }
     
         ballVelocity = CGVectorMake(ballVelocity.dx, ballVelocity.dy*-1);
    }
    
    [self.ballContainer setContentInset:UIEdgeInsetsMake(ballPosition.y, ballPosition.x, 0, 0)];
    
    
}

- (IBAction)pickerItemSelectedNSIntegerindex:(NSInteger)value
{
    playerPaddle = CGRectMake((value/(CGFloat)paddlItems.count)*gameSize.width, 0, gameSize.width*0.2 , 10);
    
}
@end



