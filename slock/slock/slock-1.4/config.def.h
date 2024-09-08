/* user and group to drop privileges to */
static const char *user  = "daisys";
static const char *group = "users";

static const char *colorname[NUMCOLS] = {
	[INIT] =   "black",     /* after initialization */
	[INPUT] =  "#005577",   /* during input */
	[FAILED] = "#CC3333",   /* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* default message */
static const char * message = "Enter Password To Unlock: Hello world";

/* text color */
static const char * text_color = "#ffffff";

/* text size (must be a valid size) */
static const char * font_name = "Great Vibes";

/* Background image path, should be available to the user above */
static const char* background_image = "/home/daisys/backgrounds/someonesfanart.jpg";

/* time in seconds before the monitor shuts down */
static const int monitortime = 30;
