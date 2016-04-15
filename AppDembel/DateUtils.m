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
    if ([self isBeforeNow:personDate]) {
        NSDate* minLimitDate = [self calculateMinLimitDate];
        return !([self is:personDate Before:minLimitDate] && ![[self convertDateToString:personDate] isEqualToString:[self convertDateToString:minLimitDate]]);
    }
    return true;
}

+ (NSDate*) calculateMinLimitDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-365];
    return [[self getCalendar] dateByAddingComponents:components toDate:self.now options:0];
}

+ (BOOL) isAfterNow: (NSDate*) date {
    return date == [date laterDate: self.now];
}

+ (BOOL) isBeforeNow: (NSDate*) date {
    return [self is:date Before:self.now];
}

+ (BOOL) is: (NSDate*) firstDate Before: (NSDate*) secondDate {
    return firstDate == [firstDate earlierDate:secondDate];
}

+ (NSDate*) now {
    return [NSDate date];
}

@end