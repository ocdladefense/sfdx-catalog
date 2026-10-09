public class RecursiveNodeIterable implements Iterable<Node>, Iterator<Node> {
    // The internal stack tracking nodes we need to visit next
    private List<Node> stack = new List<Node>();

    // Constructor accepts the root node(s) of your tree structure
    public RecursiveNodeIterable(Node rootNode) {
        if (rootNode != null) {
            stack.add(rootNode);
        }
    }

    // 1. ITERABLE INTERFACE: Return this instance to enable for-each loop syntax
    public Iterator<Node> iterator() {
        return this;
    }

    // 2. ITERATOR INTERFACE: We have items left if our stack isn't empty
    public Boolean hasNext() {
        return !stack.isEmpty();
    }

    // 3. ITERATOR INTERFACE: Pop the next node and push its children onto the stack
    public Node next() {
        if (!hasNext()) {
            throw new System.NoSuchElementException('No more elements in tree.');
        }

        // Pop the top item off the stack (LIFO)
        Node currentNode = stack.remove(stack.size() - 1);

        // Push children onto the stack in reverse order 
        // Reverse order ensures the first child stays on top of the stack to process next (DFS)
        if (currentNode.children != null && !currentNode.children.isEmpty()) {
            for (Integer i = currentNode.children.size() - 1; i >= 0; i--) {
                stack.add(currentNode.children[i]);
            }
        }

        return currentNode;
    }
}