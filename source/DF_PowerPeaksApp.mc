// History:
//
// 2017-12-28: Version 1.03
//
//		* CIQ 2.41 to support Edge 1030
//      * 1030 support
//

using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class DF_PowerPeaksApp extends App.AppBase
{

	//var Device_Type;

    function initialize()
    {
        AppBase.initialize();

		var DeviceSettings = System.getDeviceSettings();

   		System.println("Application Start - Total Memory = " + System.getSystemStats().totalMemory + " / Used Memory = " + System.getSystemStats().usedMemory);

        //Device_Type = Ui.loadResource(Rez.Strings.Device);

        //System.println("Device Type = " + Device_Type);
        System.println("Device - Screen Height = " + DeviceSettings.screenHeight);
        System.println("Device - Screen Width = " + DeviceSettings.screenWidth);
        System.println("Device - Is Touchscreen = " + DeviceSettings.isTouchScreen);

    }

    //! onStart() is called on application start up
    function onStart(state)
    {
    }

    //! onStop() is called when your application is exiting
    function onStop(state)
    {
    }

    //! Return the initial view of your application here
    function getInitialView() 
    {

        var AppVersion = Ui.loadResource(Rez.Strings.AppVersion);
		System.println("AppVersion = " + AppVersion);
		setProperty("App_Version", AppVersion);

		var D1, D2, D3, D4, T, V;
		
		D1 = getProperty("Duration_1");
		D2 = getProperty("Duration_2");
		D3 = getProperty("Duration_3");
		D4 = getProperty("Duration_4");
		T  = getProperty("DF_Title");

		//System.println(D1 + " / " + D2 + " / " + D3 + " / " +D4);
		
        return [ new DF_PowerPeaksView(D1,D2,D3,D4,T) ];
    }

}