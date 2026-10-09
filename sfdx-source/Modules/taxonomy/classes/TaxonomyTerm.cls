public class TaxonomyTerm extends Node implements IXmlNode {

    public String theId;
    
    public String name;
    
    public Decimal orderToken;
    
    public Boolean isPublished = True;
    
    private String vocabularyName;
    
    public String url;
    
	// public List<TaxonomyTerm> children = new List<TaxonomyTerm>();
      
    
    
    public TaxonomyTerm() {}
    
    
    public TaxonomyTerm(String name) {
        super();
        this.name = name;
    }
    
    
    public TaxonomyTerm(String name, String theId) {
        this(name);
        this.theId = theId;
    }
    
    public TaxonomyTerm(String name, String theId, Decimal orderToken) {
        this(name,theId);
        this.orderToken = orderToken;
    }
    

    
    
    public void addChild(TaxonomyTerm term) {
        this.children.add(term);
    }
    
    public void setVocabulary(String name) {
        this.vocabularyName = name;
    }
    

    
    public List<TaxonomyTerm> loadChildren() {
        List<TaxonomyTerm__c> records;
        List<TaxonomyTerm> terms = new List<TaxonomyTerm>();
        
        if(null != this.vocabularyName) {
			records = [SELECT Id, Name, IsPublished__c, OrderToken__c, Url__c FROM TaxonomyTerm__c WHERE Parent__c = :this.theId AND Vocabulary__r.Name = :this.vocabularyName ORDER BY OrderToken__c NULLS LAST, Name];
        } else {
        	records = [SELECT Id, Name, IsPublished__c, OrderToken__c, Url__c FROM TaxonomyTerm__c WHERE Parent__c = :this.theId ORDER BY OrderToken__c NULLS LAST, Name];
        }
        
        for(TaxonomyTerm__c record :records) {
			TaxonomyTerm term = new TaxonomyTerm(record.Name, record.Id, record.OrderToken__c);
            term.isPublished = record.IsPublished__c == True;
            term.url = record.Url__c;
            terms.add(term);
            this.children.add(term);
        }
        
        return terms;
    }
    
    
    /**
     * Return a new instance of this object from the database.
     */
    public static TaxonomyTerm newFromName(String name) {
		TaxonomyTerm__c term = [SELECT Id, Name, IsPublished__c, OrderToken__c, Url__c FROM TaxonomyTerm__c WHERE Name = :name LIMIT 1];
        return new TaxonomyTerm(term.Name, term.Id);
    }
    
    
    /**
     * Return a new instance of this object from the database.
     */
    public static TaxonomyTerm newFromId(Id theId) {
		TaxonomyTerm__c term = [SELECT Id, Name, IsPublished__c, OrderToken__c, Url__c FROM TaxonomyTerm__c WHERE Id = :theId];
        return new TaxonomyTerm(term.Name, term.Id);
    }
    
    
    public Dom.XmlNode toXmlNode(Dom.XmlNode parent) {

    	Dom.XmlNode child = parent.addChildElement('term', null, null);
        child.setAttribute('catalog-name', this.name);
        child.setAttribute('catalog-id', this.theId);
        child.setAttribute('catalog-url', this.url ?? '');
        child.setAttribute('catalog-is-published', this.isPublished ? 'true' : 'false');
        
        return child;
    }
    
    
}