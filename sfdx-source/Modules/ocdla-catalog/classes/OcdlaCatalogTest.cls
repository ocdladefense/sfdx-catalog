@isTest
public class OcdlaCatalogTest {    
       
    private static String recordPrefix = 'TEST003';
       
    private static String MEMBER_STATUS_LAW_STUDENT_MEMBERSHIP = 'A';
    
    private static String MEMBER_STATUS_REGULAR_MEMBERSHIP = 'R';
    
    private static final String PAID_OFFICE_MEMBERSHIP_OPPORTUNITY_NAME = 'Paid Office Membership Renewal';
    
    public Account a; 
      
    public Contact c;
    
    public Product2 p;
    
    public PricebookEntry entry;
    
    public TaxonomyTerm__c theCatalog;  

    
    
    public OcdlaCatalogTest() {
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        String filter = '%'+recordPrefix+'%';
        
		Ocdla_Apps__c orgSettings = new Ocdla_Apps__c();
        orgSettings.Ocdla_Current_Membership_Term_End_Date__c = System.today();
        insert orgSettings;
        
        this.p = [SELECT Id, Name, Family, Description FROM Product2 LIMIT 1];
        this.p.OcdlaMembershipStatusGrant__c = MEMBER_STATUS_REGULAR_MEMBERSHIP;
        this.p.Family = OcdlaAccountMembershipRenewal.MEMBERSHIP_PRODUCT_FAMILY;
        upsert this.p;
        
        this.entry = [SELECT Id,Product2Id FROM PricebookEntry WHERE Product2Id = :this.p.Id];
        this.entry.IsActive = True;
        upsert this.entry;
        
        System.assertEquals(this.entry.Product2Id, this.p.Id, 'The Product does not match the referenced Pricebook Entry.');
        
        this.a = [SELECT Id, Name FROM Account LIMIT 1];
        
        this.c = [SELECT Id, FirstName, LastName, Ocdla_Current_Member_Flag__c, AccountId, Email FROM Contact WHERE Name LIKE :filter LIMIT 1];
        this.c.AccountId = this.a.Id;
        this.c.Ocdla_Member_Status__c = 'R';
        this.c.Ocdla_Membership_Expiration_Date__c = System.today().addYears(1);
        upsert this.c;
        
        this.a.PrimaryContact__c = c.Id;
        upsert a;
        
        this.c = [SELECT Id, FirstName, LastName, Ocdla_Current_Member_Flag__c, AccountId, Email FROM Contact WHERE Id = :this.c.Id];
        
        System.assertEquals(True,this.c.Ocdla_Current_Member_Flag__c, 'The Contact should be considered a Current Member but is not.');
        
        this.theCatalog = new TaxonomyTerm__c(Name='Publications');
        insert theCatalog;
        
        CatalogEntry__c catItem = new CatalogEntry__c(IsPublished__c=True, TaxonomyTerm__c=theCatalog.Id, Product__c=p.Id);
        insert catItem;  
    }
        
       
    @testSetup
    static void setup() {
        System.assertNotEquals(null, recordPrefix, 'RecordId prefix should not be NULL.');
        ClickpdxCore.TestBase.setup(recordPrefix); 
    } 
     
    
    @isTest
    static void retrieveCatalogItemsByCatalogName(){  

        Test.startTest();
              
            OcdlaCatalogTest context = new OcdlaCatalogTest();

            Test.setCurrentPage(Page.OcdlaCatalog);
			ApexPages.currentPage().getParameters().put('name', 'Publications');

			OcdlaCatalogController theTest = new OcdlaCatalogController();
        	theTest.getCatalogName();
        	theTest.getEntries();
        Test.stopTest();
    }
    

    
  
    @isTest
    static void loadCatalogPage(){

		CatalogException error = new CatalogException();
        
        OcdlaCatalogTest context = new OcdlaCatalogTest();


        Test.startTest();
              
      
            String catalogName = context.theCatalog.Name;
            
            Test.setCurrentPage(Page.OcdlaCatalog);
            ApexPages.currentPage().getParameters().put('name',catalogName);
            OcdlaCatalogController ctrl = new OcdlaCatalogController();

        Test.stopTest();
    }
        
    
    @isTest
    static void loadStoreHome(){

		OcdlaCatalogTest context = new OcdlaCatalogTest();

        Test.startTest();
            
    
            String catalogName = context.theCatalog.Name;
            
            Test.setCurrentPage(Page.Store);
            ApexPages.currentPage().getParameters().put('name',catalogName);
            OcdlaCatalogController ctrl = new OcdlaCatalogController();
            OcdlaCommunityTemplateController theme = new OcdlaCommunityTemplateController();

        Test.stopTest();
    }

    
    @isTest
    static void orderCatalogProducts() {
		CatalogProduct entry1 = new CatalogProduct('CLE Archives', 125.00);
		CatalogProduct entry2 = new CatalogProduct('Publications', 175.00);        
        
        entry1.setOrder(1.0);
        entry2.setOrder(2.0);
        
        List<CatalogProduct> entries = new List<CatalogProduct>{entry1, entry2};
		entries.sort();
    }

}