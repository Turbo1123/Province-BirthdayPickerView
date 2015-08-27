//
//  Province.h
//  Province-BirthdayPickerView
//
//  Created by 李云龙 on 15/8/27.
//  Copyright (c) 2015年 hihilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject
/** 省会名称 */
@property (nonatomic, strong) NSString *name;
/** 省会的城市 */
@property (nonatomic, strong) NSArray *cities;


+ (instancetype)provinceWithDict:(NSDictionary *)dict;
@end
