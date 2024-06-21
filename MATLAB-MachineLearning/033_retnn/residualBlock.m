function layers = residualBlock(inputChannels, outputChannels, stride)
    if nargin < 3
        stride = 1;
    end
    layers = [
        convolution2dLayer(3, outputChannels, 'Stride', stride, 'Padding', 'same')
        batchNormalizationLayer
        reluLayer
        convolution2dLayer(3, outputChannels, 'Padding', 'same')
        batchNormalizationLayer
    ];
    if inputChannels ~= outputChannels || stride ~= 1
        layers = [
            layers
            additionLayer(2, 'Name', 'add')
        ];
        layers = layerGraph(layers);
        skip = [
            convolution2dLayer(1, outputChannels, 'Stride', stride, 'Padding', 'same')
            batchNormalizationLayer
        ];
        layers = addLayers(layers, skip);
        layers = connectLayers(layers, 'batchnorm_1', 'add/in2');
    else
        layers = [
            layers
            additionLayer(2, 'Name', 'add')
        ];
        layers = layerGraph(layers);
        layers = connectLayers(layers, 'batchnorm_1', 'add/in2');
    end
end
