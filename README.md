# Flutter Demo

Fully working firebase Flutter app with authentication and CRUD.
Instructions and tests are only done on Android at the moment,
as I dont own a mac or iphone.
I am avaialble for business and knowledge sharing. Hit me up

ps: This code base is clean as and it gets cleaner by the day
## Some Screenshots
<div>
<img src="https://imgur.com/ZASwk0x.jpg" alt="Login" width="200"/>
<img src="https://imgur.com/4TJK8LH.jpg" alt="Register" width="200"/>
<img src="https://imgur.com/ApX2iB9.jpg" alt="Home" width="200"/>
</div>
<div>
<img src="https://imgur.com/s41c9qU.jpg" alt="Create Crud" width="200"/>
<img src="https://imgur.com/Vre3Mxb.jpg" alt="App Drawer" width="200"/>
</div> 


## Getting Started

* Install flutter on your machine
* `git clone https://github.com/MMHossaini/Flutter.git`
* `cd Flutter`
* Download the generated `google-services.json` from firebase project and place it inside `android/app`. 
* `flutter run`


## Features

* Login
* Registration
* Fully Working CRUD example(USing the Provider + Firebase state managment)


# Publishing(Deploying to palystore and ios store)

This app , This exact repo is published to google paly store , not ios store yet. 
IF you want to publish, then make sure you follow these instructions

## Android 
You need to sign your app first of all
### Signing the app
Create a key 

`keytool -genkey -v -keystore c:/path/to/your/key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key
`

Open and update `\android\key.properties` file values

Build an app bundle
`flutter build appbundle`


Now you can upload your app bundle to playstore after you pay play store developer regisreration fee. Cost $25 US dollars
For more information you can check out this [Guide](https://flutter.dev/docs/deployment/android)

## IOS 
Coming SOON! inshallah 
