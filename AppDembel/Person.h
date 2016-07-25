//
//  Person.h
//  AppDembel
//
//  Created by Дмитрий Горбачев on 20.01.16.
//  Copyright © 2016 Дмитрий Горбачев. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSDate* date;
@property (strong, nonatomic) NSDate* endDate;


-(instancetype)initWithName:(NSString*) name andDate:(NSDate*) date andEndDate: (NSDate*) endDate;
-(instancetype)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
-(NSDate*)calculateEndDate;
-(float) calculatePercentProgress;
-(float) calculateLeftDays;

@end
