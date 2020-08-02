classdef networkvisualizer < handle
    % To do ...
    % Add a legend entry based on the node colors
    
    properties (SetAccess = private)
        X
        Y
        NodeSizes
        Network
        EdgeList
        NodeLabels
        NodeColors
        NodeLineWidth
        NodeLineColor
        NodeLabelColor
        NodeClasses
        NodeClassLabels
        NodeCurvature
        NodeFontSize
        NodeSizeAuto = false;
        EdgeClasses
        EdgeClassLabels
        EdgeColors
        EdgeLineWidth
        nNode
        nEdge
        OuterGap = 0.05;
        drawOuterRectangle = true;
        isDirected = false;
    end
    
    properties (Access = private)
        nodeColorsAreSet_ = false;
    end
    
    methods
        function [obj] = networkvisualizer(W, nodeSizes)
            obj.Network = W;
            if(nargin < 2)
                nodeSizes = obj.getdefaultNodeSizes();
            end
            obj = obj.initialize();
            if(isscalar(nodeSizes))
                nodeSizes = repmat(nodeSizes, obj.nNode, 1);
            end
            obj.NodeSizes = nodeSizes;
            obj = obj.dolayout();
        end
        
        function [obj] = dolayout(obj, nodeSizes)
            if(nargin < 2)
                nodeSizes = obj.NodeSizes;
            end
            if(isscalar(nodeSizes))
                nodeSizes = repmat(nodeSizes, obj.nNode, 1);
            end
            [obj.X, obj.Y] = networklayout(obj.Network, nodeSizes);
        end
        
        function [] = plot(obj, axis)
            if(nargin < 2); axis = gca(); end
            drawnetwork(obj.X, obj.Y, obj.NodeSizes, obj.Network, axis, ...
                'DrawOuterRectangle', obj.drawOuterRectangle, ...
                'OuterGap', obj.OuterGap, ...
                'NodeLabels', obj.NodeLabels, ...
                'NodeColors', obj.NodeColors, ...
                'NodeLineWidth', obj.NodeLineWidth, ...
                'NodeLineColor', obj.NodeLineColor, ...
                'NodeLabelColor', obj.NodeLabelColor, ...
                'NodeFontSize', obj.NodeFontSize, ...
                'NodeCurvature', obj.NodeCurvature, ...
                'FitNodeSizes', obj.NodeSizeAuto, ...
                'EdgeColors', obj.EdgeColors, ...
                'EdgeLineWidth', obj.EdgeLineWidth);
        end
        
        function [obj] = addNodeClass(obj, values, cname)
           index = length(obj.NodeClasses) + 1;
           if(nargin < 3)
               cname = ['nodeclass', num2str(index)];
           end
           validateattributes(values, ...
               {'logical', 'numeric', 'cell'}, ...
               {'column', 'numel', obj.nNode});
           obj.NodeClasses{index} = values;
           obj.NodeClassLabels{index} = cname;
           
           if(~obj.nodeColorsAreSet_)
               classes = unique(values);
               defaultColors = getDefaultColors(obj);
               if(length(classes) <= length(defaultColors))
                   obj = setNodeColors(obj, defaultColors, classes, cname);
               end
           end
        end
        
        function [obj] = setNodeSizes(obj, values, classes, cname)
            if(nargin < 3); classes = []; end
            if(nargin < 4); cname = []; end
            if(strcmpi(values, 'auto'))
                obj.NodeSizeAuto = true;
            else
                obj.NodeSizeAuto = false;
                obj = setProperty(obj, values, classes, cname, 'NodeSizes');
            end
        end
        
        function [obj] = scaleNodeSizes(obj, values, coef)
            if(nargin < 3); coef = 1; end
            coeff = sqrt(coef*1200 / obj.nNode) / mean(values);
            values = values * coeff;
            obj = setNodeSizes(obj, values);
        end
        
        function [obj] = setNodeLabels(obj, values, classes, cname)
            if(nargin < 3); classes = []; end
            if(nargin < 4); cname = []; end
            if(strcmpi(values, 'auto'))
                values = regexprep(cellstr(num2str((1:obj.nNode)')), ' ', '');
            end
            obj = setProperty(obj, values, classes, cname, 'NodeLabels');
        end
        
        function [obj] = setNodeFontSize(obj, values, classes, cname)
            if(nargin < 3); classes = []; end
            if(nargin < 4); cname = []; end
            obj = setProperty(obj, values, classes, cname, 'NodeFontSize');
        end
        
        function [obj] = setNodeColors(obj, values, classes, cname)
            if(nargin < 3); classes = []; end
            if(nargin < 4); cname = []; end
            if(ischar(values) && strcmpi(values, 'default'))
               obj = setDefaultColoring(obj);
               obj.nodeColorsAreSet_ = false;
               return;
            end
            obj = setProperty(obj, values, classes, cname, 'NodeColors');
            obj.nodeColorsAreSet_ = true;
        end
        
        function [obj] = setNodeCurvature(obj, values, classes, cname)
            if(nargin < 3); classes = []; end
            if(nargin < 4); cname = []; end
            obj = setProperty(obj, values, classes, cname, 'NodeCurvature');
        end
        
        function [obj] = setNodeLineWidth(obj, values, classes, cname)
            if(nargin < 3); classes = []; end
            if(nargin < 4); cname = []; end
            obj = setProperty(obj, values, classes, cname, 'NodeLineWidth');
        end
        
        function [obj] = setNodeLineColor(obj, values, classes, cname)
            if(nargin < 3); classes = []; end
            if(nargin < 4); cname = []; end
            obj = setProperty(obj, values, classes, cname, 'NodeLineColor');
        end
        
        function [obj] = setNodeLabelColor(obj, values, classes, cname)
            if(nargin < 3); classes = []; end
            if(nargin < 4); cname = []; end
            obj = setProperty(obj, values, classes, cname, 'NodeLabelColor');
        end
        
        function [obj] = addEdgeClass(obj, values, cname)
           index = length(obj.EdgeClasses) + 1;
           if(nargin < 3)
               cname = ['edgeclass', num2str(index)];
           end
           validateattributes(values, ...
               {'logical', 'numeric', 'cell'}, ...
               {'column', 'numel', obj.nEdge});
           obj.EdgeClasses{index} = values;
           obj.EdgeClassLabels{index} = cname;
        end
        
        function [obj] = createEdgeClass(obj, newcname, classes1, classes2, cname1, cname2)
            if(nargin < 5); cname1 = []; end
            if(nargin < 6); cname2 = cname1; end
            classIndex1 = getNodeClass(obj, cname1);
            classIndex2 = getNodeClass(obj, cname2);
            [b1] = ismember(obj.NodeClasses{classIndex1}, classes1);
            [b2] = ismember(obj.NodeClasses{classIndex2}, classes2);
            v1 = b1(obj.EdgeList(:, 1));
            v2 = b2(obj.EdgeList(:, 2));
            vt = v1 & v2;
            if(~obj.isDirected)
                v1 = b1(obj.EdgeList(:, 2));
                v2 = b2(obj.EdgeList(:, 1));
                vt = vt | (v1 & v2);
            end
            obj = addEdgeClass(obj, vt, newcname);
        end
        
        function [obj] = setEdgeColors(obj, values, classes, cname)
            if(nargin < 3); classes = []; end
            if(nargin < 4); cname = []; end
            obj = setEdgeProperty(obj, values, classes, cname, 'EdgeColors');
        end
        
        function [obj] = setEdgeLineWidth(obj, values, classes, cname)
            if(nargin < 3); classes = []; end
            if(nargin < 4); cname = []; end
            obj = setEdgeProperty(obj, values, classes, cname, 'EdgeLineWidth');
        end
        
        function [obj] = setOuterGap(obj, value)
           obj.OuterGap = value; 
        end
        
        function [obj] = setOuterRectangleEnabled(obj, value)
           obj.drawOuterRectangle = value;
        end
    end
    
    methods (Access = private)
        function [nodesizes] = getdefaultNodeSizes(obj)
            nNodes = size(obj.Network, 1);
            nodecoeff = sqrt(1800/nNodes);
            nodesizes = repmat(nodecoeff, nNodes, 1);
        end
        
        function [obj] = initialize(obj)
            obj.nNode = size(obj.Network, 1);
            obj.NodeLabels = cell(obj.nNode, 1);
            obj.NodeColors = repmat([0.992 0.918 0.855], obj.nNode, 1);
            obj.NodeLineWidth = repmat(0.75, obj.nNode, 1);
            obj.NodeLineColor = repmat([0 0 0], obj.nNode, 1);
            obj.NodeFontSize = repmat(9, obj.nNode, 1);
            obj.NodeCurvature = ones(obj.nNode, 1);
            obj.NodeClassLabels = cell(0, 1);
            obj.NodeClasses = cell(0, 1);
            edges = find(triu(obj.Network, 1));
            [i1, i2] = ind2sub(size(obj.Network), edges);
            obj.EdgeList = [i1 i2];
            obj.nEdge = length(obj.EdgeList);
            obj.EdgeClassLabels = cell(0, 1);
            obj.EdgeClasses = cell(0, 1);
            obj.EdgeLineWidth = repmat(1.25, obj.nEdge, 1);
            obj.EdgeColors = repmat([0.65 0.65 0.65], obj.nEdge, 1);
        end
        
        function [obj] = setEdgeProperty(obj, values, classes, cname, property)
           if(isempty(cname)); cname = 'edgeclass1'; end
           if(isempty(classes))
               if(size(values, 1) == 1)
                    values = repmat(values, obj.nEdge, 1);
               end
               obj.(property)(:, :) = values;
           else
               if(length(obj.EdgeClasses) < 1)
                   ex = MException(...
                       'networkvisualizer:edgeclass:emptyclass', ...
                       'Edge classes are not set. To add a edge class use ''addEdgeClass'' function.');
                   throwAsCaller(ex);
               end
               [~, classIndex] = ismember(cname, obj.EdgeClassLabels);
               if(classIndex == 0)
                   ex = MException(...
                       'networkvisualizer:edgeclass:notfound', ...
                       sprintf('Edge class %s is not found.', cname));
                   throwAsCaller(ex);
               end
               nElement = numel(classes);
               nColumn = size(obj.(property), 2);
               nRow = size(obj.(property), 1);
               
               if((nColumn == 1) && (nElement == numel(values)) ...
                       && (size(values, 1) == 1))
                   values = values';
               end
               
               [b, ib] = ismember(obj.EdgeClasses{classIndex}, classes);
               obj.(property)(b, :) = values(ib(b), :);
           end
        end
        
        function [obj] = setProperty(obj, values, classes, cname, property)
           if(isempty(classes))
               if((size(obj.(property), 2) == 1) && isrow(values))
                   values = values';
               end
               if(size(values, 1) == 1)
                    values = repmat(values, obj.nNode, 1);
               end
               obj.(property)(:, :) = values;
           else
               classIndex = getNodeClass(obj, cname);               
               [b, ib] = ismember(obj.NodeClasses{classIndex}, classes);
               obj.(property)(b, :) = values(ib(b), :);
           end
        end
        
        function [classIndex] = getNodeClass(obj, cname)
           if(length(obj.NodeClasses) < 1)
               ex = MException(...
                   'networkvisualizer:nodeclass:emptyclass', ...
                   'Node classes are not set. To add a node class use ''addNodeClass'' function.');
               throwAsCaller(ex);
           end
           if(isempty(cname)); cname = obj.NodeClassLabels{1}; end
           [~, classIndex] = ismember(cname, obj.NodeClassLabels);
           if(classIndex == 0)
               ex = MException(...
                   'networkvisualizer:nodeclass:notfound', ...
                   sprintf('Node class %s is not found.', cname));
               throwAsCaller(ex);
           end
        end
        
        function [obj] = setDefaultColoring(obj)
            if(length(obj.NodeClasses) < 1)
                obj = setFixedColoring(obj);
            else
               classes = unique(obj.NodeClasses{1});
               cname = obj.NodeClassLabels{1};
               defaultColors = getDefaultColors(obj);
               if(length(classes) <= length(defaultColors))
                   obj = setNodeColors(obj, defaultColors, classes, cname);
               else
                   obj = setFixedColoring(obj);
               end
            end
        end
        function [obj] = setFixedColoring(obj)
            obj.NodeColors = repmat([0.992 0.918 0.855], obj.nNode, 1);
        end
        
        function [defaultColors] = getDefaultColors(obj)
            defaultColors = [0 0.447 0.741; 0.85 0.325 0.098; ...
                0.929 0.694 0.125; 0.466 0.674 0.188; 0.301 0.745 0.933];
        end
    end
end

