public virtual class AuraReturnObjectWrapper {
    /**
     * @TestVisible
     * private class DataWrapper extends AuraReturnObjectWrapper {}
     */
    @TestVisible
    private final String PLEASE_CONTACT_ADMINISTRATOR = 'System Error: Please contact System Administrator';

    // Common
    @AuraEnabled public String  result;
    @AuraEnabled public Integer totalCount;
    @AuraEnabled public Integer totalPage;
    @AuraEnabled public String  excelTemplate;
    @AuraEnabled public Integer excelLength;
    @AuraEnabled public Integer colLength;

    public virtual void setSuccess() {
        this.result = 'SUCCESS';
    }
    public virtual Boolean isSuccess() {
        return this.result == 'SUCCESS';
    }
    public virtual void setError(String errorMsg) {
        System.debug(LoggingLevel.ERROR, errorMsg);
        this.result = errorMsg;
    }
    public virtual void setError(Exception e) {
        System.debug(LoggingLevel.ERROR, e.getStackTraceString());
        this.result = PLEASE_CONTACT_ADMINISTRATOR;
    }
    public virtual void setError(Exception e, Boolean showErrorMsg) {
        if(showErrorMsg) {
            setError(e.getMessage());
        } else {
            setError(e);
        }
    }
    public virtual void setPagination(Integer totalCount, Integer pageShow) {
        this.totalCount = totalCount;
        this.totalPage  = totalCount / pageShow + (Math.mod(totalCount, pageShow) == 0 ? 0 : 1);
    }
    public virtual void setExcelTemplate(String excelTemplate, Integer excelLength) {
        setExcelTemplate(excelTemplate, excelLength, null);
    }
    public virtual void setExcelTemplate(String excelTemplate, Integer excelLength, Integer colLength) {
        this.excelTemplate = excelTemplate;
        this.excelLength   = excelLength;
        this.colLength     = colLength;
    }

    // Permission
    @AuraEnabled public String                        profileName;
    @AuraEnabled public List<PermissionSetAssignment> permissionList;

    public virtual String getProfileName() {
        if(String.isBlank(profileName)) {
            this.profileName = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name;
        }
        return this.profileName;
    }
    public virtual List<PermissionSetAssignment> getPermissionList() {
        if(permissionList == null) {
            this.permissionList = [SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId()];
        }
        return this.permissionList;
    }

    // Savepoint
    @TestVisible
    private Savepoint sp;

    public void setSavepoint() {
        this.sp = Database.setSavepoint();
    }
    public void rollback() {
        if(this.sp != null) {
            Database.rollback(this.sp);
        }
    }
    public void rollbackAndSetError(Exception e) {
        this.rollbackAndSetError(e, false);
    }
    public void rollbackAndSetError(Exception e, Boolean showErrorMsg) {
        this.rollback();
        this.setError(e, showErrorMsg);
    }
    public void rollbackAndSetError(String errorMsg) {
        this.rollback();
        this.setError(errorMsg);
    }
}