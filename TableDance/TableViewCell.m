//
//  TableViewCell.m
//  TableDance
//
//  Created by Christian Beck on 23.11.14.
//  Copyright (c) 2014 Christian Beck. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell {
    UIColor *backgroundColor;
    UIColor *highlightColor;
}

- (void)awakeFromNib {
    backgroundColor = self.leftBackground.backgroundColor;
    highlightColor = [backgroundColor colorWithAlphaComponent:0.5f];
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];

    if (highlighted) {
        self.leftBackground.backgroundColor = highlightColor;
        // den Hintergrund einen Punkt "zu hoch" beginnen und eine Punkt "zu tief" aufhören lassen
        // dadurch entstehen keine Haarlinien bei der Selektion bzw. beim Zurückkehren aus dem Detailview
        // TODO: mach das weg ;-)
        CGRect frame = self.leftBackground.frame;
        frame.origin.y -= 1;
        frame.size.height += 2;
        self.leftBackground.frame = frame;
    } else {
        self.leftBackground.backgroundColor = backgroundColor;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        [self leftBackground].backgroundColor = highlightColor;
    } else {
        [self leftBackground].backgroundColor = backgroundColor;
    }
}

@end
