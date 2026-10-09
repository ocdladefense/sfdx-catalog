public class CatalogTaxonomyToCatalogEntries {

    

    public static List<CatalogEntry__c> toEntries(TaxonomyTerm term) {
             
       String query0 = 'SELECT Id, Name, ClickpdxCatalog__DisplayName__c,(SELECT Id, UnitPrice, Discounts__c FROM PricebookEntries) '+
           ' FROM Product2 WHERE Id IN(SELECT Product__c FROM CatalogEntry__c WHERE '+
           ' TaxonomyTerm__c = :catalogIds AND IsPublished__c = True) ORDER BY ';
        String query1 = 'SELECT Id, Name, ClickpdxCatalog__DisplayName__c,(SELECT Id, UnitPrice, Discounts__c FROM PricebookEntries) FROM Product2';
		String query2 = 'SELECT Name, Product__c, Product__r.Name, Product__r.ClickpdxCatalog__MemberPrice__c, Product__r.ClickpdxCatalog__DisplayName__c FROM CatalogEntry__c WHERE TaxonomyTerm__c = :termId AND IsPublished__c = True';

        String orderByCLE = 'ORDER BY Event__r.Start_Date__c DESC NULLS LAST, ClickpdxCatalog__DisplayName__c';
        String orderByOther = 'ORDER BY Product__r.ClickpdxCatalog__DisplayOrder__c NULLS LAST, Product__r.ClickpdxCatalog__DisplayName__c';

        Map<String,Object> bindings = new Map<String,Object>(); 
        
        String orderBy = term.name == 'CLE Archives' ? orderByCLE : orderByOther;

        bindings.put('termId', term.theId);
        // If term has a customer iterator then
        // it could be used to perform queries to the.
        // Why can't the catalog entry contain *most of the relevant data through Formula fields.
        // [SELECT Name, Product__r.Id, Product__r.ClickpdxCatalog__MemberPrice__c, Product__r.ClickpdxCatalog__DisplayName__c FROM CatalogEntry__c WHERE TaxonomyTerm__c = :term.theId AND IsPublished__c = True]);
        return Database.queryWithBinds(query2 + ' ' + orderBy, bindings, AccessLevel.SYSTEM_MODE);
    }
    
    public static CatalogProduct mapToCatalogProduct(CatalogEntry__c record) {

            // entries = p.getSObjects('PricebookEntries');
			String displayName = null == record.Product__r.ClickpdxCatalog__DisplayName__c ? record.Product__r.Name : record.Product__r.ClickpdxCatalog__DisplayName__c;
        
            // Get all of the pricebook entries for this set of records.
            List<PricebookEntry> prices = [SELECT Id, UnitPrice, Discounts__c FROM PricebookEntry WHERE Product2Id = :record.Product__c];
        	Decimal price = prices.size() > 0 ? prices[0].UnitPrice : record.Product__r.ClickpdxCatalog__MemberPrice__c;
        
            return new CatalogProduct(displayName, price , record.Product__r.Id);
    }
}