//
//  ZZModelConfig.m
//  ModelMakeByJSON
//
//  Created by 李伯坤 on 2017/2/17.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "ZZModelConfig.h"

@implementation ZZModelConfig

+ (ZZModelConfig *)sharedInstance
{
    static ZZModelConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[ZZModelConfig alloc] init];
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstRun"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFirstRun"];
            // 默认设置
            [[NSUserDefaults standardUserDefaults] setObject:@"ZZModelMake" forKey:@"authorName"];
            [[NSUserDefaults standardUserDefaults] setObject:@(ZZThirdPartLibTypeMJExtension) forKey:@"thirdPartLibType"];
            [config resetToDefaultConfig];
        }
    });
    return config;
}

- (void)resetToDefaultConfig
{
    [[NSUserDefaults standardUserDefaults] setObject:@"ZZ" forKey:@"classPrefix"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Model" forKey:@"classSuffix"];
    [[NSUserDefaults standardUserDefaults] setObject:@[@"Get", @"get"] forKey:@"classPrefixIgnoreWords"];
    [[NSUserDefaults standardUserDefaults] setObject:@[@"Arr", @"arr", @"Model", @"model", @"Info", @"Array", @"Dic", @"Dictronary", @"Data", @"data"] forKey:@"classSuffixIgnoreWords"];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"userOriginClassNamsAsPrefix"];
}

- (NSString *)authorName
{
    NSString *authorName = [[NSUserDefaults standardUserDefaults] objectForKey:@"authorName"];
    return authorName;
}
- (void)setAuthorName:(NSString *)authorName
{
    [[NSUserDefaults standardUserDefaults] setObject:authorName ? authorName : @"" forKey:@"authorName"];
}

- (ZZThirdPartLibType)thirdPartLibType
{
    NSNumber *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"thirdPartLibType"];
    return type.integerValue;
}
- (void)setThirdPartLibType:(ZZThirdPartLibType)thirdPartLibType
{
    [[NSUserDefaults standardUserDefaults] setObject:@(thirdPartLibType) forKey:@"thirdPartLibType"];
}

- (NSString *)classPrefix
{
    NSString *classPrefix = [[NSUserDefaults standardUserDefaults] objectForKey:@"classPrefix"];
    return classPrefix;
}
- (void)setClassPrefix:(NSString *)classPrefix
{
    [[NSUserDefaults standardUserDefaults] setObject:classPrefix ? classPrefix : @"" forKey:@"classPrefix"];
}

- (NSString *)classSuffix
{
    NSString *classSuffix = [[NSUserDefaults standardUserDefaults] objectForKey:@"classSuffix"];
    return classSuffix;
}
- (void)setClassSuffix:(NSString *)classSuffix
{
    [[NSUserDefaults standardUserDefaults] setObject:classSuffix ? classSuffix : @"" forKey:@"classSuffix"];
}

- (BOOL)userOriginClassNamsAsPrefix
{
    NSNumber *userOriginClassNamsAsPrefix = [[NSUserDefaults standardUserDefaults] objectForKey:@"userOriginClassNamsAsPrefix"];
    return userOriginClassNamsAsPrefix.boolValue;
}
- (void)setUserOriginClassNamsAsPrefix:(BOOL)userOriginClassNamsAsPrefix
{
    [[NSUserDefaults standardUserDefaults] setObject:@(userOriginClassNamsAsPrefix) forKey:@"userOriginClassNamsAsPrefix"];
}

- (NSArray *)classPrefixIgnoreWords
{
    NSArray *classPrefixIgnoreWords = [[NSUserDefaults standardUserDefaults] objectForKey:@"classPrefixIgnoreWords"];
    return classPrefixIgnoreWords;
}
- (void)setClassPrefixIgnoreWords:(NSArray *)classPrefixIgnoreWords
{
    [[NSUserDefaults standardUserDefaults] setObject:(classPrefixIgnoreWords ? classPrefixIgnoreWords : @[]) forKey:@"classPrefixIgnoreWords"];
}


- (NSArray *)classSuffixIgnoreWords
{
    NSArray *classIgnordWords = [[NSUserDefaults standardUserDefaults] objectForKey:@"classSuffixIgnoreWords"];
    return classIgnordWords;
}
- (void)setClassSuffixIgnoreWords:(NSArray *)classSuffixIgnoreWords
{
    [[NSUserDefaults standardUserDefaults] setObject:(classSuffixIgnoreWords ? classSuffixIgnoreWords : @[]) forKey:@"classSuffixIgnoreWords"];
}

@end
