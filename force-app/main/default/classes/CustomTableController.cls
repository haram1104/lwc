public with sharing class CustomTableController {

    @AuraEnabled
    public static DataWrapper init() {
        DataWrapper dw = getAccountList(new Map<String, Object>());
        if(!dw.isSuccess()) {
            return dw;
        }

        dw.industryList = PicklistWrapper.getPicklistValuesWithDefault(Account.Industry, 'All');

        dw.setSuccess();
        return dw;
    }

    @AuraEnabled
    public static DataWrapper getAccountList(Map<String, Object> params) {
        DataWrapper dw = new DataWrapper();

        try {
            String queryStr = '';
            String whereStr = '';
            String orderStr = '';
            String limitStr = '';
            queryStr += 'SELECT AccountNumber';
            queryStr += '     , Name';
            queryStr += '     , Industry';
            queryStr += '     , Rating';
            queryStr += '     , BillingCountry';
            queryStr += '     , BillingState';
            queryStr += '     , BillingCity';
            queryStr += '     , BillingStreet';
            queryStr += '     , BillingPostalCode';
            queryStr += '     , Phone';
            queryStr += '     , Fax';
            queryStr += '     , Website';
            queryStr += '     , AnnualRevenue';
            queryStr += '     , Description';
            queryStr += '  FROM Account';
            orderStr += ' ORDER BY AccountNumber NULLS LAST';

            String accountNumber = String.valueOf(params.get('accountNumber'));
            String name = String.valueOf(params.get('name'));
            String industry = String.valueOf(params.get('industry'));
            String annualRevenueFrom = String.valueOf(params.get('annualRevenueFrom'));
            String annualRevenueTo = String.valueOf(params.get('annualRevenueTo'));
            Decimal annualRevenueFromDec = null;
            Decimal annualRevenueToDec = null;

            if(String.isNotBlank(accountNumber)) {
                accountNumber = '%' + accountNumber + '%';
                whereStr += ' AND AccountNumber LIKE :accountNumber';
            }
            if(String.isNotBlank(name)) {
                name = '%' + name + '%';
                whereStr += ' AND Name LIKE :name';
            }
            if(String.isNotBlank(industry)) {
                whereStr += ' AND Industry = :industry';
            }
            if(String.isNotBlank(annualRevenueFrom) && String.isNotBlank(annualRevenueTo)) {
                annualRevenueFromDec = Decimal.valueOf(annualRevenueFrom);
                annualRevenueToDec = Decimal.valueOf(annualRevenueTo);
                whereStr += ' AND (AnnualRevenue >= :annualRevenueFromDec AND AnnualRevenue <= :annualRevenueToDec)';
            } else if(String.isNotBlank(annualRevenueFrom)) {
                annualRevenueFromDec = Decimal.valueOf(annualRevenueFrom);
                whereStr += ' AND AnnualRevenue >= :annualRevenueFromDec';
            } else if(String.isNotBlank(annualRevenueTo)) {
                annualRevenueToDec = Decimal.valueOf(annualRevenueTo);
                whereStr += ' AND AnnualRevenue <= :annualRevenueToDec';
            }
            whereStr = whereStr.startsWith(' AND') ? whereStr.replaceFirst(' AND', ' WHERE') : whereStr;

            dw.accountList = Database.query(queryStr + whereStr + orderStr + limitStr);
            dw.setSuccess();
        } catch(Exception e) {
            dw.setError(e);
        }
        return dw;
    }

    @TestVisible
    private class DataWrapper extends AuraReturnObjectWrapper {
        @AuraEnabled public List<Account> accountList;
        @AuraEnabled public List<PicklistWrapper> industryList;
    }
}