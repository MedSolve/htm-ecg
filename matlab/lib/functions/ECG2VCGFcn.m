function VCG = ECG2VCGFcn(ECG)

% assumes ECG is a struct with fields: 
ecgDower = [ECG.I,ECG.II,ECG.V1,ECG.V2,ECG.V3,ECG.V4,ECG.V5,ECG.V6]';
 
% Inverse Dower matrix: VCG = Minv * ECG
%                       [X Y Z] = Minv * [I II V1 V2 V3 V4 V5 V6]'
%          I      II     V1     V2     V3     V4     V5     V6
invDower = [ 0.156 -0.010 -0.172 -0.074  0.122  0.231  0.239  0.194    % X
            -0.227  0.887  0.057 -0.019 -0.106 -0.022  0.041  0.048    % Y
            -0.022 -0.102  0.229  0.310  0.246  0.063 -0.055 -0.108 ]; % ZDower
        
% NOTE: According to Franck the VCG coordinates are:
%       X: left lateral direction
%       Y: inferior direction
%       Z: posterior direction

% According to the Dower matrix, the lower row represents the anterior
% direction, hence -Z relative to Franck.
% Transform the (inverse) Dower matrix to Franck's lead system, which is
% right-handed instead of the left-handed Dower system:
invDower(3,:) = - invDower(3,:);

%% estimate VCG using inverse Dower Transform
VCG = invDower*ecgDower;
VCG = VCG';