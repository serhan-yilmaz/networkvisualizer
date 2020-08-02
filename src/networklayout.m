function [x, y] = networklayout( W, nodeSizes )
    nodeSizes = nodeSizes / 100;
    nNode = size(W, 1);
    x = rand(1, nNode);
    y = rand(1, nNode);
    Dt = nodeSizes + nodeSizes';
    Dt = Dt - diag(diag(Dt));

    alpha = 0.1/nNode;

    w = full(W);
    numStep = 1000;
    stepSizes = logspace(-1, -3, numStep);
%     stepSizes = [stepSizes, 1e-3*ones(1,6000)];
%     numStep = length(stepSizes);
    for i = 1:numStep
        stepSize = stepSizes(i);
        x(x>=1.02) = 1.0;
        y(y>=1.02) = 1.0;
        x(x<=-0.02) = -0.0;
        y(y<=-0.02) = -0.0;
        D = squareform(pdist([x;y]'));
        xcomp = (x - x')./D;
        ycomp = (y - y')./D;
        xcomp(isnan(xcomp)) = 0;
        ycomp(isnan(ycomp)) = 0;
        
        Dpull = D;
        Dpull = Dpull - Dt;
        overlapping_indices = D <= Dt;
        Dpull(Dpull >= 0.6) = 0.6;
        Dpull(overlapping_indices) = 0;
        
        Dpush = alpha * (1./(Dpull + 0.2))/2;
        Dpush(overlapping_indices) = 0;

        Doverlap = zeros(size(D));
        Doverlap(overlapping_indices) = 1.2;

        F = stepSize * (Doverlap + Dpush .* ~w - Dpull .* w);
        Fx = F .* xcomp;
        Fy = F .* ycomp;
        Fx = Fx - diag(diag(Fx));
        Fy = Fy - diag(diag(Fy));    
        Fcx = stepSize * (0.5 - x).*(0.5 - x).*(0.5 - x) * 0.7;
        Fcy = stepSize * (0.5 - y).*(0.5 - y).*(0.5 - y) * 0.7;
        a = sum(Fx, 1) + Fcx;
        b = sum(Fy, 1) + Fcy;
        x = x + a;
        y = y + b;
    end
    x = x';
    y = y';
end

