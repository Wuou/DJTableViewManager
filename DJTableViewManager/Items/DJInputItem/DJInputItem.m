//
//  DJInputItem.m
//  DJTableViewManagerSample
//
//  Created by DJ on 2018/4/20.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "DJInputItem.h"

@implementation DJInputItem

+ (instancetype)itemWithTitle:(NSString *)title value:(NSString *)value
{
    return [[self alloc] initWithTitle:title value:value];
}

+ (instancetype)itemWithTitle:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder
{
    return [[self alloc] initWithTitle:title value:value placeholder:placeholder];
}

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value
{
    return [self initWithTitle:title value:value placeholder:nil];
}

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder
{
    self = [super init];
    
    if (self)
    {
        self.isShowHighlightBg = NO;
        
        self.editable = YES;
        self.title = title;
        self.value = value;
        self.placeholder = placeholder;
    }
    
    return self;
}

- (void)setEditable:(BOOL)editable
{
    if (!self.enabled)
    {
        NSLog(@"Item is disabled");
        editable = NO;
    }
    
    _editable = editable;
}

@end
