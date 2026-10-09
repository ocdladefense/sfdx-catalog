/**
 * Utility class to represent the relationship between a Vocabulary its taxonomy terms 
 * as an XmlNode tree.
 * 
 * For example:
 *   Vocabulary: 'Store Catalog'
 * 			--	Term: 'CLE Archives'
 * 			--	Term: 'Publications'
 * 			--	Term: 'Seminars & Events'
 */
public class Vocabulary implements IXmlDocument {

    // The internal name for this Vocabulary object.
    private String name;
    
    private TaxonomyTerm rootTerm = new TaxonomyTerm();
    

      
    
    public Vocabulary(String name) {
        this.name = name;
        this.rootTerm.setVocabulary('Store Catalog');
    }
    
    
    public TaxonomyTerm addTerm(String name) {
        TaxonomyTerm term = new TaxonomyTerm(name);
        
		this.rootTerm.addChild(term);
        
        return term;
    }
    
  
    
    
    public List<TaxonomyTerm> addTerms(List<String> names) {
        List<TaxonomyTerm> terms = new List<TaxonomyTerm>();
        
        for(String name : names) {
            TaxonomyTerm term = new TaxonomyTerm(name);
            this.rootTerm.addChild(term);
        }
        
        return terms;
    }
    
    
    /**
     * Gets the direct children of the rootElement.
     * This corresponds to the top-level catalogs for the store.
     */
    public List<Node> getTerms() {
        return this.rootTerm.getChildren();
    }
    

    
    public Boolean hasTerms() {
        return this.rootTerm.children.size() > 0;
    }
    
    
    public Integer size() {
        return this.rootTerm.children.size();
    }
    
      
    public static Vocabulary newFromVocabulary(String name) {
       
        Vocabulary v = new Vocabulary(name);
        v.loadTerms();
        
        return v;
    }
    
    
    public void loadTerms() {
		Vocabulary.loadTermsRecursive(this.rootTerm);   
    }
    
    // Recursively load all children for this term.
    public static void loadTermsRecursive(TaxonomyTerm term) {
        
        for(TaxonomyTerm t : term.loadChildren()) {
            
            Vocabulary.loadTermsRecursive(t);
        }
    }
    
    
    public Dom.Document toXmlDocument() {
		Dom.Document doc = new Dom.Document();
		Dom.XmlNode root = doc.createRootElement('vocabulary', 'https://ocdla.org', '');
        root.setAttribute('name', this.name);
        
        buildNodeTree(root, this.getTerms());
        return doc;
    }
    
    
    private static Dom.XmlNode buildNodeTree(Dom.XmlNode parent, List<Node> terms) {
        
        for(Node n : terms) {
            TaxonomyTerm term = (TaxonomyTerm)n;
            Dom.XmlNode child = term.toXmlNode(parent);
            if(!term.hasChildren()) continue;
            buildNodeTree(child, term.getChildren());
        }
        
        return parent;
    }
   

}