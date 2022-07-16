public with sharing class MapProcessOfCountryStateDistrict {

    Map<String, Map<String, List<String>>> mapOfCountry = new Map<String, Map<String, List<String>>>();
    // Fill cuntry state map all data in mapOfCountry
    public MapProcessOfCountryStateDistrict() {
        try {
            List<District__c> districtList = [SELECT Name, State__r.Name, State__r.Country__r.Name FROM District__c ];
            if(districtList.size() > 0) {
            for (District__c district : districtList) {
                    if (!mapOfCountry.containsKey(district.State__r.Country__r.Name))
                    {
                        mapOfCountry.put(district.State__r.Country__r.Name, new Map<String,List<String>>());
                    }
                    if (mapOfCountry != null && mapOfCountry.get(district.State__r.Country__r.Name) != null) {
                        Map<String,List<String>> stateAndDistrictMap = mapOfCountry.get(district.State__r.Country__r.Name);
                        if (!stateAndDistrictMap.containsKey(district.State__r.Name))
                        {
                        stateAndDistrictMap.put(district.State__r.Name, new List<String>());
                        }
                        if (stateAndDistrictMap != null) {
                            stateAndDistrictMap.get(district.State__r.Name).add(district.Name);
                            mapOfCountry.put(district.State__r.Country__r.Name, stateAndDistrictMap);
                        }  
                    }   
                }
            }
            System.debug('Country map : ' + mapOfCountry); 
        } catch (DmlException e) {
            system.debug('The following exception has occurred: ' + e.getMessage());
        }
    }

    // Find country name , state name , district with given charecter
    public static void findDistrictLength(String startingCharector) {
        try {
            Map<String, Map<String, List<String>>> mapOfCountryFind = new Map<String, Map<String, List<String>>>();

            List<District__c> districtListFind = [SELECT Name, State__r.Country__r.Name, State__r.Name FROM District__c WHERE Name LIKE : startingCharector +'%' AND State__r.Name LIKE : startingCharector + '%' AND State__r.Country__r.Name LIKE : startingCharector + '%'];
                for(District__c district : districtListFind) {
                    if (!mapOfCountryFind.containskey(district.State__r.Country__r.Name))
                    {
                    mapOfCountryFind.put(district.State__r.Country__r.Name, new Map<String,List<String>>());
                    }
                    if (mapOfCountryFind != null && mapOfCountryFind.get(district.State__r.Country__r.Name) != null) {
                        Map<String,List<String>> mapOfStateAndDistrict = mapOfCountryFind.get(district.State__r.Country__r.Name);
                        if(!mapOfStateAndDistrict.containskey(district.State__r.Name))
                        {
                        mapOfStateAndDistrict.put(district.State__r.Name, new List<String>());
                        }
                        if(mapOfStateAndDistrict != null){
                            mapOfStateAndDistrict.get(district.State__r.Name).add(district.Name);
                        }
                    }
                }
                System.debug('Country name State name District name map with given charector : ' + mapOfCountryFind);
        } catch (DmlException e) {
            system.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    
    // Find length greter then given length 
    public static void lengthOfDistrict (Integer length) {
        try {
            List<District__c> allDistrictList = [SELECT Name FROM District__c];
            List<String> myStringDistrict = new List<String>();
            for (District__c districtString : allDistrictList) {
                if ((String.valueOf(districtString.Name)).length() >= length ) {
                    system.debug('District lenth greter then given length : ' + districtString.Name);
                }
        }
        } catch (DmlException e) {
            system.debug('The following exception has occurred: ' + e.getMessage());
        } 
    }

    // Creating wrapper class
    public class Districts {
        Public String districtName{get; set;}
    }
    public class States{
        Public List<Districts> districts{get; set;}
        public Integer total_State_Districts{get; set;}
        Public string stateName{get; set;}
    }
    public class Country{
        public String countryName{get; set;}
        public Integer countryCode{get;set;}
        public Integer total_Districts{get; set;}
        public Integer total_States{get; set;}   
    }

    // get json data
    Country countries = new Country();
    List<Country__c> jsonData = [SELECT Country_JSON_Data__c FROM Country__c];
    public void CountryJSONGenerator(String countryName, Integer countryCode) {
        try {
            countries.countryName = countryName;
            countries.countryCode = countryCode;
            List<AggregateResult> total_States = [SELECT COUNT(Name) Total_States FROM State__c WHERE Country__r.Name = : countryName  Group By Country__r.Name];  
            countries.total_States =  (Integer)total_States[0].get('Total_States');

            List<AggregateResult> total_Districts = [SELECT COUNT(Name) Total_Districts FROM District__c WHERE State__r.Country__r.Name = : countryName Group By State__r.Country__r.Name];    
            countries.total_Districts = (Integer)total_Districts[0].get('Total_Districts');

            for(String state : mapOfCountry.get(countryName).keyset())
            {
                States stateDate = new States();
                stateDate.stateName = state;
                stateDate.districts = new list<Districts>();

                List<AggregateResult> districtList = [SELECT COUNT(Name)Total_Districts FROM District__c WHERE State__r.Country__r.Name = : countryName Group By State__r.Name]; 
                stateDate.total_State_Districts = (Integer)districtList[0].get('Total_Districts');

                for(String districtData : mapOfCountry.get(countryName).get(State)) 
                {
                    Districts district = new Districts();
                    district.districtName = districtData; 
                    stateDate.districts.add(district);
                }
            }  
        } catch (DmlException e) {
            system.debug('The following exception has occurred: ' + e.getMessage());
        }
        
    }

    // serialize JSON Data
    public void insertCountry() {
        try {
            for (Country__c countryData : jsonData) {
                countryData.Country_JSON_Data__c = JSON.serialize(countries); 
            }
            update jsonData;
        } catch (DmlException e) {
            system.debug('The following exception has occurred: ' + e.getMessage());
        } 
    } 
}