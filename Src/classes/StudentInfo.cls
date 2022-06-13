public class StudentInfo {
        public static void InfoStudent(){
        Student__c s1 = new Student__c();
        s1.Name = 'Ayush';
        s1.Nick_Name__c = 'Ayush';
        s1.Date_of_Birth__c = Date.newInstance(2022, 06, 07) ;
        s1.Date_and_Time__c = DateTime.newInstanceGmt(2022, 06, 07, 17, 20, 32);
        s1.Student_Phone_Number__c = '9893030346' ;
        s1.Student_Email__c = 'ayush@gmail.com';
        s1.Student_linkdin_Id__c = 'https://www.youtube.com/' ;
        s1.Roll_Number__c = 170260420;
        s1.City__c = 'Bhopal';
        s1.Address__c = 'Bhopal';
        s1.Student_Details__c = 'college Student';
        s1.Time__c = Time.newInstance(17, 17, 17, 17);
        s1.Exame_fees__c  = 2000;
        s1.College_Fees__c = 40000;
        s1.PG_percentage__c = 90;
        s1.Country__c = 'India';
        s1.State__c = 'Madhya Pradesh' ;
        s1.Indian_Student__c = true;
        s1.Bank_Account_Number__c = '7894563217';
        insert s1;
        
    }

}