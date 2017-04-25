%%
% takes a row from measurement matrix as input (decoded from XML) and returns a struct
function leadObject = GetLeadObjectFcn_v2(leadResult)

LeadID = leadResult{1}; LeadIDText = leadResult{2};
P_OnsetAmpl = leadResult{3};P_PeakAmpl = leadResult{4};
P_Duration = leadResult{5};P_Area = leadResult{6};
P_PeakTime= leadResult{7};PP_PeakAmpl = leadResult{8};
PP_Duration = leadResult{9};PP_Area = leadResult{10};
PP_PeakTime= leadResult{11};Q_PeakAmpl = leadResult{12};
Q_Duration = leadResult{13};Q_Area = leadResult{14};
Q_PeakTime= leadResult{15};R_PeakAmpl = leadResult{16};
R_Duration = leadResult{17};R_Area = leadResult{18};
R_PeakTime= leadResult{19};S_PeakAmpl = leadResult{20};
S_Duration = leadResult{21};S_Area = leadResult{22};
S_PeakTime= leadResult{23};RP_PeakAmpl = leadResult{24};
RP_Duration = leadResult{25};RP_Area = leadResult{26};
RP_PeakTime= leadResult{27};SP_PeakAmpl = leadResult{28};
SP_Duration = leadResult{29};SP_Area = leadResult{30};
SP_PeakTime= leadResult{31};STJ = leadResult{32};
STM = leadResult{33};STE = leadResult{34};
MaxST = leadResult{35};MinST = leadResult{36};
T_Special = leadResult{37};QRS_Balance = leadResult{38};
QRS_Deflection = leadResult{39};Max_R_Ampl = leadResult{40};
Max_S_Ampl = leadResult{41};T_PeakAmpl = leadResult{42};
T_Duration = leadResult{43};T_Area = leadResult{44};
T_PeakTime= leadResult{45};TP_PeakAmpl = leadResult{46};
TP_Duration = leadResult{47};TP_Area = leadResult{48};
TP_PeakTime= leadResult{49};T_End = leadResult{50};
PFull_Area  = leadResult{51}; QRS_Area = leadResult{52};
TFull_Area  = leadResult{53};QRSInt = leadResult{54};
BitFlag  = leadResult{55};


leadObject = struct('LeadID',LeadID,'LeadIDText',LeadIDText,'P_OnsetAmpl',P_OnsetAmpl,...
'P_PeakAmpl',P_PeakAmpl,'P_Duration',P_Duration,'P_Area',P_Area,'P_PeakTime',P_PeakTime,... 
'PP_PeakAmpl',PP_PeakAmpl,'PP_Duration',PP_Duration,'PP_Area',PP_Area,'PP_PeakTime',PP_PeakTime,...
'Q_PeakAmpl',Q_PeakAmpl,'Q_Duration',Q_Duration,'Q_Area',Q_Area,'Q_PeakTime',Q_PeakTime,...
'R_PeakAmpl',R_PeakAmpl,'R_Duration',R_Duration,'R_Area',R_Area,'R_PeakTime',R_PeakTime,...
'S_PeakAmpl',S_PeakAmpl,'S_Duration',S_Duration,'S_Area',S_Area,'S_PeakTime',S_PeakTime,...
'RP_PeakAmpl',RP_PeakAmpl,'RP_Duration',RP_Duration,'RP_Area',RP_Area,'RP_PeakTime',RP_PeakTime,...
'SP_PeakAmpl',SP_PeakAmpl,'SP_Duration',SP_Duration,'SP_Area',SP_Area,'SP_PeakTime',SP_PeakTime,...
'STJ',STJ,'STM',STM,'STE',STE,'MaxST',MaxST,'MinST',MinST,...
'T_Special',T_Special,'QRS_Balance',QRS_Balance,'QRS_Deflection',QRS_Deflection,...
'Max_R_Ampl',Max_R_Ampl,'Max_S_Ampl',Max_S_Ampl,...
'T_PeakAmpl',T_PeakAmpl,'T_Duration',T_Duration,'T_Area',T_Area,'T_PeakTime',T_PeakTime,...
'TP_PeakAmpl',TP_PeakAmpl,'TP_Duration',TP_Duration,'TP_Area',TP_Area,'TP_PeakTime',TP_PeakTime,...
'T_End',T_End,'PFull_Area',PFull_Area,'QRS_Area',QRS_Area,'TFull_Area',TFull_Area,...
'QRSInt',QRSInt,'BitFlag',BitFlag...
);