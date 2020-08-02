## setNodeLabels (networkvisualizer)
Set the node labels of a networkvisualizer object.

### Syntax
```Matlab
net = setNodeLabels(net, nodelabels)
net = setNodeLabels(net, classlabels, cvalues)
net = setNodeLabels(net, classlabels, cvalues, cname)
```

### Arguments
* ```net```: Networkvisualizer object created with function [networkvisualizer](networkvisualizer.md).
* ```nodelabels```: A cell array containing the node labels to be displayed for each node.
* ```classlabels```: A cell array containing the class labels to be set for each class value specified in ```cvalues```.
* ```cvalues```: A vector specifying the class values which the modifications will apply.
* ```cname```: A string that specifies the node class to be used for mappping ```cvalues``` to nodes.

### Description
* ```net = setNodeLabels(net, nodelabels)``` sets the node label of every node ```i``` to the string provided in ```nodelabels{i}```. Thus, the ```nodelabels``` should be cell array of length equal to the number of nodes. 
* ```net = setNodeLabels(net, classlabels, cvalues)``` uses the node class values in ```cvalues``` to specify which nodes to be updated. For example, ```setNodeLabels(net, {'label1', 'label2'}, {'A', 'B'})``` sets the labels of nodes with class value ```'A'``` to ```'label1'``` and nodes with class value ```'B'``` to ```'label2'```. This type of specification allows conditional formatting of nodes with respect to the node classes provided. By default, the first node class added by the [addNodeClass](addNodeClass.md) function is used map the class values to nodes.
* ```net = setNodeLabels(net, classlabels, cvalues, cname)``` uses the node class with name ```cname``` to map the class values to nodes.

### Examples

```Matlab
rng(1, 'twister'); % For reproducibility
W = [0 1 1 0 0;1 0 0 1 1;1 0 0 0 0;0 0 0 0 1;1 0 1 0 0];
labels = {'M30931','L07625','K03454','M27323','M15390'};
net = networkvisualizer(W);
net = setNodeLabels(net, labels);
plot(net);
```
which produces:

<img src="examples/setNodeLabels-1.png" width="300">

### See Also
[addNodeClass](addNodeClass.md)


