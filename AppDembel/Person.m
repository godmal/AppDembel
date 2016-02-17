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

-(instancetype)initWithName:(NSString*) name andDate:(NSDate*) date {
    self = [super init];
    if (self) {
        self.name = name;
        self.date = date;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}

-(NSDate*)calculateDemobilizationDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:365];
    return [[DateUtils getCalendar] dateByAddingComponents:components toDate:self.date options:0];
}

-(float) calculateProgress {
    NSDate* today = [NSDate date];
    float servedDays = [DateUtils getDaysBetween:self.date and:today];
    float allDays = [DateUtils getDaysBetween:self.date and:[self calculateDemobilizationDate]];
    return servedDays / allDays;
}

@end
