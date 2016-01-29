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
@property (strong, nonatomic) NSString* date;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(instancetype)initWithName:(NSString*) name andDate:(NSString*) date;
-(void)encodeWithCoder:(NSCoder *)aCoder;


@end
