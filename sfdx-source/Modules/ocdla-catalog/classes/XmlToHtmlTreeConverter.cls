/**
 * Convert an XML tree to an HTML tree.
 * Used to build an HTML menu.
 */
public class XmlToHtmlTreeConverter implements IXmlDocumentConverter {

    // Tree-menus.
    Dom.XmlNode treeItem;
    
    // Sub-menus.
    Dom.XmlNode treeBranch;
    
    
    public XmlToHtmlTreeConverter() {
        // Set default tree menus and tree branches.
    }
    
    public Dom.Document convert(String xmlInput) {
        return convertXmlToHtmlTree(xmlInput);
    }
    
    
    public static Dom.Document convertXmlToHtmlTree(String xmlInput) {
        // 1. Parse the source XML
        Dom.Document srcDoc = new Dom.Document();
        
        try {
            srcDoc.load(xmlInput);
        } catch (Exception e) {
            System.debug('Error parsing XML: ' + e.getMessage());
            return null;
        }

        // 2. Initialize the destination HTML Document
        Dom.Document htmlDoc = new Dom.Document();
        Dom.XmlNode srcRoot = srcDoc.getRootElement();
        
        // 3. Kick off recursion. The base container for a list must be a <ul>
        Dom.XmlNode htmlRoot = htmlDoc.createRootElement('ul', null, null);
        htmlRoot.setAttribute('class','menu');
        
        // Populate the tree recursively
        buildHtmlTree(srcRoot, htmlRoot);
        
        return htmlDoc;
    }

    private static void buildHtmlTree(Dom.XmlNode srcNode, Dom.XmlNode container) {
        
        if (srcNode == null || container == null) {
            return;
        }

  
        for (Dom.XmlNode srcChild : srcNode.getChildElements()) {
            
            // 1. Create the <li> element inside the current container (<ul>).
            MenuItemNode factoryForLiTag = new MenuItemNode();
            Dom.XmlNode liNode = factoryForLiTag.toHtmlNode(srcChild, container);

            // 2. Check if this source element has its own nested items.
            List<Dom.XmlNode> deeperChildren = srcChild.getChildElements();
            
            if (!deeperChildren.isEmpty()) {
                
                SubMenuNode subMenu = new SubMenuNode();
                
                // To maintain valid HTML structure, nested lists must live inside the <li>
                Dom.XmlNode nestedUlNode = subMenu.toHtmlNode(null, liNode);
                
                // Recurse down, passing the nested <ul> as the new container for the children
                buildHtmlTree(srcChild, nestedUlNode);
            }
        }
    }
    

    
    
    public class MenuNode {
        
        public Dom.XmlNode toHtmlNode(Dom.XmlNode nodeToConvert, Dom.XmlNode parent) {
            
            return null;
        }
    }
    
    
      
    
    
    public class MenuItemNode {

        public Dom.XmlNode toHtmlNode(Dom.XmlNode item, Dom.XmlNode parent) {
            
            String catalogName = item.getAttributeValue('catalog-name',null)?? '';
            String catalogId = item.getAttributeValue('catalog-id',null)??'';
            String catalogUrl = item.getAttributeValue('catalog-url',null);
            String published = item.getAttributeValue('catalog-is-published', null) ?? 'false';
            Boolean isPublished = published == 'true';
            
            Dom.XmlNode child = parent.addChildElement('li', null, null);
            child.setAttribute('class','menu-item');
            
            Dom.XmlNode link = child.addChildElement('a', null, null);
            link.addTextNode(catalogName);
            link.setAttribute('href', catalogUrl ?? '#');
            link.setAttribute('data-catalog-name', catalogName);
            link.setAttribute('data-catalog-id', catalogId);
            // link.setAttribute('data-catalog-url', catalogUrl);
            link.setAttribute('data-url', String.isBlank(catalogUrl) ? 'null' : catalogUrl);
            
            if(!isPublished) {
                child.setAttribute('style', 'display:none;');
            }
            
            return child;
        }
    }
    
    
    public class SubMenuNode {
        
        public Dom.XmlNode toHtmlNode(Dom.XmlNode item, Dom.XmlNode parent) {
            
            Dom.XmlNode child = parent.addChildElement('ul',null,null);
            child.setAttribute('class','menu sub-menu');
            
            return child;
        }
        
    }
}