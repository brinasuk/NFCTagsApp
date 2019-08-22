 import UIKit
 

 public let SERVERFILENAME = "https://photos.homecards.com/rebeacons/"

 //CRITICAL: THE FOLLOWING MUST!!! BE THE EXACT SAME AS IN THE PARSE DATABASE OR YOUR SIGNUP WILL UNEXPLICABLY FAIL!!!
 public let PF_USER_EMAIL = "email"
 public let PF_USER_EMAILCOPY = "emailCopy"
 public let PF_ACCOUNTUSERNAME = "accountusername"
 public let PF_ACCOUNTEMAIL = "accountemail"
 public let PF_ACCOUNTPASSWORD = "accountpassword"
 public let PF_ACCOUNTAPPROVEDYN = "accountapprovedyn"
 public let PF_USER_USERROLE = "userRole"
 public let PF_USER_AGENTOBJECTID = "agentObjectID"
 public let PF_PASSWORD = "password"
 
 public let PF_USER_FACEBOOKID = "facebookId"
 public let PF_USER_PICTURE = "thumbnail"
 public let PF_USER_THUMBNAIL = "picture"
 
 public let PF_USER_FULLNAME = "fullname"
 public let PF_USER_FULLNAME_LOWER = "fullname_lower"
 public let PF_USER_FIRSTNAME = "firstName"
 public let PF_USER_LASTNAME = "lastName"

 public let PF_ISAGENTYN = "isagentyn"
 public let PF_AGENTID = "agentID"
 
 public let kNOTIFYBEACONINRANGE = "NOTIFYBEACONINRANGE"
 public let kSTOPSCANNINGBUTTONS = "STOPSCANNINGBUTTONS"
 public let kREFRESHUSERTABLE = "REFRESHUSERTABLE"
 
