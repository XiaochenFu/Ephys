classdef Tet_Light_Unit_Dual_PR < Tet_Light_Unit_Dual
    properties
        Stimuli_Grouped_PR % a sructure of light stimuli.

    end
    methods
        % check if the unit is evoked by medial, lateral or both.
        function light_response = get_light_response_PR(obj, stim_grouped_PR0, varargin)
            % Handle error for too many inputs
            if length(varargin)>1
                error("Too many inputs. Please check.")
            end

            % Check for optional parameters
            if ~isempty(varargin)
                option = varargin{1}; % Parameters supplied by user
            else
                option = [];
            end
            % get the light response for Phase reference stimuli
            %% Check the lateral part and the medial part seperately. doesn't work well because of the overlap
                        stim_grouped.DrivingCurent = stim_grouped_PR0.DrivingCurrent;
                        stim_grouped.Frequency = stim_grouped_PR0.Frequency;
                        stim_grouped.PulseWidth_ms = stim_grouped_PR0.PulseWidth_ms;
                        stim_grouped.PulseNumber = stim_grouped_PR0.PulseNumber;
                        stim_grouped_Lat = stim_grouped;
                        %                         stim_grouped_Lat.TrialOnset = stim_grouped_PR0.TrialOnset_Lat;
                        %                         stim_grouped_Lat.LatencyFromCalculatedSniffOnset_ms = stim_grouped_PR0.LatencyFromCalculatedSniffOnset_ms_Lat;
                        stim_grouped_Lat.TrialOnset = extractfield(stim_grouped_PR0,'TrialOnset_Lat');
                        stim_grouped_Lat.LatencyFromCalculatedSniffOnset_ms = extractfield(stim_grouped_PR0,'LatencyFromCalculatedSniffOnset_ms_Lat');
                        light_response_lat = get_light_response(obj, stim_grouped_Lat, option);

                        stim_grouped_Med = stim_grouped;
%                         stim_grouped_Med.TrialOnset = stim_grouped_PR0.TrialOnset_Med;
%                         stim_grouped_Med.LatencyFromCalculatedSniffOnset_ms = stim_grouped_PR0.LatencyFromCalculatedSniffOnset_ms_Med;
                        stim_grouped_Med.TrialOnset = extractfield(stim_grouped_PR0,'TrialOnset_Med');
                        stim_grouped_Med.LatencyFromCalculatedSniffOnset_ms = extractfield(stim_grouped_PR0,'LatencyFromCalculatedSniffOnset_ms_Med');
               
                        light_response_lat_med = get_light_response_Medial(obj, stim_grouped_Med, option);
                        light_response = [light_response_lat, light_response_lat_med];
                        %             %% Check the lateral part and the medial together
                        %             % Obtain spike times and spontaneous sniff onset
                        %             spiketime = obj.st;
                        %             sniffonsets = obj.SniffOnset;
                        %             for ti = 1:length(stim_grouped_PR0)
                        %                 LatencyFromCalculatedSniffOnset_ms_Med = stim_grouped_PR0(ti).LatencyFromCalculatedSniffOnset_ms_Med;
                        %                 stim_grouped_PR0(ti).LatencyFromCalculatedSniffOnset_ms = zeros(size(LatencyFromCalculatedSniffOnset_ms_Med));
                        %
                        %             end
                        %             % check with the method in Smear 2011
                        %             lightStimuliTimes = [obj.Light_Onsets;obj.Light_Onsets_Medial];
                        %             controlCycles = calculate_control_cycles(sniffonsets, lightStimuliTimes);
                        %             light_response = check_light_stim_response_Smear(spiketime, stim_grouped_PR0, controlCycles, option);
                        %             $$$$
                        %
                        %             check_light_onset_response_Smear(spiketime, eventtime, control_onsets);
                        %%
                        %% raster plot
                        for ji = 1:length(stim_grouped_PR0)
                            if mod(ji,2)
                                figure
                                subplot(211)
                                spiketime = obj.st;
                                eventtime = stim_grouped_PR0(ji).TrialOnset;
                                binSize = 0.002;
                                calcWindow = [0 0.15];
                                [binnedArray, bins] = timestampsToBinned(spiketime, eventtime, binSize, calcWindow);
                                [tr,b] = find(binnedArray);
                                [rasterX,yy] = rasterize(bins(b));
                                rasterY = yy+reshape([nan(size(tr'));tr';zeros(size(tr'))],1,length(tr)*3);
                                rasterX(rasterY==0) = [];rasterY(rasterY==0) = [];% remove zeros
                                plot(rasterX, rasterY,'.')
                                xlim(calcWindow)
                                ylim([0 length(eventtime)])
                                title('S-')
                                ylabel('trial')
                            else
                                subplot(212)
                                spiketime = obj.st;
                                eventtime = stim_grouped_PR0(ji).TrialOnset;
                                binSize = 0.002;
                                calcWindow = [0 0.15];
                                [binnedArray, bins] = timestampsToBinned(spiketime, eventtime, binSize, calcWindow);
                                [tr,b] = find(binnedArray);
                                [rasterX,yy] = rasterize(bins(b));
                                rasterY = yy+reshape([nan(size(tr'));tr';zeros(size(tr'))],1,length(tr)*3);
                                rasterX(rasterY==0) = [];rasterY(rasterY==0) = [];% remove zeros
                                plot(rasterX, rasterY,'.')
                                xlim(calcWindow)
                                ylim([0 length(eventtime)])
                                title('S+')
                                xlabel('time from inhal onset')
                                ylabel('trial')
                            end
                        end
        end




        function obj = untitled15(inputArg1,inputArg2)
            %UNTITLED15 Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end

        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end