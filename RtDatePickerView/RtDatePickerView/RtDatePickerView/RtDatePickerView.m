//
//  RtDatePickerView.m
//  CustomDatePicker
//
//  Created by mac on 2019/1/8.
//  Copyright © 2019 onefiter. All rights reserved.
//

#import "RtDatePickerView.h"
@interface RtDatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) NSCalendar *calendar;
@property (nonatomic,strong) NSDateComponents *minComponents;
@property (nonatomic,strong) NSDateComponents *maxComponents;
@property (nonatomic,strong) NSDateComponents *currentComponents;
@property (nonatomic,strong) NSDate *currentDate;
@property(nonatomic,strong) NSDateFormatter *formatter;
@end

@implementation RtDatePickerView

+ (instancetype)createFromNibWithMinDate:(NSDate *)min andMaxDate:(NSDate *)max currentDate:(NSDate *)currentDate
{
    RtDatePickerView *pick = (RtDatePickerView *)[[NSBundle mainBundle] loadNibNamed:@"RtDatePickerView" owner:self options:nil].firstObject;
    [pick customerInitWithMinDate:min andMaxDate:max currentDate:currentDate];
    return pick;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _calendar;
}

- (void)setMinDate:(NSDate *)minDate
{
    _minDate = minDate;
    _minComponents = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_minDate];
}

- (void)setMaxDate:(NSDate *)maxDate
{
    _maxDate = maxDate;
    _maxComponents = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_maxDate];
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    _currentComponents = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_currentDate];
}

- (void)customerInitWithMinDate:(NSDate *)min andMaxDate:(NSDate *)max currentDate:(NSDate *)currentDate {
    self.minDate = min;
    self.maxDate = max;
    self.currentDate = currentDate;
    [self scrollRow];
}

- (void)scrollRow
{
//    NSDateComponents *intervalCom = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.minDate toDate:self.currentDate options:NSCalendarWrapComponents];
    self.formatter.dateFormat = @"yyyy";
    NSString *minyear = [self.formatter stringFromDate:self.minDate];
    NSString *curyear = [self.formatter stringFromDate:self.currentDate];
//    intervalCom.year + (intervalCom.month + self.minComponents.month - 1) / 12
    if (self.currentComponents.year == self.minComponents.year) {
       
        [self.pickView selectRow:curyear.integerValue - minyear.integerValue inComponent:0 animated:YES];
        [self.pickView selectRow:self.currentComponents.month - self.minComponents.month inComponent:1 animated:YES];
        [self.pickView selectRow:self.currentComponents.day - self.minComponents.day inComponent:2 animated:YES];
    }else{
        
        [self.pickView selectRow:curyear.integerValue - minyear.integerValue inComponent:0 animated:YES];
        [self.pickView selectRow:self.currentComponents.month - 1 inComponent:1 animated:YES];
        [self.pickView selectRow:self.currentComponents.day - 1 inComponent:2 animated:YES];
    }
}

