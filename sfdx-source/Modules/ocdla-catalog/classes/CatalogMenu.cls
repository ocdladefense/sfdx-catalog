/**
 * This class needs to be refactored based on 
 * work in Vocabulary and VocabularyTest
 */
public without sharing class CatalogMenu {

    
    @RemoteAction
    public static String getMenuHtml() {
        
        // This would load all of the Taxonomy Terms associated with the given Vocabulary in Salesforce.
        Vocabulary vocab = Vocabulary.newFromVocabulary('Store Catalog');
		Dom.Document xml = vocab.toXmlDocument();
        
        XmlToHtmlTreeConverter converter = new XmlToHtmlTreeConverter();
        
		DOM.Document tree = converter.convert(xml.toXmlString());
        String docHtml = tree.toXmlString();
        
        return docHtml.substringAfter('?>');
    }
    
    @RemoteAction
    public static String getStoreCatalogXml() {
        
        // This would load all of the Taxonomy Terms associated with the given Vocabulary in Salesforce.
        Vocabulary vocab = Vocabulary.newFromVocabulary('Store Catalog');
		Dom.Document xml = vocab.toXmlDocument();

        return xml.toXmlString();
    }

    
    
    @future
    public static void cacheXml() {
        
        Map<String, Object> myMenu = new Map<String, Object>();
        
        ClickpdxCore__CoreConfig__mdt theMenu;
        
        List<ClickpdxCore__CoreConfig__mdt> components = [SELECT Id, DeveloperName, ClickpdxCore__Value__c
                                                          FROM ClickpdxCore__CoreConfig__mdt WHERE DeveloperName  = 'StoreXml'];

        theMenu = 0 == components.size() ? new ClickpdxCore__CoreConfig__mdt() : components[0];
        theMenu.DeveloperName = 'StoreXml';        


        myMenu.put('ClickpdxCore__Value__c', CatalogMenu.getStoreCatalogXml());

        if(!Test.isRunningTest()) {
        	Metadata.DeployContainer container = CustomMetadataUtilities.save('ClickpdxCore__CoreConfig.StoreXml', 'Store XML', myMenu);
            CustomMetadataUtilities.deploy(container);
        }
    }
    
    
    @future
    public static void cacheCatalog() {
        
        Map<String, Object> myMenu = new Map<String, Object>();
        
        ClickpdxCore__CoreConfig__mdt theMenu;
        
        List<ClickpdxCore__CoreConfig__mdt> components = [SELECT Id, DeveloperName, ClickpdxCore__Value__c
                                                          FROM ClickpdxCore__CoreConfig__mdt WHERE DeveloperName  = 'StoreMenu'];

        theMenu = 0 == components.size() ? new ClickpdxCore__CoreConfig__mdt() : components[0];
        theMenu.DeveloperName = 'StoreMenu';        


        myMenu.put('ClickpdxCore__Value__c', CatalogMenu.getMenuHtml());

        if(!Test.isRunningTest()) {
        	Metadata.DeployContainer container = CustomMetadataUtilities.save('ClickpdxCore__CoreConfig.StoreMenu', 'Store Menu', myMenu);
            CustomMetadataUtilities.deploy(container);
        }
    }

 
    
}