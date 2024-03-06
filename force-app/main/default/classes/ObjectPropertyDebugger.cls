public with sharing virtual class ObjectPropertyDebugger {


    static {
        System.debug('ObjectPropertyDebugger static block executed!');
        voltage = 220;

    }
    // public static void printVoltage() {
    //     System.debug(voltage);
    // }

    public static void debugProperty(String propertyName, String objectName) {
        String query = 'SELECT ' + propertyName + ' FROM ' + objectName;
        List<sObject> sobjList = Database.query(query);
        for (sObject s: sobjList) {
            System.debug(s);
        }
    }
}