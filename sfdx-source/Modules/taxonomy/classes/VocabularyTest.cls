@isTest
public class VocabularyTest {

    
    @testSetup
    private static void loadTestData() {
        
        // Save a Vocabulary object.
        // 
        // Save several TaxonomyTerm__c objects related to it.
        Vocabulary__c v = new Vocabulary__c(Name = 'Store Catalog');
        insert v;
        
        TaxonomyTerm__c t1 = new TaxonomyTerm__c(Name = 'Merchandise', Vocabulary__c = v.Id);
        TaxonomyTerm__c t2 = new TaxonomyTerm__c(Name = 'Publication', Vocabulary__c = v.Id);
         
        insert new List<TaxonomyTerm__c>{t1,t2};

        TaxonomyTerm__c t3 = new TaxonomyTerm__c(Name = 'Bag', Vocabulary__c = v.Id, Parent__c = t1.Id);
        TaxonomyTerm__c t4 = new TaxonomyTerm__c(Name = 'Books Online', Vocabulary__c = v.Id, Parent__c = t2.Id);
        
        insert new List<TaxonomyTerm__c>{t3,t4};
    }
      
  
    
    
    @isTest
    private static void addHocVocabulary() {
        
        
        Vocabulary vocab = new Vocabulary('Store Catalog');
        TaxonomyTerm t1 = vocab.addTerm('Publication');
        TaxonomyTerm t2 = vocab.addTerm('CLE Archive');
        
        t1.addChild(new TaxonomyTerm('Digital Subscription'));
        
        System.assert(vocab.hasTerms());
		System.assert(vocab.size() == 2); // There are exactly two terms.
    }
        
      
    @isTest
    private static void loadVocabulary() {
        // This would load all of the Taxonomy Terms associated with the given Vocabulary in Salesforce.
        Vocabulary vocab = Vocabulary.newFromVocabulary('Store Catalog');
         
        
		Dom.Document xml = vocab.toXmlDocument();
        
        System.debug(xml.toXmlString());
    }
    
    
    
    @isTest
    private static void convertToHtml() {
        
        Vocabulary vocab = Vocabulary.newFromVocabulary('Store Catalog');
           
        
		Dom.Document xml = vocab.toXmlDocument();
        
        XmlToHtmlTreeConverter converter = new XmlToHtmlTreeConverter();
        
		DOM.Document tree = converter.convert(xml.toXmlString());
		String html = tree.toXmlString();
        
        System.debug(html); 
		
    }
}