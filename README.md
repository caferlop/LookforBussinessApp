# LookforBussinessApp

In order to use this App, you´ll have to clone two repos:

1) App repo:https://github.com/caferlop/LookforBussinessApp.git
The app repo constains the presentation layer, having a dependency with the dynamic framework  Lookforbussiness(it is written like this).
Within the repo´s folder, you´ll find the LookingForBusinesses workspace, open it, and you´ll find it contains already the LookforBusinessApp

2) Clone the framework repo: https://github.com/caferlop/Lookforbussiness.git. Once cloned, drop the file LookForBussiness.xcodeproj within the LookingForBusinesses 
workspace, but not inside the LookforBussinessApp.xcodeproj.(TODO: Use SPM to manage this dependency)

Now you are set to use the app. The app consist in a first view, which will look for the business arround you. If you move arround the map view, it will show new 
businesses taking as a center the center of the map.
If you tap in one of the annotations, it will open a simple detail show business details, like a picture, name, phone and address.

It´s a basic app, but it is programmed to be scalable, using an MVP + Coordinator arquitecture pattern, followinf the solid principles.

Within the framework, you´ll find one of the use cases unit tested.
