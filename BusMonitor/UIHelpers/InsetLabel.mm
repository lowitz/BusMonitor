//
//  InsetLabel.m
//  BusMonitor
//
//  Created by Love Mowitz on 2020-05-21.
//  Copyright © 2020 Love Mowitz. All rights reserved.
//

#import "InsetLabel.h"

#import <UIKit/UIKit.h>

@implementation InsetLabel

- (void)drawTextInRect:(CGRect)rect {
    CGRect insetRect = UIEdgeInsetsInsetRect(rect, _contentInsets);
    [super drawTextInRect:insetRect];
}

- (CGSize)intrinsicContentSize {
    return [self addInsetsToSize:[super intrinsicContentSize]];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self addInsetsToSize:[super sizeThatFits:size]];
}

- (CGSize)addInsetsToSize:(CGSize)size {
    CGFloat width = size.width + _contentInsets.left + _contentInsets.right;
    CGFloat height = size.height + _contentInsets.top + _contentInsets.bottom;
    return CGSizeMake(width, height);
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    // This get's called when initialized through the interface builder
    // which is needed to set default values for the insets
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        self.contentInsets = UIEdgeInsetsMake(0.5f, 2.5f, 0.5f, 2.5f);
    }
    return self;
}

@end
