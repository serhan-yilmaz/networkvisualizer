## NetworkVisualizer (graph visualization library)
<em>Effortlessly create visually appealing network figures with customizable node/edge properties and support for heterogeneous graphs. </em>

## Description 
NetworkVisualizer is a graph visualization library designed for Matlab. It provides a convenient and highly customizable way to create network/graph figures, especially for bioinformatics or biomedical networks such as protein-protein interactions (PPI). The library is particularly useful for heterogeneous networks with variable node sizes and prevents node overlaps. It is designed with small to moderate-sized networks ranging from 50 to 200 nodes in mind. 

The library is inspired by the ggplot2 library in R and utilizes a similar customization system. This allows users to easily modify the appearance and style of the generated graphs.

Some of the key features of NetworkVisualizer include:
* Support for variable node sizes: The library adapts the Fruchterman-Reingold algorithm to prevent node overlaps and accommodate networks with different node sizes.
* Customizable node/edge properties: Users have the flexibility to customize various properties such as labels, colors, line widths, line colors, font sizes, and curvatures for nodes, as well as line widths and colors for the edges. This allows for personalized visualizations that suit specific requirements.
* Support for heterogeneous graphs with multiple node types: NetworkVisualizer seamlessly handles graphs with multiple node types, allowing for the representation of complex network structures. Furthermore, it enables customization of node and edge properties based on the type of the node, providing the ability to tailor the visual representation to specific nodes in the graph.

With these features, NetworkVisualizer offers powerful tools for visualizing and analyzing various types of networks, enabling users to create visually appealing and publication-quality network figures that showcase their data in an engaging and informative manner. The provided flexibility and functionality to effectively explore and present network data can make it a valuable tool for researchers, analysts, and data scientists. 

Please note that the current version of NetworkVisualizer supports only undirected graphs. 

## Getting Started

```Matlab
net = networkvisualizer(W);
plot(net)
```

## Documentation

For more detailed information, see the [documentation](docs/setNodeLabels.md).

## Tutorial
For instructions on how to generate a highly customized figure like the one below, see the [tutorial document](tutorial.pdf).

<img src="sample_output/tutorial_network.png" width="600">

## Demos
Here are some network visualizations that are generated with this library as well as their source code. 

### Demo 1: Correlation Network
See the [demo 1 script](demos/demo_01.m) which produces:

<img src="sample_output/demo1_network.png" width="600">

### Demo 2: Protein-Protein Interaction (PPI) Network

<img src="sample_output/demo2_network.png" width="750">
