public with sharing class PicklistWrapper {
    @AuraEnabled public String  label;
    @AuraEnabled public String  value;
    @AuraEnabled public Boolean isSelected;

    public PicklistWrapper(String label, String value) {
        this.label = label;
        this.value = value;
    }
    public PicklistWrapper(String label, String value, Boolean isSelected) {
        this(label, value);
        this.isSelected = isSelected;
    }

    // PicklistWrapper.getPicklistValues(EZ_Inventory__c.Status__c);
    public static List<PicklistWrapper> getPicklistValues(SObjectField sObjectField) {
        List<PicklistWrapper> pwList = new List<PicklistWrapper>();
        for(PicklistEntry peTmp : sObjectField.getDescribe().getPicklistValues()) {
            pwList.add(new PicklistWrapper(peTmp.label, peTmp.value));
        }
        return pwList;
    }
    public static List<PicklistWrapper> getPicklistValuesWithDefault(SObjectField sObjectField, String defaultLabel) {
        if(String.isBlank(defaultLabel)) {
            return getPicklistValues(sObjectField);
        }

        List<PicklistWrapper> pwList = new List<PicklistWrapper>{new PicklistWrapper(defaultLabel, '')};
        pwList.addAll(getPicklistValues(sObjectField));
        return pwList;
    }
}