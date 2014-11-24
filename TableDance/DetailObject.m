//
//  DetailObject.m
//  TableDance
//
//  Created by Christian Beck on 24.11.14.
//  Copyright (c) 2014 Christian Beck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailObject.h"

@interface DetailObject ()

@property NSString *title;
@property NSDate *date;

@end

@implementation DetailObject

- (id)initWithTitle:(NSString *)title andDate:(NSDate *)date {
    if (!(self = [super init])) {
        return nil;
    }
    
    self.title = title;
    self.date = date;
    
    return self;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"title '%@', date '%@'", self.title, [self.date description]];
}

@end