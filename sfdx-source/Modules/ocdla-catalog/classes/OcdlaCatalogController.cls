global class OcdlaCatalogController extends CommunityController {
     
    
    // Catalog to display when not explictly requested in the URL querystring.
	public static String DEFAULT_CATALOG_NAME = 'Memberships';
    
    private TaxonomyTerm rootTerm;
    
    
    public String catalogName;
    
    
    public List<CatalogProduct> entries = new List<CatalogProduct>();
    
   

    

      
    

    public OcdlaCatalogController() {
        
        Map<String,String> params = ApexPages.currentPage().getParameters();
		Boolean hasCatalogName = null != params && params.size() > 0 && null != params.get('name');
        String catalogName = hasCatalogName ? params.get('name') : OcdlaCatalogController.DEFAULT_CATALOG_NAME;
        
        this.rootTerm = TaxonomyTerm.newFromName(catalogName);
    }
    
    
    public String getCatalogName() {
        return this.rootTerm.name;
    }
    


    public List<CatalogProduct> getEntries() {
        
        // Load the taxonomy node tree.
		Vocabulary.loadTermsRecursive(this.rootTerm);
        
        // Map<String,CatalogProduct> entries = new Map<String,CatalogProduct>();
        List<CatalogProduct> entries = new List<CatalogProduct>();
        List<CatalogEntry__c> records  = new List<CatalogEntry__c>();
        
        // Prepare to iterate of the taxonomy nodes.
        RecursiveNodeIterable it = new RecursiveNodeIterable(rootTerm);

        
        // Map each TaxonomyTerm object to a List of CatalogEntry__c records.
        // Then map each of those to a CatalogEntry (CatalogProduct) object.
        for(Node n : it) {

            TaxonomyTerm term = (TaxonomyTerm)n;

            records.addAll(CatalogTaxonomyToCatalogEntries.toEntries(term));
        }
        

        
        for(CatalogEntry__c record : records) {

          	entries.add(CatalogTaxonomyToCatalogEntries.mapToCatalogProduct(record));
        }
        
        
        return entries;
    }    

    
	// TODO - Not sure this is being used.  Probably should be deprecated and removed.
    /* webservice static CatalogProductList retrieveItems(Id catalogId) {
        return new CatalogProductList(catalogId);
    }
*/
    

    



}