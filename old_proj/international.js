
function CheckOK(trip_type, origin, destination, travel_class, dep_month, dep_day, arr_month, arr_day) {	
	var strURL;

	/*
	alert(trip_type);
	alert(origin);
	alert(destination);
	alert(travel_class);
	alert(dep_month);
	alert(dep_day);
	alert(arr_month);
	alert(arr_day);
	*/

	var f = {
		TripType: trip_type, // R/O
		txtDepCity: { value: origin },
		txtArrCity: { value: destination },
		txtCabinClass: { value: travel_class }, // PE/FB
		lstDepMonth: { value: dep_month },
		lstDepDay: { value:  dep_day },
		lstArrMonth: { value: arr_month },
		lstArrDay: { value: arr_day },
		lstTravellerAdults: 1,
		lstTravellerChildren: 0,
		txtDepDate: new Object(),
		txtArrDate: new Object()
	};

	/*
	var f = {
		TripType: "R", // R/O
		txtDepCity: { value: "sin" },
		txtArrCity: { value: "hkg" },
		txtCabinClass: { value: "PE" }, // PE/FB
		lstDepMonth: { value: "201202" },
		lstDepDay: { value:  "02" },
		lstArrMonth: { value: "201202" },
		lstArrDay: { value: "14" },
		lstTravellerAdults: 1,
		lstTravellerChildren: 0,
		txtDepDate: new Object(),
		txtArrDate: new Object()
	};
	*/

	var strTripType;
	strTripType = f.TripType;
	//strTripType = getCheckedValue(f.TripType);
	
// check for direct to another URL for domestic eticket route
// check departure city is domestic eticket or not
        
	if ((f.txtDepCity.value=="bkk" ) || 
	    (f.txtDepCity.value=="dmk" ) ||
		(f.txtDepCity.value=="cnx" ) ||
		(f.txtDepCity.value=="cei" ) ||
		(f.txtDepCity.value=="hdy" ) ||
		(f.txtDepCity.value=="kkc" ) ||
		(f.txtDepCity.value=="kbv" ) ||
		(f.txtDepCity.value=="usm" ) ||
		(f.txtDepCity.value=="hgn" ) ||
		(f.txtDepCity.value=="nst" ) ||
		(f.txtDepCity.value=="phs" ) ||
		(f.txtDepCity.value=="hkt" ) ||
		(f.txtDepCity.value=="urt" ) ||
		(f.txtDepCity.value=="tst" ) ||
		(f.txtDepCity.value=="ubp" ) ||
		(f.txtDepCity.value=="uth" )) {
				// check arrival city is domestic eticket  or not
								if ((f.txtArrCity.value=="bkk" ) || 
									(f.txtArrCity.value=="dmk" ) ||
									(f.txtArrCity.value=="cnx" ) ||
									(f.txtArrCity.value=="cei" ) ||
									(f.txtArrCity.value=="hdy" ) ||
									(f.txtArrCity.value=="kkc" ) ||
									(f.txtArrCity.value=="kbv" ) ||
									(f.txtArrCity.value=="usm" ) ||
									(f.txtArrCity.value=="hgn" ) ||
									(f.txtArrCity.value=="nst" ) ||
									(f.txtArrCity.value=="phs" ) ||
									(f.txtArrCity.value=="hkt" ) ||
									(f.txtArrCity.value=="urt" ) ||
									(f.txtArrCity.value=="tst" ) ||
									(f.txtArrCity.value=="ubp" ) ||
									(f.txtArrCity.value=="uth" )) {
								//for domestic eticket only
                                // strURL='https://wftc3.e-travel.com/plnext/tgdv9/Override.action?LANGUAGE=GB&SITE=CAVDCAVD&PAYMENT_TYPE=CON&SO_SITE_MOP_CALL_ME=FALSE&TYPE=AIR_TRIP_FARE&EMBEDDED_TRANSACTION=AirAvailability';
								// change to implement ATM 28/04/10
								 strURL='https://wftc3.e-travel.com/plnext/tgdv9/Override.action?LANGUAGE=GB&SITE=CAVDCAVD&PAYMENT_TYPE=CON&TYPE=AIR_TRIP_FARE&EMBEDDED_TRANSACTION=FlexPricerAvailability';

									 //if (strTripType=='O') { 
                                     //           strURL=strURL+'&SO_SITE_OFFICE_ID=BKKTG08AA&PRICING_TYPE=C&DISPLAY_TYPE=2&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=DOMESTIC';
                                     //}else{
                                     //          strURL=strURL+'&PRICING_TYPE=I&DISPLAY_TYPE=2&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=DOMESTIC';
                                     //}

								 if (f.txtCabinClass.value == "FB"){ //First and Business
										
									if (strTripType=='O') {
										strURL=strURL+'&SO_SITE_OFFICE_ID=BKKTG08AA&PRICING_TYPE=C&DISPLAY_TYPE=2&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=DOMESTICBZ';
									} else  {
										strURL=strURL+'&PRICING_TYPE=O&DISPLAY_TYPE=2&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=DOMESTICBZ';
									}    

								  }
								  if (f.txtCabinClass.value == "PE"){ //First and Business
										
									if (strTripType=='O') {
										strURL=strURL+'&SO_SITE_OFFICE_ID=BKKTG08AA&PRICING_TYPE=C&DISPLAY_TYPE=2&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=DOMESTIC';
									} else  {
										strURL=strURL+'&PRICING_TYPE=O&DISPLAY_TYPE=2&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=DOMESTIC';
									}     
								  } 
										
								}else{  //from domestic to all destinations
                                    	//if  ((f.txtDepCity.value=="bkk" ) &&  (strTripType=='R'))  { //change for support ATM 28/04/10
										if  (strTripType=='R'){
											 strURL='https://wftc3.e-travel.com/plnext/tgpnext/Override.action?LANGUAGE=GB&SITE=CATRCATR&PAYMENT_TYPE=CON&TYPE=AIR_TRIP_FARE';
											// if boarding from BKK to all destination and  check roudtrip for flex price applicaiton
												 if (f.txtCabinClass.value == "FB" ){ //First and Business
                                                      strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=THFIRSTBIZ';	   }
				                				 if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
								                      strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=THECONOMY';	}

								        }else {
								         //from domestic except BKK to other inter cities
								           strURL='https://wftc3.e-travel.com/plnext/tgpnext/Override.action?LANGUAGE=GB&SITE=CATRCATR&PAYMENT_TYPE=CON&TYPE=AIR_TRIP_FARE&EMBEDDED_TRANSACTION=AirAvailability'
										}// end if boarding if boarding from BKK to all destination and check roudtrip for flex price applicaiton
								} //end else from domestic to all destinations
            }else {
		//boarding from cities eligible for eticket
 	     strURL='https://wftc3.e-travel.com/plnext/tgpnext/Override.action?LANGUAGE=GB&SITE=CATRCATR&PAYMENT_TYPE=CON&TYPE=AIR_TRIP_FARE'
                   // below is checking round trip or oneway for eticket inter routing
				  if (strTripType=='R') {
					   // only round trip
					   //alert ("Departure city is "+f.txtDepCity.value);
////////////////// revised by if else /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
                  if (f.txtDepCity.value=="lax" ){
						 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=PACIFIC';
                  }else if (f.txtDepCity.value=="sin" ){
						 // alert ("Cabin Class is "+f.txtCabinClass.value);
						 if (f.txtCabinClass.value == "FB"){ //First and Business
						         strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=SGFIRSTBIZ';
						 }
						 if (f.txtCabinClass.value == "PE" ){  //Premium eco and eco
						         strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=SGECONOMY';
						 }
                  }else if ((f.txtDepCity.value=="syd" )||(f.txtDepCity.value=="per")||(f.txtDepCity.value=="mel")||(f.txtDepCity.value=="bne")||(f.txtDepCity.value=="per")){
						 //alert ("Cabin Class is "+f.txtCabinClass.value);
						 if (f.txtCabinClass.value == "FB" ){ //First and Business
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=AUFIRSTBIZ';									
						 }
						 if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=AUECONOMY';
						 }

                   }else if (f.txtDepCity.value=="akl"){
						 //alert ("Cabin Class is "+f.txtCabinClass.value);
						 if (f.txtCabinClass.value == "FB" ){ //First and Business
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=NZFIRSTBIZ';									
						 }
						 if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=NZECONOMY';
						 }

                   }else if ((f.txtDepCity.value=="nrt" )||(f.txtDepCity.value=="kix")||(f.txtDepCity.value=="ngo")||(f.txtDepCity.value=="fuk") ||(f.txtDepCity.value=="hnd") ||(f.txtDepCity.value=="tyo")){
						 //alert ("Cabin Class is "+f.txtCabinClass.value);
              			 if (f.txtCabinClass.value == "FB" ){ //First and Business
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=JPFIRSTBIZ';									
						 }
						 if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=JPECONOMY';
						 }
                  }else if ((f.txtDepCity.value=="cgk" )||(f.txtDepCity.value=="dps")){
						 //alert ("Cabin Class is "+f.txtCabinClass.value);
						 if (f.txtCabinClass.value == "FB" ){ //First and Business
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=IDFIRSTBIZ';
						 }
						 if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=IDECONOMY';
						 }
                  }else if (f.txtDepCity.value=="bwn" ){
						 //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=BNFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=BNECONOMY';
						}
                  }else if ((f.txtDepCity.value=="kul" )||(f.txtDepCity.value=="pen" )){
						 //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=MYFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=MYECONOMY';
						}
                  }else if ((f.txtDepCity.value=="sel" )||(f.txtDepCity.value=="pus" ) ||(f.txtDepCity.value=="icn" )){
 					    //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=KRFIRSTBIZ';									
					    }
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=KRECONOMY';
						}
				  }else if ((f.txtDepCity.value=="fra")||(f.txtDepCity.value=="muc")){
						 //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=DEFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=DEECONOMY';
						}
                  }else if (f.txtDepCity.value=="ath"){
						 //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=GRFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=GRECONOMY';
						}   
				  }else if (f.txtDepCity.value=="dme"){
						 //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=RUFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=RUECONOMY';
						}
				  }else if (f.txtDepCity.value=="cmb"){
						 //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=LKFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=LKECONOMY';
						}				  
				  }else if (f.txtDepCity.value=="cdg"){
						 //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                 strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=FRFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=FRECONOMY';
						}
                  }else if (f.txtDepCity.value=="cph" ){
					    //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=DKFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=DKECONOMY';
						}
                  }else if (f.txtDepCity.value=="lhr" ){
 					    //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=GBFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=GBECONOMY';
						}
                  }else if (f.txtDepCity.value=="mad" ){
					    //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=ESFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=ESECONOMY';
						}
                  }else if ((f.txtDepCity.value=="fco" )||(f.txtDepCity.value=="mxp")){
					    //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=ITFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=ITECONOMY';
						}
                  }else if (f.txtDepCity.value=="arn" ){
					    //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=SEFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=SEECONOMY';
						}
                  }else if (f.txtDepCity.value=="jnb" ){
					    //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=ZAFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=ZAECONOMY';
						}
				  }else if (f.txtDepCity.value=="osl" ){
					    //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=NOFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=NOECONOMY';
						}	
                  }else if ((f.txtDepCity.value=="del" )||(f.txtDepCity.value=="gay" )||(f.txtDepCity.value=="vns" )||(f.txtDepCity.value=="bom" )||(f.txtDepCity.value=="ccu" )||(f.txtDepCity.value=="blr" )||(f.txtDepCity.value=="hyd")||(f.txtDepCity.value=="maa" )){
					    //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=INFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=INECONOMY';
						}

				  }else if ((f.txtDepCity.value=="bjs" )||(f.txtDepCity.value=="pek" )||(f.txtDepCity.value=="xmn" )||(f.txtDepCity.value=="can" )||(f.txtDepCity.value=="pvg" )||(f.txtDepCity.value=="kmg" )||(f.txtDepCity.value=="ctu")){
					    //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=CNFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=CNECONOMY';
						}
				  }else if (f.txtDepCity.value=="zrh" ){
					    //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=ZHFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=ZHECONOMY';
						}
				  }else if (f.txtDepCity.value=="bru" ){
					    //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=BEFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=BEECONOMY';
						}
				 }else if (f.txtDepCity.value=="hkg" ){
					    //alert ("Cabin Class is "+f.txtCabinClass.value);
						if (f.txtCabinClass.value == "FB" ){ //First and Business
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=HKFIRSTBIZ';									
						}
						if (f.txtCabinClass.value == "PE" ) {  //Premium eco and eco
                                  strURL=strURL+'&EMBEDDED_TRANSACTION=FlexPricerAvailability&PRICING_TYPE=I&DISPLAY_TYPE=1&DATE_RANGE_VALUE_1=3&DATE_RANGE_VALUE_2=3&DATE_RANGE_QUALIFIER_1=C&DATE_RANGE_QUALIFIER_2=C&COMMERCIAL_FARE_FAMILY_1=HKECONOMY';
						}
				  }else{
						strURL=strURL+'&EMBEDDED_TRANSACTION=AirAvailability' ;
				  }

           }else{ 
			 // eticket inter city and oneway
			  strURL=strURL+'&EMBEDDED_TRANSACTION=AirAvailability' ;
		  	  }
          }

	var NowDate=new Date();

	var one_day=1000*60*60*24 ;
	
	var yeardate = f.lstDepMonth.value ;
	var monthdate = f.lstDepMonth.value ;
	
	var depdate = new Date(yeardate.substr(0,4), monthdate.substr(4,2)-1 , f.lstDepDay.value);
			
	var diffdate=Math.ceil((depdate.getTime()-NowDate.getTime())/(one_day)) ;

	        //strURL=strURL+'&SO_SITE_MOP_EXT=FALSE&SO_SITE_MOP_CALL_ME=TRUE&SO_SITE_MINIMAL_TIME=H72';
 	   
			if ((f.txtDepCity.value!="cgp")&&
				(f.txtDepCity.value!="bwn")&&
				(f.txtDepCity.value!="bwn")&&
				(f.txtDepCity.value!="kwi")&&
				(f.txtDepCity.value!="mow")&&
				(f.txtDepCity.value!="dme")&&
				(f.txtDepCity.value!="vns")&&
				(f.txtDepCity.value!="del")&&
				(f.txtDepCity.value!="bom")&&
				(f.txtDepCity.value!="hyd")&&
				(f.txtDepCity.value!="blr")&&
				(f.txtDepCity.value!="ccu")&&
				(f.txtDepCity.value!="gay")&&
				(f.txtDepCity.value!="maa")&&
   			    (f.txtDepCity.value!="rgn"))  {
	
					 if(f.txtDepCity.value=="mnl") {
                         strURL=strURL+'&SO_SITE_MINIMAL_TIME=H72' ;
                     }
						
                // Below for boarding from cities that eligible for eticket 

                    if (diffdate < 6) {
         				 strURL=strURL+'&SO_SITE_MOD_E_TICKET=TRUE&SO_SITE_MOD_PICK_CITY=FALSE';
  	                   if((f.txtDepCity.value=="cgk")||(f.txtDepCity.value=="dps")) {
                           strURL=strURL+'&SO_SITE_MINIMAL_TIME=H12' ;
                       }else{
                           if((f.txtDepCity.value=="nrt")||(f.txtDepCity.value=="kix")||(f.txtDepCity.value=="fuk")||(f.txtDepCity.value=="ngo") ||(f.txtDepCity.value=="tyo") ||(f.txtDepCity.value=="hnd")) {
                               strURL=strURL+'&SO_SITE_MINIMAL_TIME=H6&SO_SITE_CURRENCY_FORMAT_JAVA=0';
                           }else{
                               strURL=strURL+'&SO_SITE_MINIMAL_TIME=H6&SO_SITE_TK_TIME_PERIOD=H6&SO_SITE_TK_ARRANGEMENT=TL&SO_SITE_TK_OFFICE_ID=BKKTG08AA' ;
                           }
                       }    
                   //if not < 6 
	               }else{ if((f.txtDepCity.value=="nrt")||(f.txtDepCity.value=="kix")||(f.txtDepCity.value=="fuk")||(f.txtDepCity.value=="ngo") ||(f.txtDepCity.value=="tyo") ||(f.txtDepCity.value=="hnd")) {
                               strURL=strURL+'&SO_SITE_MINIMAL_TIME=H6&SO_SITE_CURRENCY_FORMAT_JAVA=0';
                          }else{
                               strURL=strURL+'&SO_SITE_MOP_CALL_ME=TRUE&SO_SITE_MINIMAL_TIME=H12' ;
                          }
                   }
               }else{
	           // Below for boarding from cities that not eligible for eticket  
                alert("For your selected origin"+" \" "+f.txtDepCity[f.txtDepCity.selectedIndex].text+" \" "+", only reservation can be made.  On-line payment cannot be made and electronic ticket cannot be issued on-line through our web site. Please contact THAI ticket office in the country where the journey commences to purchase your ticket.") ;
                strURL=strURL+'&SO_SITE_MOP_EXT=FALSE&SO_SITE_MOP_CALL_ME=TRUE&SO_SITE_MINIMAL_TIME=H72';
 
               }
			   if((f.txtDepCity.value=="sel")||(f.txtDepCity.value=="pus")||(f.txtDepCity.value=="icn")){
                   strURL=strURL+'&SO_SITE_CURRENCY_FORMAT_JAVA=0';
               }

        f.txtDepDate.value=f.lstDepMonth.value+f.lstDepDay.value+"0000"

		var NowDate=new Date();
		 //var NowYear=""+NowDate.getYear();
	    var NowYear=""+NowDate.getFullYear();
						
		
		var NowMonth=setTo2Digits(""+(NowDate.getMonth()+1));
		var NowDay=setTo2Digits(""+NowDate.getDate());
		var NowPLDate=NowYear+NowMonth+NowDay+"0000";
        //alert(strURL)

	strURL=strURL+'&TRIP_FLOW=YES&TRAVELLER_TYPE_1=ADT&SESSION_ID=&EXTERNAL_ID=NORMAL';

	
	//-- Begin : Kaew edit Traveller dropdown ---------------------
	var nTraveller = 1;
	for(var i=1;i<f.lstTravellerAdults.value;i++) {
		nTraveller++;
		strURL=strURL+"&TRAVELLER_TYPE_"+nTraveller+"=ADT";
	}
	for(var i=0;i<f.lstTravellerChildren.value;i++) {
		nTraveller++;
		strURL=strURL+"&TRAVELLER_TYPE_"+nTraveller+"=CHD";
	}
	//-- End : Kaew edit Traveller dropdown ------------------------

		
		
	if (strTripType=='O'|| strTripType=='C')
	{	
		f.txtDepDate.value=f.lstDepMonth.value+f.lstDepDay.value+"0000"
		
		strURL=strURL+'&B_DATE_1='+f.txtDepDate.value;
		strURL=strURL+'&B_ANY_TIME_1=TRUE';
		strURL=strURL+'&B_LOCATION_1='+f.txtDepCity.value;
		strURL=strURL+'&E_LOCATION_1='+f.txtArrCity.value;
	}
	

	if (strTripType=='R')
	{	
		f.txtDepDate.value=f.lstDepMonth.value+f.lstDepDay.value+"0000"
		f.txtArrDate.value=f.lstArrMonth.value+f.lstArrDay.value+"0001"
		
		strURL=strURL+'&B_DATE_1='+f.txtDepDate.value;
		strURL=strURL+'&B_ANY_TIME_1=TRUE';   
		strURL=strURL+'&B_DATE_2='+f.txtArrDate.value;
		strURL=strURL+'&B_ANY_TIME_2=TRUE';
		strURL=strURL+'&B_LOCATION_1='+f.txtDepCity.value;
		strURL=strURL+'&E_LOCATION_1='+f.txtArrCity.value;

		var NowDate=new Date();
		 // var NowYear=""+NowDate.getYear();
		var NowYear=""+NowDate.getFullYear();
						
		
		var NowMonth=setTo2Digits(""+(NowDate.getMonth()+1));
		var NowDay=setTo2Digits(""+NowDate.getDate());
		var NowPLDate=NowYear+NowMonth+NowDay+"0000";
		
   		if (f.txtDepDate.value>f.txtArrDate.value)
        {
            alert("Arrival date must be greater than Departure date");
            return;
        }
		

		if (f.txtDepDate.value<NowPLDate)
		{
			alert("Date already passed.");
			return;
		}
	}	
	
	

	var NowDate=new Date();
	// var NowYear=""+NowDate.getYear();
	var NowYear=""+NowDate.getFullYear();			
	
	var NowMonth=setTo2Digits(""+(NowDate.getMonth()+1));
	var NowDay=setTo2Digits(""+NowDate.getDate());
	var NowPLDate=NowYear+NowMonth+NowDay+"0000";	
  		
	strURL=strURL+'&TRIP_TYPE='+strTripType;

	////////////////for  temporary checking city for pricing on BKKTG08CC/////////////////////////////////////////////	   
	//		if ((f.txtDepCity.value =="pnh")||
	//		   (f.txtDepCity.value =="vte")||
	//		   (f.txtDepCity.value =="sgn")||
	//		   (f.txtDepCity.value =="osl")||
	//		   (f.txtDepCity.value =="cmb")||
	//		   (f.txtDepCity.value =="han"))  {
    //              strURL=strURL+'&SO_SITE_OFFICE_ID=BKKTG08CC' ;
	//		}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
    strURL=strURL+'&SO_SITE_FD_DISPLAY_MODE=0';
	strURL=strURL+'&SO_GL=<?xml%20version=%221.0%22%20encoding=%22iso-8859-1%22?><SO_GL><GLOBAL_LIST%20mode=%22complete%22><NAME>SO_SINGLE_MULTIPLE_COMMAND_BUILDER</NAME><LIST_ELEMENT><CODE>1</CODE><LIST_VALUE><![CDATA[OS YY IP <CLIENT_IP_ADDRESS>]]></LIST_VALUE><LIST_VALUE>S</LIST_VALUE></LIST_ELEMENT></GLOBAL_LIST></SO_GL>';
    

	return strURL;

	//-- Begin : Kaew edit sumbit flow ---------------------
	strURL = strURL.replace(/LANGUAGE=GB/, g_Param_LANGUAGE);
	if(document.forms['tripflowForm']==undefined) {
		//TripFlow for non-member.
		window.open(strURL,"1ARES","toolbar,status,resizable,scrollbars,top=0,left=0,width="+(screen.width*0.99)+",height="+(screen.height*0.88));
	} else {
		//TripFlow for ROP member.
		window.open("","1ARES","toolbar,status,resizable,scrollbars,top=0,left=0,width="+(screen.width*0.99)+",height="+(screen.height*0.88));
		document.forms['tripflowForm'].elements['tripflow'].value = strURL;
		document.forms['tripflowForm'].submit();	
	}
	//-- End : Kaew edit sumbit flow ----------------------
	
}



