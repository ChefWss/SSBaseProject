//
//  ColorDefinition.h
//  SSBaseProject
//
//  Created by 王少帅 on 2018/4/25.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#ifndef ColorDefinition_h
#define ColorDefinition_h
/*********************************************************************************************************/

//RGB
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//随机色
#define kRandomColor                        [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
//通用灰色线
#define kLine_GrayColor                     [UIColor colorWithRed:231/255.f green:231/255.f blue:231/255.f alpha:0.8]
//通用背景颜色
#define kBackground_GrayColor               [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]

/**********************************************************************************************************/
#endif /* ColorDefinition_h */
