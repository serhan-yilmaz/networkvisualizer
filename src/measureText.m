function[width, height] = measureText(txt, opt, axis)
    if(nargin < 3)
       axis = gca(); 
    end
    hTest = text(axis, 0, 0, txt, opt);
    textExt = get(hTest, 'Extent');
    delete(hTest);
    height = textExt(4);    %Height
    width = textExt(3);     %Width
end

