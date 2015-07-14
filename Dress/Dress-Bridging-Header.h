//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "libWeiboSDK/WeiboSDK.h"
#import "libWeiboSDK/WeiboUser.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "sqlite3.h"
#import <time.h>
#import <AVOSCloud/AVOSCloud.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"

#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

@import GoogleMobileAds;


#define kAppKeyForWeibo @"292424940"
#define kWeiboRedirectURL @"https://api.weibo.com/oauth2/default.html"
#define kShareRedirectUrl @"https://dn-dress.qbox.me/index.html"

#define kUMKey @"548f99f4fd98c55e540004b9"
#define kWeChatSecret @"8d7c1d1b2c56543c5ae86b426c354efb"
#define kWeChatAppId @"wx9d9213045b2bdc44"
#define kQQAppId @"1104289356"
#define kQQKey @"vB8oYcFKEe3sDbh5"

#define kAVCloudAppId @"ypyeenvnsp2thiyhrbs9zkbvguwi0c29h2b1nv06jp19o65j"
#define kAVCloudClientKey @"o6wa72uxorqtn0fym50qojxmdj82uwi59nyi18hs3472u72b"

//for admob banner
#define APP_LOGIN_ADMOB_AD_UNIT_ID @"ca-app-pub-5080103747035592/4632179868"
#define APP_DISCOVER_ADMOB_AD_UNIT_ID @"ca-app-pub-5080103747035592/5088008268"
#define APP_FEEDBACK_ADMOB_AD_UNIT_ID @"ca-app-pub-5080103747035592/8327349464"
#define APP_NEW_CLOTH_ADMOB_AD_UNIT_ID @"ca-app-pub-5080103747035592/5908480669"


#ifdef MY_DEBUG

#endif