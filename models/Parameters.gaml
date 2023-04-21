model Parameters

import "./main.gaml"

global {
	//----------------------Simulation Parameters------------------------
	
	//Simulation time step
	float step <- 2 #sec; 
	
	//Simulation starting date
	date starting_date <- date("2022-10-11 00:00:00"); 
	
	//Date for log files
	//date logDate <- #now;
	date logDate <- date("2023-04-20 15:45:00");
	
	date nowDate <- #now;
	
	//Duration of the simulation
	int numberOfDays <- 1; //WARNING: If >1 set numberOfHours to 24h
	int numberOfHours <- 24; //WARNING: If one day, we can also specify the number of hours, otherwise set 24h
	
	//----------------------Logging Parameters------------------------
	bool loggingEnabled <- true parameter: "Logging" category: "Logs";
	bool printsEnabled <- false parameter: "Printing" category: "Logs";
	
	bool autonomousBikeEventLog <- false parameter: "Autonomous Bike Event/Trip Log" category: "Logs";
	bool carEventLog <- true parameter: "Car Event/Trip Log" category: "Logs";
	
	bool packageTripLog <- true parameter: "Package Trip Log" category: "Logs";
	bool packageEventLog <- true parameter: "Package Event Log" category: "Logs";
		
	bool stationChargeLogs <- false parameter: "Station Charge Log" category: "Logs";
	bool gasstationFuelLogs <- true parameter: "Gas Station Charge Log" category: "Logs";
	
	bool roadsTraveledLog <- true parameter: "Roads Traveled Log" category: "Logs";
	
	//----------------------------------Scenarios-----------------------------
	bool traditionalScenario <- true parameter: "Traditional Scenario" category: "Scenarios";
	int numVehiclesPackageTraditional <- 100 min:1 max:1000 parameter: "Number or Vehicles for Package Delivery in Traditional Scenario" category:"Initial";
	
	//----------------------Autonomous Scenario-------------------------
	//-----------------Autonomous Bike Parameters-----------------------
	int numAutonomousBikes <- 200				min: 0 max: 500 parameter: "Num Autonomous Bikes:" category: "Bike";
	float maxBatteryLifeAutonomousBike <- 50000.0 #m	min: 10000#m max: 70000#m parameter: "Autonomous Bike Battery Capacity (m):" category: "Bike"; //battery capacity in m
	float PickUpSpeedAutonomousBike <-  8/3.6 #m/#s min: 1/3.6 #m/#s max: 15/3.6 #m/#s parameter: "Autonomous Bike Pick-up Speed (m/s):" category:  "Bike";
	float RidingSpeedAutonomousBike <-  PickUpSpeedAutonomousBike min: 1/3.6 #m/#s max: 15/3.6 #m/#s parameter: "Autonomous Bike Riding Speed (m/s):" category:  "Bike";
	float minSafeBatteryAutonomousBike <- 0.25*maxBatteryLifeAutonomousBike #m; //Amount of battery at which we seek battery and that is always reserved when charging another bike
	float nightSafeBatteryAutonomousBike <- 0.9*maxBatteryLifeAutonomousBike #m; 
	
	//------------------------------------Charging Station Parameters--------------------------------------
	int numChargingStations <- 75 	min: 1 max: 100 parameter: "Num Charging Stations:" category: "Initial";
	//float V2IChargingRate <- maxBatteryLife/(4.5*60*60) #m/#s; //4.5 h of charge
	float V2IChargingRate <- maxBatteryLifeAutonomousBike/(4.5*60*60) #m/#s;  // 111 s battery swapping -> average of the two reported by Fei-Hui Huang 2019 Understanding user acceptancd of battery swapping service of sustainable transport
	
	//----------------------Traditional Scenario-------------------------
	//------------------------Car Parameters------------------------------
	// 500km for Combustion Cars from: https://www.blog.ontariocars.ca/vehicles-with-long-range-on-one-tank-on-fuel/
	float maxFuelCar <- 500000.0 #m	min: 320000.0#m max: 645000.0#m parameter: "Car Battery Capacity (m):" category: "Car";
	// Data extracted from: https://movotiv.com/statistics
	float RidingSpeedCar<-  30/3.6 #m/#s min: 1/3.6 #m/#s max: 50/3.6 #m/#s parameter: "Car Riding Speed (m/s):" category:  "Car";
	// Data extracted from: https://www.autoinsuresavings.org/far-drive-vehicle-empty/
	float minSafeFuelCar <- 0.15*maxFuelCar #m; 
	float nightSafeFuelCar <- 0.9*maxFuelCar #m; 
	// Data extracted from: Good to Go - Assessing the Environmental Performance of New Mobility || Can Autonomy Make Bicycle-Sharing Systems More Sustainable - Environmental Impact Analysis of an Emerging Mobility Technology
	// Refueling/recharging rate
	// 3 minutes for Combustion Cars: https://www.researchgate.net/publication/311210193_Fuel_cells_vs_Batteries_in_the_Automotive_Sector
	float refillingRate <- maxFuelCar/(3*60) #m/#s;  
    
    //--------------------------Package Parameters----------------------------
    float maxWaitTimePackage <- 1440 #mn		min: 3#mn max: 1440#mn parameter: "Max Wait Time Package:" category: "Package";
	float maxDistancePackage_AutonomousBike <- maxWaitTimePackage*PickUpSpeedAutonomousBike #m;
	float maxDistancePackage_Car <- maxWaitTimePackage*RidingSpeedCar#m;
     
    //--------------------------Demand Parameters-----------------------------
    string cityDemandFolder <- "./../includes/Demand";
    csv_file pdemand_csv <- csv_file (cityDemandFolder+ "/fooddeliverytrips_cambridge.csv",true);
    
    //----------------------Map Parameters------------------------
	//Case - Cambridge
	string cityScopeCity <- "Cambridge";
	string residence <- "R";
	string office <- "O";
	string park <- "P";
	string health <- "H";
	string education <- "E";
	string usage <- "usage";
	
	map<string, rgb> color_map <- [residence::#papayawhip-10, office::#gray, park::#lightgreen, education::#lightblue, "Other"::#black];
    map<string, rgb> color_map_2 <-  [residence::#dimgray, office::#darkcyan, park::#darkolivegreen+15, education::#steelblue-50, "Other"::#black];
    
	//GIS FILES To Upload - Cambridge
	string cityGISFolder <- "./../includes/City/"+cityScopeCity;
	file bound_shapefile <- file(cityGISFolder + "/Bounds.shp")			parameter: "Bounds Shapefile:" category: "GIS";
	file buildings_shapefile <- file(cityGISFolder + "/Buildings.shp")	parameter: "Building Shapefile:" category: "GIS";
	file roads_shapefile <- file(cityGISFolder + "/Roads.shp")			parameter: "Road Shapefile:" category: "GIS";
	
	//Charging Stations - Cambridge
	csv_file chargingStations_csv <- csv_file(cityGISFolder+ "/bluebikes_stations_cambridge.csv",true);
	
	//Restaurants - Cambridge
	csv_file restaurants_csv <- csv_file (cityGISFolder+ "/restaurants_cambridge.csv",true);
	
	//Gas Stations - Cambridge
	csv_file gasstations_csv <- csv_file (cityGISFolder+ "/gasstations.csv",true);
	 
	//Image File
	file imageRaster <- file('./../images/gama_black.png');
	
	bool show_building <- false;
	bool show_road <- true;
	bool show_restaurant <- true;
	bool show_gasStation <- true;
	bool show_chargingStation <- true;
	bool show_package <- true;
	bool show_car <- true;
	bool show_autonomousBike <- true;
}	