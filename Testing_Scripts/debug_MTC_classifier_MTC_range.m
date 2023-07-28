cc
outputpath = 'C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Common_Functions\Sample_Plots';
angle = 0:pi/100:2*pi;
options = [];
MC_colour =  [0.6328    0.0781    0.1836];
TC_colour = [0.3008    0.7422    0.9297];
Other_colour = [0.5 0.5 0.5];
% figure

options.MTCClassifier='minMaxClassifierCircular';%minMaxClassifierCircular, centroidClassifierCircular, nearestBoundClassifierCircular
label = zeros(size(angle));
label_t = zeros(size(angle));
label_m = zeros(size(angle));
label_o = zeros(size(angle));
for i = 1:length(angle)
    resultant_vector = [angle(i),1];
    celltype = identify_MTC_resultant_vector(resultant_vector, options);
    switch celltype
        case('t')
            celltype = 1;
            label_t(i) = 1;
        case('m')
            celltype = 2;
            label_m(i) = 1;
        case('o')
            celltype = 0;
            label_o(i) = 1;
    end
    label(i) = celltype;
end
figure(1)
subplot 131
polarplot(angle,label)
title(options.MTCClassifier)
figure(2)
subplot 221
polarplot(angle,label_t,'Color',TC_colour); hold on;
polarplot(angle,label_m,'Color',MC_colour);
polarplot(angle,label_o,'Color',Other_colour);
title(options.MTCClassifier)
%%
options.MTCClassifier='centroidClassifierCircular';
label = zeros(size(angle));
label_t = zeros(size(angle));
label_m = zeros(size(angle));
label_o = zeros(size(angle));
for i = 1:length(angle)
    resultant_vector = [angle(i),1];
    celltype = identify_MTC_resultant_vector(resultant_vector, options);
    switch celltype
        case('t')
            celltype = 1;
            label_t(i) = 1;
        case('m')
            celltype = 2;
            label_m(i) = 1;
        case('o')
            celltype = 0;
            label_o(i) = 1;
    end
    label(i) = celltype;
end
figure(1)
subplot 132
polarplot(angle,label)
title(options.MTCClassifier)
figure(2)
subplot 222
polarplot(angle,label_t,'Color',TC_colour); hold on;
polarplot(angle,label_m,'Color',MC_colour);
polarplot(angle,label_o,'Color',Other_colour);
title(options.MTCClassifier)
%%
options.MTCClassifier='nearestBoundClassifierCircular';
label = zeros(size(angle));
label_t = zeros(size(angle));
label_m = zeros(size(angle));
label_o = zeros(size(angle));
for i = 1:length(angle)
    resultant_vector = [angle(i),1];
    celltype = identify_MTC_resultant_vector(resultant_vector, options);
    switch celltype
        case('t')
            celltype = 1;
            label_t(i) = 1;
        case('m')
            celltype = 2;
            label_m(i) = 1;
        case('o')
            celltype = 0;
            label_o(i) = 1;
    end
    label(i) = celltype;
end
figure(1)
subplot 133
polarplot(angle,label)
title(options.MTCClassifier)
figure(2)
subplot 223
polarplot(angle,label_t,'Color',TC_colour); hold on;
polarplot(angle,label_m,'Color',MC_colour);
polarplot(angle,label_o,'Color',Other_colour);
title(options.MTCClassifier)
%% save the output
figure(2)
subplot 224
p1 = plot(nan,nan,'Color',TC_colour); hold on;
p2 = plot(nan,nan,'Color',MC_colour);
p3 = plot(nan,nan   ,'Color',Other_colour);
% colorbar off
legend([p1 p2 p3], {'TC range','MC range','Others range'})
box off
axis off
saveimg(gcf,outputpath,'MTCClassifier','phase','111')