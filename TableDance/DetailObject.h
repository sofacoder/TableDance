//
//  DetailObject.h
//  TableDance
//
//  Created by Christian Beck on 24.11.14.
//  Copyright (c) 2014 Christian Beck. All rights reserved.
//

@interface DetailObject : NSObject

@property (readonly) NSString *title;
@property (readonly) NSDate *date;

- (id)initWithTitle:(NSString *)title andDate:(NSDate *)date;

@end

