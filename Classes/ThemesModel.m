
#import "ThemesModel.h"
#import "Theme.h"

static ThemesModel *_instance;
@implementation ThemesModel
@synthesize themes;
@synthesize userThemes;

+ (ThemesModel*)sharedInstance
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[super allocWithZone:NULL] init];
            
			
            // Allocate/initialize any member variables of the singleton class her
            // example
			//_instance.member = @"";
        }
    }
    return _instance;
}


#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{	
	return [self sharedInstance];	
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}



- (id)init {
	self = [super init];
	
	[self setThemes:[[NSMutableArray alloc] init]];
	
	[self loadUserThemes];
	
	[self addUserThemes];
	
	[self addHardCodeThemes];
	
	return self;
}

-(void)addNewUserTheme:(Theme *) userTheme
{
	[userThemes addObject:userTheme];
	[self saveUserThemes];
	
	// reload the themes to update the list 
	[self setThemes:[[NSMutableArray alloc] init]];
	
	[self loadUserThemes];
	
	[self addUserThemes];
	
	[self addHardCodeThemes];
	
}

-(void)loadUserThemes {
	NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
	// DEBUG  - clear settings below
	//[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kUserThemes"];
	
	
	NSData *myEncodedObject = [currentDefaults objectForKey:@"kUserThemes"];
	NSMutableArray* userThemesSaved = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	
	if (userThemesSaved != nil)
		[self setUserThemes:userThemesSaved];
	else
	{
		[self setUserThemes:[[NSMutableArray alloc] init]];
		[self saveUserThemes];
	}
}

-(void)saveUserThemes {
	[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[self userThemes]] forKey:@"kUserThemes"];
	[[NSUserDefaults standardUserDefaults]  synchronize];
	
}

-(void)addUserThemes {
	 for (Theme *theme in userThemes) {
		 [themes addObject:theme];
	 }
}

-(void)addHardCodeThemes {
	
		Theme *theme1 = [[Theme alloc] init];
		theme1.themeName = @"Sunrise 1";
		theme1.imageDescription = @"Sunrise at Haleakala crater, Maui";
		theme1.imageName=@"sunrise.jpg";
		theme1.thumbnailImage = @"sunriseScreenshot.png";
		theme1.style = @"normal";
		theme1.textColor = @"0xffffff";
		theme1.isUserTheme = NO;
	
		[themes addObject:theme1];
		
		Theme *theme2 = [[Theme alloc] init];
		theme2.themeName = @"Sunrise 2";
		theme2.imageDescription = @"Sunrise at Haleakala crater, Maui";
		theme2.imageName=@"sunrise2.jpg";
		theme2.thumbnailImage = @"sunrise2Thumb.png";
		theme2.style = @"normal";
		theme2.textColor = @"0xffffff";
		theme2.isUserTheme = NO;
	
		[themes addObject:theme2];
		
		Theme *theme3 = [[Theme alloc] init];
		theme3.themeName = @"Palms";
		theme3.imageDescription = @"Palm Trees";
		theme3.imageName=@"palms.jpg";
		theme3.thumbnailImage = @"palmsThumb.png";
		theme3.style = @"normal";
		theme3.textColor = @"0xffffff";
		theme3.isUserTheme = NO;

		[themes addObject:theme3];
		
		Theme *theme4 = [[Theme alloc] init];
		theme4.themeName = @"High Contrast";
		theme4.imageDescription = @"Bright green on black, with larger font";
		theme4.imageName=@"black.jpg";
		theme4.thumbnailImage = @"highContrastScreenshot.png";
		theme4.style = @"largeFont";
		theme4.textColor = @"0xffffff";
		theme4.isUserTheme = NO;

		[themes addObject:theme4];
	
	
}

@end
