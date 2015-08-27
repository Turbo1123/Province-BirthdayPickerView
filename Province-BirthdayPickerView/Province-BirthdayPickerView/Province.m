//
//  Province.m
//  Province-BirthdayPickerView
//
//  Created by 李云龙 on 15/8/27.
//  Copyright (c) 2015年 hihilong. All rights reserved.
//

#import "Province.h"

@implementation Province

+ (instancetype)provinceWithDict:(NSDictionary *)dict
{
    Province *p = [[self alloc] init];
    
    [p setValuesForKeysWithDictionary:dict];
    
    return p;
}

@end
