//
//  Person.m
//  AppDembel
//
//  Created by Дмитрий Горбачев on 20.01.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import "Person.h"

@implementation Person {
    NSString* _name;
    NSString* _date;
}

-(instancetype)initWithName:(NSString*) name andDate:(NSString*) date {
    self = [super init];
    if (self) {
        _name = name;
        _date = date;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_date forKey:@"date"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}

@end
