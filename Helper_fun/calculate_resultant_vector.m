function resultant_vector = calculate_resultant_vector(phase,spike_per_cycle, varargin)
if ~isempty(varargin)
    option = varargin{1}; % parameters supplied by user
else
    option = [];
end
isplot = getOr(option, 'isplot', 0);
saveplot = getOr(option, 'saveplot', 0);

% convert to polar axis
x = spike_per_cycle.*cos(phase);
y = spike_per_cycle.*sin(phase);
rx = mean(x);
ry = mean(y);
[r_phy,r_r] = cart2pol(rx,ry);
resultant_vector = [r_phy;r_r];
% r_phy = sum(spike_per_cycle.*phase)/sum(phase) probably wrong
% r_r = mean(spike_per_cycle) probably wrong

if exist("isplot","var")
    if isplot
        %         figure
        %         subplot 121
        %         polarplot(phase,spike_per_cycle)
        %         pax = gca;
        %         pax.ThetaAxisUnits = 'radians';
        %         hold on
        % %         compass(r_phy,r_r)
        %         subplot 122
        %
        %         plot(x,y);
        %
        % %         xy_range = [-1 1]*floor(max(max(abs(x)),max(abs(y))));
        %
        % %         xlim(xy_range)
        % %         ylim(xy_range)
        % %         axis equal
        %         hold on
        %         arrow([0;0], [rx;ry])
        figure
        compass(max(abs(spike_per_cycle)),max(abs(spike_per_cycle)),'w:')
        hold on
        compass(rx,ry)
        hold on
        plot(x,y);
        if saveplot
            saveimg(gcf,"C:\Users\yycxx\OneDrive - OIST\Ephys_Code\Common_Functions\Sample_Plots","Demo","resultant_vector",111);
        end
    end
end

end