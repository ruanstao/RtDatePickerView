//
//  RtDatePickerView.h
//  CustomDatePicker
//
//  Created by mac on 2019/1/8.
//  Copyright © 2019 onefiter. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RtDatePickerView : UIView
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;

@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, copy) void (^selectFinish)(NSDate *date);

+ (instancetype)createFromNibWithMinDate:(NSDate *)min andMaxDate:(NSDate *)max currentDate:(NSDate *)currentDate;

- (void)showInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
