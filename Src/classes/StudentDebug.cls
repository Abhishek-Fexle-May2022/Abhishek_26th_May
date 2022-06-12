public class StudentDebug {
    public StudentDebug(){
        Student__c s1 = [Select Id, Name, Student_Email__c From Student__c order by createdDate DESC Limit 1];
        system.debug('Check Student Data' + s1);
        
        List<student__c> StudentList = [Select Id, Roll_Number__c, Student_Email__c, Student_Phone_Number__c, Nick_Name__c From Student__c order by createdDate DESC Limit 5];
        system.debug('Check Student Data' + StudentList);
    }

}