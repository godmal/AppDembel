//
//  Person.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 20.01.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "Person.h"
#import "DateUtils.h"

@implementation Person {

}

-(instancetype)initWithName:(NSString*) name andDate:(NSDate*) date andEndDate: (NSDate*) endDate {
    self = [super init];
    if (self) {
        self.name = name;
        self.date = date;
        self.endDate = endDate ? endDate : [self calculateEndDate];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.endDate forKey:@"endDate"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.endDate = [aDecoder decodeObjectForKey:@"endDate"];
        }
    return self;
}

-(NSDate*)calculateEndDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:365];
    return [[DateUtils getCalendar] dateByAddingComponents:components toDate:self.date options:0];
}

-(float) calculatePercentProgress {
    float servedDays = [DateUtils getDaysBetween:self.date and:[NSDate date]];
    float allDays = [DateUtils getDaysBetween:self.date and:_endDate];
    return servedDays / allDays * 100;
}

-(float) calculateLeftDays {
    return [DateUtils getDaysBetween:[NSDate date] and:_endDate];
}



@end