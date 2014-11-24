//
//  DetailViewController.h
//  TableDance
//
//  Created by Christian Beck on 23.11.14.
//  Copyright (c) 2014 Christian Beck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailObject.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) DetailObject *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

