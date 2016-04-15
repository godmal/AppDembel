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

+ (BOOL) isValid:(NSDate*) personDate {
    return [self is:personDate AfterOrEquals:self.minLimitDate];
}

+ (BOOL) isAfterNow: (NSDate*) date {
    return [self is:date After:self.now];
}

+ (BOOL) is: (NSDate*) firstDate AfterOrEquals: (NSDate*) secondDate {
    return [self is:firstDate After:secondDate] || [self is:firstDate Equals:secondDate];
}

+ (BOOL) is: (NSDate*) firstDate After: (NSDate*) secondDate {
    return firstDate == [firstDate laterDate: secondDate];
}

+ (BOOL) is: (NSDate*) firstDate Equals: (NSDate*) secondDate {
    return [[self convertDateToString:firstDate] isEqualToString:[self convertDateToString:secondDate]];
}

+ (NSDate*) minLimitDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-365];
    return [[self getCalendar] dateByAddingComponents:components toDate:self.now options:0];
}

+ (NSDate*) now {
    return [NSDate date];
}

@end