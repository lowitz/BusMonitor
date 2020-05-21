//
//  InsetLabel.h
//  BusMonitor
//
//  Created by Love Mowitz on 2020-05-21.
//  Copyright © 2020 Love Mowitz. All rights reserved.
//

#import <UIKit/UILabel.h>

@interface InsetLabel : UILabel

-(void)drawTextInRect:(CGRect)rect;
-(CGSize)sizeThatFits:(CGSize)size;

@property (nonatomic) IBInspectable UIEdgeInsets contentInsets;

@end
