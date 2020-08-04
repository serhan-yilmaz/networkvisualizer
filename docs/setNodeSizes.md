## setNodeSizes (networkvisualizer)
Set the node sizes of a networkvisualizer object.

### Syntax
```Matlab
net = setNodeSizes(net, values)
net = setNodeSizes(net, values, categories)
net = setNodeSizes(net, values, categories, classname)
```

### Arguments
* ```net```: Networkvisualizer object created with function [networkvisualizer](networkvisualizer.md).
* ```values```: A scalar value or a cell array containing the node sizes to be set.
* ```categories```: A vector specifying the class categories which the modifications will apply.
* ```classname```: A string that specifies which node class the given ```categories``` correspond to.

### Description
* ```net = setNodeSizes(net, values)``` sets the node sizes of every node. If ```values``` is a cell array, it sets the node size of node ```i``` to the size provided in ```values{i}```. Otherwise, scalar value is set to all nodes in the network. 
* ```net = setNodeSizes(net, values, categories)``` uses the node class categories in ```categories``` to specify which nodes to be resized. For example, ```setNodeSizes(net, {10, 12}, {'A', 'B'})``` sets the sizes of nodes with category ```'A'``` to ```10``` and nodes with category ```'B'``` to ```12```. This type of specification allows conditional formatting of nodes with respect to the categories provided. By default, it is assumed that the categories correspond to the first node class added by the [addNodeClass](addNodeClass.md) function.
* ```net = setNodeSizes(net, values, categories, classname)``` uses the node class with name ```classname``` for the provided categories.

### Examples


#### Setting the node labels


#### Updating labels using node classes


### See Also
[addNodeClass](addNodeClass.md), [setNodeFontSize](setNodeFontSize.md)


