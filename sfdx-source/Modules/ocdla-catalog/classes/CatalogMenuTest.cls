@isTest
public class CatalogMenuTest {

      
    
    @isTest
    private static void doTheTest() {
        Test.startTest();
            CatalogMenu.getMenuHtml();
            CatalogMenu.cacheCatalog();
        	CatalogMenu.cacheXml();
        Test.stopTest();
    }
    
}