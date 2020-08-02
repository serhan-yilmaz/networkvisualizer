## setNodeLabels (networkvisualizer)
Set the node labels of a networkvisualizer object.

### Syntax
```Matlab
net = setNodeLabels(net, nodelabels)
net = setNodeLabels(net, classlabels, cvalues)
net = setNodeLabels(net, classlabels, cvalues, cname)
```

### Arguments
* ```net```: Networkvisualizer object created with function networkvisualizer.
* ```nodelabels```: A cell array of length *n* containing the node labels to be displayed for each node.
* ```classlabels```: A cell array containing the class labels to be set for each class value specified in ```cvalues```.
* ```cvalues```: A vector specifying the class values which the modifications will apply.
* ```cname```: A string that specifies the node class to be used for mappping ```cvalues``` to nodes.

### Description
* ```net = setNodeLabels(net, nodelabels)``` sets the node label of every node ```i``` to the string provided in ```nodelabels{i}```.
