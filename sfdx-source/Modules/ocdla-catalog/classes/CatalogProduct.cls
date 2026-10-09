global class CatalogProduct implements Comparable {
    
    // The name to be displayed for this catalog entry.
    webservice String displayName {get;private set;}
      
    // The related product, if any.
    webservice Id relatedProductId {get;private set;}
    
    // The price to be displayed.
    webservice Decimal price {get;private set;}
    
    // The url where the customer can get product details.
    webservice String url {get;private set;}

    // The name of the catalog (Taxonomy Term) for this entry.
    webservice String catalogName {get;private set;}
    
    // The order token, if any.
    webservice Decimal orderToken {get;private set;}
    
    
    
    public CatalogProduct(String displayName, Decimal price, String theId, Decimal orderToken) {
        
        this.displayName = displayName;
        this.price = price;
        this.relatedProductId = theId;
        this.orderToken = orderToken;
    }

    
    
    public CatalogProduct(String displayName, Decimal price) {
        this(displayName, price, null, null);
    }
    
    public CatalogProduct(String displayName, Decimal price, String theId) {
        this(displayName, price, theId, null);
    }
    
    public void setOrder(Decimal orderToken) {
        this.orderToken = orderToken;
    }

    
    global Integer compareTo(Object compareTo) {
        CatalogProduct compareToEmp = (CatalogProduct)compareTo;
        if (this.orderToken == compareToEmp.orderToken) return 0;
        if (this.orderToken < compareToEmp.orderToken) return 1;
        return -1;        
    }
    

    
}