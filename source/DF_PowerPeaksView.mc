using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class DF_PowerPeaksView extends Ui.DataField
{

	var Device_Type;
	
	var CustomFont_Label = null;
	var CustomFont_Value = null;
	var CustomFont_Title = null;
	var CustomFont_Power_Unit = null;
			
	var CPx = new [4];
	var CPx_Duration_Array = new [4];

	var Duration_Number = 0;
	var nCPx = new [4];
	var nCPx_Duration_Array = new [4];

	var CPx_sum_of_samples_Array = new [4];
	var CPx_next_sample_idx_Array = new [4];
	var CPx_number_of_samples_Array = new [4];
	var CPx_history_power_Array = new [4];

	var App_Title;
	var App_Version;

	var Label_Idx;
	var Label_Value = new [4];


    function initialize(D1,D2,D3,D4,T)
    {
        DataField.initialize();

	    Device_Type = Ui.loadResource(Rez.Strings.Device);

		//System.println("Device Type = " + Device_Type);

		App_Title = T;

		CPx_Duration_Array = [D1,D2,D3,D4];        

		Label_Idx = 0;

		//System.println(App_Title + " " + App_Version);

   		for (var i = 0; i < CPx_Duration_Array.size(); ++i)
       	{
			if (CPx_Duration_Array[i] != 0)
			{
				
				Label_Value[Duration_Number] = Field_Label(CPx_Duration_Array[i]);
				nCPx[Duration_Number] = 0;
				CPx_sum_of_samples_Array[Duration_Number] = 0;
				CPx_next_sample_idx_Array[Duration_Number] = 0;
				CPx_number_of_samples_Array[Duration_Number] = 1;
				
				nCPx_Duration_Array[Duration_Number] = CPx_Duration_Array[i];
				
				//System.println("nCPx_history_power_Array = " + Duration_Number + " / " + nCPx_Duration_Array[Duration_Number]);
		        
		        CPx_history_power_Array[Duration_Number] = new [nCPx_Duration_Array[Duration_Number]];
				for (var j = 0; j < CPx_history_power_Array[Duration_Number].size(); ++j)
        			{
						CPx_history_power_Array [Duration_Number][j] = 0;
					}     

				Duration_Number++;

			} 
		}

    }

    var f1_mValue = 0;

    //! Set your layout here. Anytime the size of obscurity of
    //! the draw context is changed this will be called.
    function onLayout(dc)
    {
	   System.println("DC Height  = " + dc.getHeight());
       System.println("DC Width  = " + dc.getWidth());

       View.setLayout(Rez.Layouts.MainLayout(dc));

       var DF_Title = View.findDrawableById("DF_Title");
       var f1_label = View.findDrawableById("f1_label");
       var f1_value = View.findDrawableById("f1_value");
       var Power_Unit = View.findDrawableById("Power_Unit");
 /*             
       if (Device_Type.equals("edge_520") or Device_Type.equals("edge_1000"))
       {
 */
         CustomFont_Label = Ui.loadResource(Rez.Fonts.Font_Label);
         CustomFont_Value = Ui.loadResource(Rez.Fonts.Font_Value);
         CustomFont_Title = Ui.loadResource(Rez.Fonts.Font_Title);
         CustomFont_Power_Unit = Ui.loadResource(Rez.Fonts.Font_Power_Unit);
   	     
   	     DF_Title.setFont(CustomFont_Title);
   	     f1_label.setFont(CustomFont_Label);
   	     f1_value.setFont(CustomFont_Value);
   	     Power_Unit.setFont(CustomFont_Power_Unit);
/*
       }
*/
   	   DF_Title.setText(App_Title);
   	   Power_Unit.setText(Ui.loadResource(Rez.Strings.Power_Unit));
  
       return true;
    }

    function Field_Label(Duration_Sec)
    {
     var Field_Label;

     var Second;
     var Minute;

     Second = Duration_Sec % 60;
     Minute = (Duration_Sec - Second) / 60;
     
     //System.println("Min = " + Minute + " / Sec = " + Second);
     
     if (Second == 0)
     {
        Field_Label = Minute.format("%d") + "m:";
     }
     else
     {
        Field_Label = Duration_Sec.format("%d") + "s:";
     }
     
     
     return Field_Label;
    }


    //! The given info object contains all the current workout
    //! information. Calculate a value and save it locally in this method.
    function compute(info)
    {
        if( (info.currentPower != null))
            {
            	for (var i = 0; i < Duration_Number; ++i)
        		{

        			var Current_AVGx_Power_value;
        			
        			// subtract the oldest sample from our moving sum
					CPx_sum_of_samples_Array[i] -= CPx_history_power_Array[i] [CPx_next_sample_idx_Array[i]];

					CPx_history_power_Array [i] [CPx_next_sample_idx_Array[i]] = info.currentPower;

					// add the newest sample to our moving sum
					CPx_sum_of_samples_Array[i] += CPx_history_power_Array [i] [CPx_next_sample_idx_Array[i]];

					//System.println("Sum = " + CP5s_sum_of_samples);

					// keep track of how many samples we've accrued
					if (CPx_number_of_samples_Array[i] < CPx_history_power_Array[i].size())
						{
							++CPx_number_of_samples_Array[i];
						}
						else
						{
							Current_AVGx_Power_value = CPx_sum_of_samples_Array[i] / CPx_Duration_Array[i];
							//System.println("AVG = " + Current_AVG5s_Power_value);
							if (Current_AVGx_Power_value > nCPx[i])
							{
								nCPx[i] = Current_AVGx_Power_value;
								//System.println("CP = " + CP5s);
							}
						}

					// advance to the next sample, and wrap around to the beginning
					CPx_next_sample_idx_Array[i] = (CPx_next_sample_idx_Array[i] + 1) % CPx_history_power_Array[i].size();

            	}
			}

  
        //f1_mValue = 1027;
    }

    //! Display the value you computed here. This will be called
    //! once a second when the data field is visible.
    function onUpdate(dc)
    {
        // Set the background color
        View.findDrawableById("Background").setColor(getBackgroundColor());

        var f1_label = View.findDrawableById("f1_label");
        var DF_Title = View.findDrawableById("DF_Title");        
        var f1_value = View.findDrawableById("f1_value");
        var Power_Unit = View.findDrawableById("Power_Unit");

  	    Label_Idx = (Label_Idx + 1) % Duration_Number;
   	    f1_label.setText(Label_Value[Label_Idx]);

        f1_mValue = nCPx[Label_Idx];
        
        // Set the foreground color and value
        
        f1_value.setText(f1_mValue.format("%d"));

        if (getBackgroundColor() == Gfx.COLOR_BLACK)
        {
            DF_Title.setColor(Gfx.COLOR_WHITE);
            f1_label.setColor(Gfx.COLOR_WHITE);
            f1_value.setColor(Gfx.COLOR_WHITE);
            Power_Unit.setColor(Gfx.COLOR_WHITE);
        }
        else
        {
            DF_Title.setColor(Gfx.COLOR_BLACK);
            f1_label.setColor(Gfx.COLOR_BLACK);
            f1_value.setColor(Gfx.COLOR_BLACK);
            Power_Unit.setColor(Gfx.COLOR_BLACK);
        }

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

}
