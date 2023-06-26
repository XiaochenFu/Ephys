function Intensity = DrivingCurrent_2_Intensity(DrivingCurrent, relationship)
if length(DrivingCurrent)>1
    [c,r] = size(DrivingCurrent);
    Intensity = zeros(c,r);
    for ccc = 1:c
        for rrr = 1:r
            Intensity(ccc,rrr) = DrivingCurrent_2_Intensity(DrivingCurrent(ccc,rrr), relationship);
        end
    end
end
switch relationship
    case 1 % Ephys setup, before Jan 2023, based on the recording on LightTest_220128_135024_000
        coefficients = polyfit([400, 700], [4.53 20.4], 1);
        % at 300mA, 0.03mW
        a1 = coefficients (1);
        b2 = coefficients (2);
        a2 = 0.03/300;
        I2P_low = @(x) a2*x; %mA to mW
        I2P_high = @(x) a1*x+b1;
        I2P = @(x) max(I2P_low(x),I2P_high(x));
        Intensity = I2P(DrivingCurrent);
    case 2 % Ephys setup, after Jan 2023, based on the recording on LightCalibration_230125_131318_1V10mW
        %         coefficients = polyfit([428.96, 714.4], [7.83, 29], 1);
        a1 = 0.0742;
        b1 = -23.9843;
        a2 = 0.03/285.7;
        I2P_low = @(x) a2*x; %mA to mW
        I2P_high = @(x) a1*x+b1;
        I2P = @(x) max(I2P_low(x),I2P_high(x));
        Intensity = I2P(DrivingCurrent);

end