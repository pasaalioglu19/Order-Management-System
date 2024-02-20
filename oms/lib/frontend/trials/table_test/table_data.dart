import 'package:oms/frontend/model/table_tree.dart';


// ONLY LEVEL 1 ROWNODES HAVE ID ATTRIBUTE, WHICH ARE BUTTONABLE I.E. OTHER NODES CAN'T POSSES ANY BUTTON.
Tree my_data = Tree.fromHead(
  head: HeaderNode.withChild(
      attributes: ["Product Name", "Product Status"],
      children: [
        RowNode.withChild(
            id: 1,
            attributes: ["Clothes", "Available"],
            del_button: false,
            update_button: false,
            show_button: false,
            children: [
              HeaderNode.withChild(
                  attributes: ["Size", "Stock Status"],
                  children: [
                    RowNode.fromAttributes(
                        attributes: ["XXL", "Available"],
                        del_button: false,
                        update_button: false,
                        show_button: false),
                    RowNode.fromAttributes(
                        attributes: ["XL", "Available"],
                        del_button: false,
                        update_button: false,
                        show_button: false)
                  ]),
              HeaderNode.withChild(
                  attributes: ["Color", "Stock Status"],
                  children: [
                    RowNode.fromAttributes(
                        attributes: ["Blue", "Available"],
                        del_button: false,
                        update_button: false,
                        show_button: false),
                      RowNode.fromAttributes(
                        attributes: ["Red", "Unavailable"],
                        del_button: false,
                        update_button: false,
                        show_button: false)
                  ]
                ),
            ]),
        RowNode.fromAttributes(
            id: 2,
            attributes: ["Bread", "Available"],
            del_button: true,
            update_button: true,
            show_button: false),
        RowNode.fromAttributes(
            id: 3,
            attributes: ["Diapher", "Unavailable"],
            del_button: true,
            update_button: true,
            show_button: false),
      ]),
);

Tree my_data2 = Tree.fromHead(
  head: HeaderNode.withChild(
      attributes: ["Product Name", "Amount"],
      children: [
        RowNode.withChild(
            id: 1,
            attributes: ["Clothes", "10"],
            del_button: false,
            update_button: false,
            show_button: false,
            children: [
              HeaderNode.withChild(
                  attributes: ["Size", "Amount"],
                  children: [
                    RowNode.fromAttributes(
                        attributes: ["XXL", "4"],
                        del_button: false,
                        update_button: false,
                        show_button: false),
                    RowNode.withChild(
                        attributes: ["XL", "6"],
                        del_button: false,
                        update_button: false,
                        show_button: false,
                        children: 
                      [
                      HeaderNode.withChild(
                          attributes: ["Color", "Amount"],
                          children: [
                            RowNode.fromAttributes(
                                attributes: ["Blue", "5"],
                                del_button: false,
                                update_button: false,
                                show_button: false),
                              RowNode.fromAttributes(
                                attributes: ["Red", "1"],
                                del_button: false,
                                update_button: false,
                                show_button: false)
                                ])
                      ]
                    ),
                  ]
                ),
            ]),
        RowNode.fromAttributes(
            id: 2,
            attributes: ["Bread", "10"],
            del_button: true,
            update_button: true,
            show_button: false),
        RowNode.fromAttributes(
            id: 3,
            attributes: ["Diapher", "20"],
            del_button: true,
            update_button: true,
            show_button: false),
      ]),
);