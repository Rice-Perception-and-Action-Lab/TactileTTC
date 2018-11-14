%----------------------------------------------
function out=cosineSquaredRamps(t_ms,ramp_ms,steadystate_ms)
%returns multiplicator for envelope
%relational operators perfom 'listwise': [1 2 3 4] < 3 = [1 1 1 0]. -> no if statements possible!
    out=    ( ...
            (t_ms<0)*0 + ...                                                    %t<0
            ((t_ms>=0).*(t_ms<ramp_ms)) .* (sin(t_ms.*pi/2/ramp_ms).^ 2)+ ...   %inramp
            ((t_ms>=ramp_ms).*(t_ms<(ramp_ms+steadystate_ms)))*1 + ...          %steady state
            ((t_ms>=(ramp_ms+steadystate_ms)).*(t_ms < (ramp_ms+steadystate_ms+ramp_ms))).*(cos((t_ms-(ramp_ms+steadystate_ms)).*pi/2/ramp_ms).^ 2) ... %outramp
            );