#pragma <UIPickerViewDelegate,UIPickerViewDataSource>

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
        
    if (component == 0) {
        return self.maxComponents.year - self.minComponents.year + 1;
    }else if (component == 1){
        if (self.currentComponents.year == self.minComponents.year) {
            return 12 - self.minComponents.month + 1;
        }else if (self.currentComponents.year == self.maxComponents.year) {
            return self.maxComponents.month;
        }else{
            NSRange rangemonth = [self.calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self.minDate];
            return rangemonth.length;
        }
    }else if (component == 2){
        NSRange rangeday = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.currentDate];
        if (self.currentComponents.year == self.minComponents.year
            && self.currentComponents.month == self.minComponents.month) {
            return rangeday.length - self.minComponents.day + 1;
        }else if (self.currentComponents.year == self.maxComponents.year
                  && self.currentComponents.month == self.maxComponents.month){
            return self.maxComponents.day;
        }else{
            return rangeday.length;
        }
    }
    return 0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDateComponents *year = [[NSDateComponents alloc] init];
    NSString *returnStr = @"";
    if (component == 0) {
        [year setValue:row forComponent:NSCalendarUnitYear];
        self.formatter.dateFormat = @"yyyy";
        returnStr = [self.formatter stringFromDate:[self.calendar dateByAddingComponents:year toDate:self.minDate options:NSCalendarWrapComponents]];
        return [NSString stringWithFormat:@"%@年",returnStr];
    }else if (component == 1){
        [year setValue:[pickerView selectedRowInComponent:0] forComponent:NSCalendarUnitYear];
        if (self.currentComponents.year == self.minComponents.year) {
            [year setValue:row forComponent:NSCalendarUnitMonth];
            NSDate *month = [self.calendar dateByAddingComponents:year toDate:self.minDate options:NSCalendarWrapComponents];
            self.formatter.dateFormat = @"MM";
            returnStr = [self.formatter stringFromDate:month];
        }else if (self.currentComponents.year == self.maxComponents.year) {
            
            [year setValue:row forComponent:NSCalendarUnitMonth];
            NSString *currentYear =[NSString stringWithFormat:@"%@-01-01",[[self pickerView:self.pickView titleForRow:0 forComponent:0] substringToIndex:4]];
            NSDate *month = [self.calendar dateByAddingComponents:year toDate:[self getDateWithType:currentYear] options:NSCalendarWrapComponents];
            self.formatter.dateFormat = @"MM";
            returnStr = [self.formatter stringFromDate:month];
        }else{
            returnStr = [NSString stringWithFormat:@"%@%@",row > 8?@"":@"0",@(row + 1)];
        }
        return [NSString stringWithFormat:@"%@月",returnStr];
    }else if (component == 2){
        [year setValue:[pickerView selectedRowInComponent:0] forComponent:NSCalendarUnitYear];
        [year setValue:[pickerView selectedRowInComponent:1] forComponent:NSCalendarUnitMonth];
        if (self.currentComponents.year == self.minComponents.year
            && self.currentComponents.month == self.minComponents.month) {
            [year setValue:row forComponent:NSCalendarUnitDay];
            NSDate *day = [self.calendar dateByAddingComponents:year toDate:self.minDate options:NSCalendarWrapComponents];
            self.formatter.dateFormat = @"dd";
            returnStr = [self.formatter stringFromDate:day];
        }else if (self.currentComponents.year == self.maxComponents.year
                  && self.currentComponents.month == self.maxComponents.month) {
            [year setValue:row forComponent:NSCalendarUnitDay];
            
            NSString *currentYear =[NSString stringWithFormat:@"%@-01-01",[[self pickerView:self.pickView titleForRow:0 forComponent:0] substringToIndex:4]];
            NSDate *day = [self.calendar dateByAddingComponents:year toDate:[self getDateWithType:currentYear] options:NSCalendarWrapComponents];
            self.formatter.dateFormat = @"dd";
            returnStr = [self.formatter stringFromDate:day];
        }else{
            returnStr = [NSString stringWithFormat:@"%@%@",row > 8?@"":@"0",@(row + 1)];
        }
        return [NSString stringWithFormat:@"%@日",returnStr];
    }
    return @"--";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSDateComponents *dateCom = [[NSDateComponents alloc] init];
    [dateCom setValue:[pickerView selectedRowInComponent:0] forComponent:NSCalendarUnitYear];
    [dateCom setValue:[pickerView selectedRowInComponent:1] forComponent:NSCalendarUnitMonth];
    [dateCom setValue:[pickerView selectedRowInComponent:2] forComponent:NSCalendarUnitDay];
    NSDate *date = nil;
    if (self.currentComponents.year == self.minComponents.year) {
         date = [self.calendar dateByAddingComponents:dateCom toDate:self.minDate options:NSCalendarWrapComponents];
//    }else if (self.currentComponents.year == self.maxComponents.year) {
    }else{
        NSString *currentYear =[NSString stringWithFormat:@"%@-01-01",[[self pickerView:self.pickView titleForRow:0 forComponent:0] substringToIndex:4]];
        date = [self.calendar dateByAddingComponents:dateCom toDate:[self getDateWithType:currentYear] options:NSCalendarWrapComponents];
    }
    NSDateComponents *dateComponent = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    self.currentDate = [self.calendar dateFromComponents:dateComponent];
    if ([self.currentDate compare:self.minDate] == NSOrderedAscending) {
        self.currentDate = self.minDate;
    }
    if ([self.currentDate compare:self.maxDate] == NSOrderedDescending) {
        self.currentDate = self.maxDate;
        [self.pickView reloadComponent:1];
    }
    if (component == 0) {
        [self.pickView reloadComponent:1];
        [self.pickView reloadComponent:2];
    }else if (component == 1){
        [self.pickView reloadComponent:2];
    }
    [self scrollRow];
}

- (NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [_formatter setTimeZone:timeZone];
        _formatter.locale = [NSLocale currentLocale];
    }
    return _formatter;
}

- (NSDate *)getDateWithType:(NSString *)type
{
    NSString *format = @"yyyy-MM-dd";
   
    [self.formatter setDateFormat:format];
    NSDate *confromTimes = [self.formatter dateFromString:type];
    return confromTimes;
}

                                       
- (IBAction)backClick:(id)sender {
    [self removeFromSuperview];
}

- (void)showInView:(UIView *)view
{
    self.frame = view.bounds;
    
    [view addSubview:self];
}
- (IBAction)selectFinish:(id)sender {
    if (self.selectFinish) {
        self.selectFinish(self.currentDate);
    }
    [self removeFromSuperview];
}


@end
