//
//  DateUtils.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 10.02.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

+ (NSDateFormatter*) getFormatter {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    return dateFormatter;
}

+ (NSString*) convertDateToString:(NSDate*) date {
    return [[self getFormatter] stringFromDate:date];
}

+ (NSCalendar*) getCalendar {
    return [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
}

+ (float) getDaysBetween:(NSDate*) firstDate and:(NSDate*) secondDate {
    return (float)[[[self getCalendar] components:NSCalendarUnitDay
                                                              fromDate:firstDate
                                                                toDate:secondDate
                                                               options:NSCalendarWrapComponents] day];
}

+ (BOOL) compareNowWith:(NSDate*) personDate {
    if (personDate == [personDate earlierDate:[NSDate date]]) {
        NSLog(@"lalalalala");
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:-365];
        NSDate* minDate = [[self getCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    
        if (personDate == [personDate earlierDate:minDate]) {
            NSLog(@"IDI NAHUI");
            return false;
        }
        return true;
    }
    return true;
}

@end