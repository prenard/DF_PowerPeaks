// History:
//
// 2017-12-28: Version 1.03
//
//		* CIQ 2.41 to support Edge 1030
//      * 1030 support
//

using Toybox.Application as App;

class DF_PowerPeaksApp extends App.AppBase
{

    function initialize()
    {
        AppBase.initialize();
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