// public let kFlagButtonColor = [UIColor colorWithRed:255.0/255.0 green:150.0/255.0 blue:0/255.0 alpha:1]
// #define kMoreButtonColor        [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1]
// #define kArchiveButtonColor     [UIColor colorWithRed:60.0/255.0 green:112.0/255.0 blue:168/255.0 alpha:1]
// #define kUnreadButtonColor      [UIColor colorWithRed:0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1]
 

 /*
  + (instancetype)yellowGreenColor
  {
  return [[self class] colorWithR:192 G:242 B:39 A:1.0];
  }
*/


 

 
/*

//func HEXCOLOR(_ c: Any) -> UIColor {
//    return UIColor(red: ((c >> 24) & 0xff) / 255.0, green: ((c >> 16) & 0xff) / 255.0, blue: ((c >> 8) & 0xff) / 255.0, alpha: Double((&0xff as? c) ?? 0.0) / 255.0)
//}

//
//#define		COLOR_NAVBAR_TITLE					HEXCOLOR(0xFFFFFFFF)
//#define		COLOR_NAVBAR_BUTTON					HEXCOLOR(0xFFFFFFFF)
//#define		COLOR_NAVBAR_BACKGROUND				HEXCOLOR(0x19C5FF00)
//
//#define		COLOR_TABBAR_LABEL					HEXCOLOR(0xFFFFFFFF)
//#define		COLOR_TABBAR_BACKGROUND				HEXCOLOR(0x19C5FF00)
//
//#define		PF_INSTALLATION_USER				@"user"					//	Pointer to User Class
//#define		PF_MESSAGES_CLASS_NAME				@"Messages"				//	Class name
//#define		PF_MESSAGES_USER					@"user"					//	Pointer to User Class
//#define		PF_MESSAGES_ROOMID					@"roomId"				//	String
//#define		PF_MESSAGES_DESCRIPTION				@"description"			//	String
//#define		PF_MESSAGES_LASTUSER				@"lastUser"				//	Pointer to User Class
//#define		PF_MESSAGES_LASTMESSAGE				@"lastMessage"			//	String
//#define		PF_MESSAGES_COUNTER					@"counter"				//	Number
//#define		PF_MESSAGES_UPDATEDACTION			@"updatedAction"		//	Date
//
//#define		PF_CHAT_CLASS_NAME					@"Chat"
//#define		PF_CHAT_ROOM						@"room"
//#define		PF_CHAT_USER						@"user"					//	Pointer to User Class
//#define		PF_CHAT_ROOMID						@"roomId"				//	String
//#define		PF_CHAT_TEXT						@"text"					//	String
//#define		PF_CHAT_PICTURE						@"picture"				//	File
//#define		PF_CHAT_CREATEDAT					@"createdAt"			//	Date
//
//#define		PF_CHATROOMS_CLASS_NAME				@"ChatRooms"
//#define		PF_CHATROOMS_ROOM					@"room"
//
//#define		PF_USER_CLASS_NAME					@"_User"
//#define		PF_USER_OBJECTID					@"objectId"
//#define		PF_USER_USERNAME					@"username"
//#define		PF_USER_PASSWORD					@"password"

//
//#define		PF_USER_FULLNAME_LOWER				@"fullname_lower"
let PF_USER_FACEBOOKID = "facebookId"
//#define		PF_USER_PICTURE						@"picture"
//#define		PF_USER_THUMBNAIL					@"thumbnail"
//
//
//
//#define		NOTIFICATION_APP_STARTED			@"NCAppStarted"
//#define		NOTIFICATION_USER_LOGGED_IN			@"NCUserLoggedIn"
//#define		NOTIFICATION_USER_LOGGED_OUT		@"NCUserLoggedOut"

// The following 6 fields added specially for Beacons



//==================================================

//let SCREEN_WIDTH = UIScreen.main.bounds.size.width
//let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

//func NSERROR(_ text: Any, _ number: Any) -> Error {
//    return NSError(domain: text, code: number, userInfo: nil)
//}

let PF_USER_FIRSTNAME = "firstName"
let PF_USER_LASTNAME = "lastName"

let PF_USER_FULLNAME = "fullname"
let PF_WWAGENTYN = "workingwithagentyn"
let PF_ISAGENTYN = "isagentyn"
let PF_USER_EMAIL = "email"
let PF_AGENTID = "agentID"
let PF_PASSWORD = "password"


let PF_USER_FULLNAMELOWER = "fullnameLower"

let PF_INSTALLATION_USER = "user"
let PF_USER_CLASS_NAME = "_User"
let FIREBASE = "https://realestatebeacons.firebaseIO.com"
let PF_USER_OBJECTID = "objectId"
let LINK_PARSE = "https://files.parsetfss.com"
let AFDOWNLOAD_TIMEOUT = 300
let PF_GROUP_CLASS_NAME = "Group"
let PF_GROUP_USER = "user"
let PF_GROUP_NAME = "name"
let PF_GROUP_MEMBERS = "members"

//#define		NOTIFICATION_APP_STARTED			@"NCAppStarted"
//#define		NOTIFICATION_USER_LOGGED_IN			@"NCUserLoggedIn"
//#define		NOTIFICATION_USER_LOGGED_OUT		@"NCUserLoggedOut"

let PF_USER_EMAILCOPY = "emailCopy"
let PF_USER_FULLNAME_LOWER = "fullname_lower"
let VIDEO_LENGTH = 5
let PF_PEOPLE_CLASS_NAME = "People"
let PF_USER_TWITTERID = "twitterId"
////let PF_USER_FACEBOOKID = "facebookId"
let PF_USER_PICTURE = "picture"
let PF_USER_THUMBNAIL = "thumbnail"
let PF_USER_LOCATION = "location"
////let PF_PEOPLE_CLASS_NAME = "People"
let PF_PEOPLE_USER1 = "user1"
let PF_PEOPLE_USER2 = "user2"
let LINK_PREMIUM = "http://www.relatedcode.com/premium"

//-----------------------------------------------------------------------
let PF_BLOCKED_CLASS_NAME = "Blocked"
let PF_BLOCKED_USER = "user"
let PF_BLOCKED_USER1 = "user1"
let PF_BLOCKED_USER2 = "user2"
let PF_BLOCKED_USERID2 = "userId2"

let STATUS_LOADING = 1
let STATUS_FAILED = 2
let STATUS_SUCCEED = 3
let INSERT_MESSAGES = 10

//let COLOR_OUTGOING = HEXCOLOR(0x007affff)
//let COLOR_INCOMING = HEXCOLOR(0xe6e5eaff)

let TEXT_DELIVERED = "Delivered"
let TEXT_READ = "Read"



//#define		PF_USER_FACEBOOKID					@"facebookId"
//#define		PF_USER_PICTURE						@"picture"
//#define		PF_USER_THUMBNAIL					@"thumbnail"

//#define		PF_USER_CLASS_NAME

//let PF_USER_EMAILCOPY = "emailCopy"
//#define		PF_ACCOUNTUSERNAME            @"accountusername"
let PF_ACCOUNTEMAIL = "accountemail"
let PF_ACCOUNTPASSWORD = "accountpassword"
//#define		PF_ACCOUNTAPPROVEDYN          @"accountapprovedyn"
//let PF_USER_USERROLE = "userRole"
//let PF_USER_AGENTOBJECTID = "agentObjectID"



//user[PF_USER_EMAILCOPY] = _accountEmail;
//user[PF_USER_FULLNAME] = _accountFullName;
//user[PF_ACCOUNTPASSWORD] = _accountPassword;

//user[PF_ACCOUNTUSERNAME] = _accountUserName;
//user[PF_ACCOUNTEMAIL] = _accountEmail;

//user[PF_WWAGENTYN] = _workingWithAgent;
//user[PF_ISAGENTYN] = _isAgent;

*/

