# SSCodesigningXcode
**Ruby script to sign thorugh terminal your Xcode Project**

Do you need to install some app in your iphone/ipad device?, and you have found some great libraries like [Shenzhen](https://github.com/nomad/shenzhen) to create an IPA file and [iOS-deploy](https://github.com/phonegap/ios-deploy) to install it in your device. But, there's a step missing. Sign in your xcodeproject. Usually you will have to open XCODE and select Provisioning Profile and Certificate...but, if this xcodeproject change, you will have to do this step again, and again, and again. So that's why this script was created, to automate this step (if you're using Jenkins, Bamboo, etc).

Just download and run in terminal:
    
    ruby main.rb

You will need to know:

Your exact Provisioning Profile. For example:
    
    iOS Team Provisioning Profile

Your exact Certificate Profile, that match that particulary Provisioning Profile:

    iPhone Developer: Sofia Swidarowicz Andrade (ABCD3EFGXCZ)

And the path of your xcodeproj

    /Users/xxxx/Projects/binary/ios/MyAwesomeProject-1

This script is working. But still is the Alpha version.
