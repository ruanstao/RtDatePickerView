//
//  ViewController.m
//  RtDatePickerView
//
//  Created by mac on 2019/1/8.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import "RtDatePickerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)show:(id)sender {
    RtDatePickerView *view = [RtDatePickerView createFromNibWithMinDate:[self getDateWithType:@"2015-05-02"] andMaxDate:[NSDate date] currentDate:[self getDateWithType:@"2018-06-12"]];
    [view showInView:self.view];
}



- (NSDate *)getDateWithType:(NSString *)type
{
    NSString *format = @"yyyy-MM-dd";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimes = [formatter dateFromString:type];
    return confromTimes;
}

@end
