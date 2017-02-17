//
//  ZZProperty.h
//  ModelMakeByJSON
//
//  Created by 李伯坤 on 2017/2/16.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZClass;
@interface ZZProperty : NSObject

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) Class valueClass;
@property (nonatomic, strong) NSString *valueClassName;

@property (nonatomic, strong) ZZClass *childClass;

/// 备注
@property (nonatomic, strong) NSString *remarks;

/// 根据键获取类名
+ (NSString *)classNameByKey:(NSString *)key;

- (id)initWithKey:(NSString *)key value:(id)value andFatherClassName:(NSString *)fatherClassName;

- (NSString *)propertyCode;

@end