function CheckCityClass() {
	var f = document.form1;	
	var strTripType = getCheckedValue(f.TripType);

	var ID_ReturnDate_1 = document.getElementById('labelArr');
	var ID_ReturnDate_2 = f.lstArrDay;
	var ID_ReturnDate_3 = f.lstArrMonth;
	var ID_ReturnDate_4 = document.getElementById('iconArrCalendar');
	var ID_CabinClass_1 = document.getElementById('labelCabin');
	var ID_CabinClass_2 = f.txtCabinClass;

	if(isMatchArray(f.txtDepCity.value, Array("syd","mel","bne","per","akl","nrt","kix","ngo","fuk","hnd","tyo","bkk","cgk","dps","kul","pen","sin","bwn","sel","pus","icn","cph","fra","muc","lhr","mad","dme","cdg","fco","mxp","ath","arn","del","gay","vns","bom","ccu","maa","blr","hyd","jnb","cmb","osl","bjs","pek","xmn","can","pvg","kmg","ctu","bru","zrh","hkg"))) { 
		if (strTripType=='R') {
			ID_ReturnDate_1.style.visibility = ""		//display return date
			ID_ReturnDate_2.style.visibility = ""		//display return date
			ID_ReturnDate_3.style.visibility = ""		//display return date
			ID_ReturnDate_4.style.visibility = ""		//display return date										
			ID_CabinClass_1.style.visibility = ""		//display class
			ID_CabinClass_2.style.visibility = ""		//display class
			//alert("condition 1");
		}else{
			ID_ReturnDate_1.style.visibility = "hidden"		//display return date
			ID_ReturnDate_2.style.visibility = "hidden"		//display return date
			ID_ReturnDate_3.style.visibility = "hidden"		//display return date
			ID_ReturnDate_4.style.visibility = "hidden"		//display return date										
			ID_CabinClass_1.style.visibility = "hidden"		//display class
			ID_CabinClass_2.style.visibility = "hidden"		//display class	
			//alert("condition 2");
		}
		
	}else{ //other cities 
		if (strTripType=='R') {
			ID_ReturnDate_1.style.visibility = ""		//display return date
			ID_ReturnDate_2.style.visibility = ""		//display return date
			ID_ReturnDate_3.style.visibility = ""		//display return date
			ID_ReturnDate_4.style.visibility = ""		//display return date										
			ID_CabinClass_1.style.visibility = "hidden"		//display class
			ID_CabinClass_2.style.visibility = "hidden"		//display class
			//alert("condition 3");
		}else{
			ID_ReturnDate_1.style.visibility = "hidden"		//display return date
			ID_ReturnDate_2.style.visibility = "hidden"		//display return date
			ID_ReturnDate_3.style.visibility = "hidden"		//display return date
			ID_ReturnDate_4.style.visibility = "hidden"		//display return date										
			ID_CabinClass_1.style.visibility = "hidden"		//display class
			ID_CabinClass_2.style.visibility = "hidden"		//display class	
			//alert("condition 4");
		}
	}
	
	return true;
}


function changeDepartureCity( pOrigin ) {
	var f = document.form1;
	var paramList;

	CheckCityClass();
	
    if (pOrigin.value =="lax"){    
	 	paramList = "usal";
	}else if (pOrigin.value =="hkt"){
	 	paramList = "hktl";
	}else{
       	paramList = "full";
    }

    

	clearCityDropDown(f.txtArrCity);	
	setCityDropDown(f.txtArrCity, g_Inter_CityList[paramList], 0);
	return true;
}


/*
window.onload = function() {
	var f = document.form1;
	setTravellerDropDown(null);
	setCabinDropDown(f.txtCabinClass, g_Inter_CabinClass);
	setCityDropDown(f.txtDepCity, g_Inter_CityList['fullnodom']);
	setCityDropDown(f.txtArrCity, g_Inter_CityList['full']);
		
	setDateMonthDropDown(f.lstDepDay, f.lstDepMonth);
	setDateMonthDropDown(f.lstArrDay, f.lstArrMonth);	
}
*/
