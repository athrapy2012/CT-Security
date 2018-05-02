//
//  AppConstants.h
//  CT Security
//
//  Created by priya on 16/02/18.
//  Copyright © 2018 Media3. All rights reserved.
//

#ifndef AppConstants_h
#define AppConstants_h

//static ns const kOffsetCountInterval = 50;

static NSString *BASE_URL = @"http://104.236.111.220/";


//static NSString *BASE_URL = @"http://192.168.88.79:2000/";

static NSString *kVISITOR_NAME = @"name";
static NSString *kCOMPANY_NAME = @"company_name";
static NSString *kLICENCE_PLATE = @"licence_plate";
static NSString *kCHECK_IN_DATE = @"checkindate";
static NSString *kCHECK_IN_TIME = @"checkintime";
static NSString *kLOCATION = @"location";
static NSString *kSECURITY_ID = @"security_id";

static NSString *kBASE64_VISITOR_IMAGE = @"visitor_image";
static NSString *kBASE64_LICENCE_IMAGE = @"file";
static NSString *kBASE64_CHECK_IN_IMAGE = @"file2";

static NSString *kCHECK_OUT_DATE = @"checkoutdate";
static NSString *kCHECK_OUT_TIME = @"checkouttime";
static NSString *kBASE64_CHECK_OUT_IMAGE = @"checkoutimage";

static NSString *kVISITOR_CHECK_IN_ID = @"_id";
static NSString *kTIME_STAMP = @"timeStamp";
static NSString *kVISIORS_ARRAY = @"visitors_array";
static NSString *kSECURITY_GUARD_USER_NAME = @"securityGuardUserName";


//userdefault keys
static NSString *kUSER_ID_STR = @"userIdStr";


//Notification observer key
static NSString *kUPDATE_VISITOR_SERVICES = @"updateVisitorsServices";
#endif /* AppConstants_h */
/*
 params[@"id"] = _checkinId;
 params[@"checkoutdate"] = dateString1;
 params[@"checkouttime"] = dateString2;
 params[@"checkoutimage"] = base64CheckOutImg != nil ? base64CheckOutImg: @"";
*/
