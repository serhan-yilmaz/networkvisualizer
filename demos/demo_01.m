addpath(genpath('../src/'));
%%
load('../data/Correlation_network.mat');

W = Output.corrData >= 0.2;
W = W + (Output.corrData >= 0.3) + (Output.corrData >= 0.4);
nNode = size(W, 1);

nodeLabels = Output.Itemnames;
nodeLabelsOriginal = Output.ItemnamesOriginal;

questionLabels = regexprep(nodeLabels, '[^0-9]', '');
scaleLabels = regexprep(nodeLabels, '[0-9][^.]*', '');
scaleLabelsOriginal = regexprep(nodeLabelsOriginal, '[0-9][^.]*', '');
movingQuestions = ~strcmpi(scaleLabels, scaleLabelsOriginal);

scaleColors = [0 0.447 0.741; 0.85 0.325 0.098; 0.929 0.694 0.125; 0.466 0.674 0.188];

[scales, ~, scaleIndices] = unique(scaleLabels);
nodeColors = scaleColors(scaleIndices, :);

edges = W(find(triu(W, 1)));
edge_colors = color_spacing_continuous(edges, ...
    [1 3], [0.65 0.65 0.65; 0.35 0.35 0.35]);

rng(1, 'twister');
net = networkvisualizer( Output.corrData .* logical(W), 8);
net = addNodeClass(net, scaleLabels, 'main');
net = addNodeClass(net, movingQuestions, 'MovingQuestion');
net = addNodeClass(net, scaleLabelsOriginal, 'OriginalLabel');
net = setNodeLabels(net, nodeLabels);
net = setNodeColors(net, nodeColors);
net = setNodeSizes(net, 'auto');
net = setNodeFontSize(net, 14);
net = setNodeLineWidth(net, 3.5, true, 'MovingQuestion');
net = setNodeCurvature(net, 0.5, true, 'MovingQuestion');
net = setNodeLineWidth(net, 1.5, false, 'MovingQuestion');
net = setNodeLineColor(net, scaleColors, scales, 'OriginalLabel');
net = setNodeLineColor(net, [0 0 0], false, 'MovingQuestion');
net = addEdgeClass(net, randi([1 2], net.nEdge, 1), 'rng');
net = addEdgeClass(net, edges, 'weight');
net = setEdgeColors(net, edge_colors);
net = setEdgeLineWidth(net, 0.75*0.75*[1 2 3], [1 2 3], 'weight');
net = setOuterGap(net, 0.08);
figure(1);
clf();
set(gcf, 'Position', [0 0 800 640]);
set(gcf, 'Color', [1 1 1]);
plot(net);






