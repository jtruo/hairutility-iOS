# hairutility-iOS

# About

This is the iOS app I worked on from Oct. 2016- Sep. 2019. The goal was to help people receive better haircuts. It contains a lot of messy code due to rapid-development and my inexperience when I started developing the app. It ended up being a fun learning experience for me, and I can re-use this code for other passion projects.

All UIViews were created using Swift (without storyboard builder). I did this so that I can have a better understanding of the code with the views. There are about ~7600 lines of code including white space. Half-way through development, I used the MVC pattern. Had the code been modularized and used generics, it could have consisted of only a few thousands lines of code, due to the size of UIView code.

# Third-Party Libraries Used

ImagePicker (multi-select for images) \
AWSCore (accessing aws services) \
AWSS3 (uploading images to awss3) \
Alamofire (easy-to-read api requests) \
KeychainAccess (storing secure data) \
lottie-ios (json animations) \
Kingfisher (caching images) \
IQKeyboardManagerSwift (better keyboard UX) \
Lightbox (image viewer) \
Disk (easy local storage access)

The app sends requests to a Django REST API to https://www.hairutility.com/.








# Screens

![img](https://github.com/jtruo/hairutility-iOS/blob/master/AppScreens/hair-profile.png)



![img](https://github.com/jtruo/hairutility-iOS/blob/master/AppScreens/upload-options.png)



![img](https://github.com/jtruo/hairutility-iOS/blob/master/AppScreens/login.png)



