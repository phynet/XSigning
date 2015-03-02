# SSCodesigningXcode
**Ruby script to sign thorugh terminal your Xcode Project**

Do you need to install some app in your iphone/ipad device?, and you have found some great libraries like [Shenzhen](https://github.com/nomad/shenzhen) to create an IPA file and [iOS-deploy](https://github.com/phonegap/ios-deploy) to install it in your device. But, there's a missing step. Signing your xcodeproject. 

Usually you will need to open XCODE and select Provisioning Profile and Certificate...but, if this xcodeproject change, you will have to do this step again, and again, and again. So that's why this script was created, to automate this step (if you're using Jenkins, Bamboo, would be necessary, right?) and make everything easy.


##How to use

Something to have in mind is that is mandatory now to pass the **path of Provisioning Profile**, because it changes from every user (I don't know yet how to implement this without making the user pass it in CL). 


    ruby main.rb "The Name of your certificate" "Name of your provisioning profile" /Users/YourUser/Path-to-your-xcode-project   /Users/YourUser/Library/MobileDevice/Provisioning\ Profiles/ 


You will need to know:

Your exact Provisioning Profile. For example:
    
    iOS Team Provisioning Profile

Your exact Certificate Profile, that match that particulary Provisioning Profile:

    iPhone Developer: Sofia Swidarowicz Andrade (ABCD3EFGXCZ)

The path of your xcodeproj

    /Users/xxxx/Projects/binary/ios/MyAwesomeProject-1
    
And the path of your Provisioning Profile

    /Users/YourUser/Library/MobileDevice/Provisioning\ Profiles/

##List certificates or provisioning profiles

Also I've added two new options to list certificate profiles and provisioning profiles stored in your mac. Right now you can use it like: 

    ruby main.rb cert

or 

    ruby main.rb prov /Users/yourUser/Library/MobileDevice/Provisioning\ Profiles/

This will list all certificates or provisioning profiles.

This script is working. But still is the Alpha version.




##TO DO:

    - Change project path to a relative one.
    - Improve use of path of Provisioning Profile. 
    - Options helper
    - Improve methods of input options from CL

