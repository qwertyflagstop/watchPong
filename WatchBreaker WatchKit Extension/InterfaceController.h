//
//  InterfaceController.h
//  WatchBreaker WatchKit Extension
//
//  Created by Nicholas Peretti on 9/14/15.
//  Copyright © 2015 Nicholas Peretti. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController 

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *ball;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *ballContainer;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfacePicker *paddlePicker;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *computerPlayerContainer;
- (IBAction)pickerItemSelectedNSIntegerindex:(NSInteger)value;

@end
