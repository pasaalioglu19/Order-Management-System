// Only some RowNodes has id attribute 
class RowNode {
  RowNode() : attributes = [], children = [], del_button = false, update_button = false, show_button = false, id = -1; 
  RowNode.fromAttributes({required this.attributes, required this.del_button, required this.update_button, required this.show_button, this.id = -1}) : children = [];
  RowNode.withChild({required this.attributes, required this.del_button, required this.update_button, required this.show_button, required this.children, this.id = -1});

  List<String> attributes;
  bool del_button;
  bool update_button;
  bool show_button;
  List<HeaderNode> children;
  int id;
}

class HeaderNode {
  HeaderNode() : attributes = [], children = []; 
  HeaderNode.fromAttributes({required this.attributes}) : children = [];
  HeaderNode.withChild({required this.attributes, required this.children});

  List<String> attributes;
  List<RowNode> children;
}

class Tree {
  Tree() : head = HeaderNode();
  Tree.fromHead({required this.head});
  
  HeaderNode head; 
}