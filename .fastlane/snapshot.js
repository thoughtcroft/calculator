#import "SnapshotHelper.js"

var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();


target.delay(3)

target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_PORTRAIT);
captureLocalizedScreenshot("0-LandingScreen")

target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_LANDSCAPELEFT);
captureLocalizedScreenshot("1-LandingScreenSideways")
