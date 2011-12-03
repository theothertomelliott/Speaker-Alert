//
//  TKConst.h
//  Timekeeper
//
//  Created by Tom Elliott on 27/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef Timekeeper_Const_h
#define Timekeeper_Const_h

#define SECONDS_IN_A_MINUTE 60

// Time picker configuration
#define MAX_MINUTES 60
#define SECOND_INCREMENTS 15

// Default settings
#define INITIAL_GREEN_S 60
#define INITIAL_AMBER_S 120
#define INITIAL_RED_S 150
#define INITIAL_FLASH_S 180

#define INITIAL_SHOW_TIME YES
#define INITIAL_VIBRATE YES

// Config keys
#define KEY_GREEN_TIME @"GreenTime"
#define KEY_AMBER_TIME @"AmberTime"
#define KEY_RED_TIME @"RedTime"
#define KEY_FLASH_TIME @"FlashTime"
#define KEY_VIBRATE @"ShouldVibrate"
#define KEY_SHOW_TIME @"ShowTime"
#define KEY_LAST_TIME @"LastTime"

#endif
