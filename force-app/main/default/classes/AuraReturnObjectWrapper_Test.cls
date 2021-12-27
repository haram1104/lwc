@IsTest
private class AuraReturnObjectWrapper_Test {

    @IsTest
    static void integrationTest() {
        AuraReturnObjectWrapper arw = new AuraReturnObjectWrapper();

        // setSuccess()
        arw.setSuccess();
        System.assertEquals('SUCCESS', arw.result);

        // setError(String errorMsg)
        try {
            throw new CustomException('Custom Exception');
        } catch(Exception e) {
            arw.setError(e.getMessage());
        }
        System.assertEquals('Custom Exception', arw.result);

        // setError(Exception e)
        try {
            throw new CustomException('Custom Exception');
        } catch(Exception e) {
            arw.setError(e);
        }
        System.assertEquals(arw.PLEASE_CONTACT_ADMINISTRATOR, arw.result);

        // setError(Exception e, Boolean showErrorMsg)
        try {
            throw new CustomException('Custom Exception');
        } catch(Exception e) {
            arw.setError(e, true);
        }
        System.assertEquals('Custom Exception', arw.result);
        try {
            throw new CustomException('Custom Exception');
        } catch(Exception e) {
            arw.setError(e, false);
        }
        System.assertEquals(arw.PLEASE_CONTACT_ADMINISTRATOR, arw.result);

        // setPagination(Integer totalCount, Integer pageShow)
        arw.setPagination(21, 10);
        System.assertEquals(3, arw.totalPage);

        // setExcelTemplate(String excelTemplate, Integer excelLength)
        arw.setExcelTemplate('<table></table>', 1);

        // getProfileName()
        System.assertEquals([SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name, arw.getProfileName());

        // getPermissionList()
        System.assertEquals([SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId()].size(), arw.getPermissionList().size());

        // setSavepoint()
        arw.setSavepoint();
        System.assertNotEquals(null, arw.sp);

        Account acct = new Account();
        acct.Name = 'test account';
        insert acct;
        System.assertEquals(1, [SELECT COUNT() FROM Account]);

        // rollback()
        arw.rollback();
        System.assertEquals(0, [SELECT COUNT() FROM Account]);

        // rollbackAndSetError(Exception e)
        try {
            acct = new Account();
            insert acct;
        } catch(Exception e) {
            arw.rollbackAndSetError(e);
        }
        System.assertEquals(0, [SELECT COUNT() FROM Account]);
        System.assertEquals(arw.PLEASE_CONTACT_ADMINISTRATOR, arw.result);

        // rollbackAndSetError(Exception e, Boolean showErrorMsg)
        String errorMsg = null;
        try {
            acct = new Account();
            insert acct;
        } catch(Exception e) {
            errorMsg = e.getMessage();
            arw.rollbackAndSetError(e, true);
        }
        System.assertEquals(0, [SELECT COUNT() FROM Account]);
        System.assertEquals(errorMsg, arw.result);

        // rollbackAndSetError(String errorMsg)
        try {
            acct = new Account();
            insert acct;
        } catch(Exception e) {
            arw.rollbackAndSetError(e.getMessage());
        }
        System.assertEquals(0, [SELECT COUNT() FROM Account]);
        System.assertEquals(errorMsg, arw.result);
    }

    private class CustomException extends Exception {}
}