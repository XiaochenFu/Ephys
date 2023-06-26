function Odour = odour_name_from_voltage(voltage)
Odour = strings(size(voltage));
if length(voltage)>1
    Odour(i) = odour_name_from_voltage(voltage(i));
else
    v = round(voltage);
    switch v
        case 0
            Odour = "Acetophenone";
        case 1
            Odour = "EythylButyrate";
        case 2
            Odour = "EythylTiglate";
        case 3
            Odour = "MethylValerate";
        otherwise
            error("Voltage need to be 0, 1, 2, or 3")
    end

end