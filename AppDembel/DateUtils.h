//
//  DateUtils.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 10.02.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

+ (NSDateFormatter*) getFormatter;
+ (NSDateFormatter*) getFormatterWithTime;
+ (NSCalendar*) getCalendar;
+ (float) getDaysBetween:(NSDate*) firstDate and:(NSDate*) secondDate;
+ (NSDictionary*) getUnitsBetween: (NSDate*) firstDate and:(NSDate*) secondDate;
+ (NSString*) convertDateToString:(NSDate*) date;
+ (BOOL) isValid:(NSDate*) personDate;
+ (NSDate*) minLimitDate;
+ (BOOL) isAfterNow: (NSDate*) date;
+ (NSDate*) now;
+ (NSDate*) configureCountDownWithDate: (NSDate*) personDate;

@end
