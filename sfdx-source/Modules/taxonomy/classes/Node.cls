public abstract class Node {

    public List<Node> children = new List<Node>();
    
    public Node() {}
    
    public Boolean hasChildren() {
        return this.children.size() > 0;
    }
    
    public List<Node> getChildren() {
        return this.children;
    }
    
}