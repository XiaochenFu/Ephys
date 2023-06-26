cc
angle = 0:pi/10:2*pi;
label = zeros(size(angle));
options = [];
figure
subplot 311
options.MTCClassifier='minMaxClassifierCircular';%minMaxClassifierCircular, centroidClassifierCircular, nearestBoundClassifierCircular
for i = 1:length(angle)
    resultant_vector = [angle(i),1];
    celltype = identify_MTC_resultant_vector(resultant_vector, options);
    switch celltype
        case('t')
            celltype = 1;
        case('m')
            celltype = 2;
        case('0')
            celltype = 0;
    end
    label(i) = celltype;
end
polarplot(angle,label)
title(options.MTCClassifier)
subplot 312
options.MTCClassifier='centroidClassifierCircular';
for i = 1:length(angle)
    resultant_vector = [angle(i),1];
    celltype = identify_MTC_resultant_vector(resultant_vector, options);
    switch celltype
        case('t')
            celltype = 1;
        case('m')
            celltype = 2;
        case('0')
            celltype = 0;
    end
    label(i) = celltype;
end
polarplot(angle,label)
title(options.MTCClassifier)
subplot 313
options.MTCClassifier='nearestBoundClassifierCircular';
for i = 1:length(angle)
    resultant_vector = [angle(i),1];
    celltype = identify_MTC_resultant_vector(resultant_vector, options);
    switch celltype
        case('t')
            celltype = 1;
        case('m')
            celltype = 2;
        case('0')
            celltype = 0;
    end
    label(i) = celltype;
end
polarplot(angle,label)
title(options.MTCClassifier)