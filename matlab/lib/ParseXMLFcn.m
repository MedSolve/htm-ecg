% Parses XML files from MUSE into a struct containing:
% "TestInfo" (struct), Relevant information from Patient- and TestDemographics
% "MedianECG" (struct), 12 lead median signals
% "RhythmECG" (struct), 12 lead rhythm signals
% "MeasurementMatrix" (struct), Per lead measurements (based upon median
% signal)
% "Diagnosis Statement' (cell), Contains 12SL algorithm's auto encoded
% diagnosis statements
% "global" (cell), Contains Global measurements from beginning of
% Measurement matrix

% 
% Information about XML files can be found in "GE Healthcare Information
% Interchance Developer's Manual"331
% Information about 12sl algorithm can be found in "GE Healthcare Marquette
% 12SL ECG Analysis Program Physician's Guide"
%
% Script is written by Peter Lyngø Sørensen, questions to pls@hst.aau.dk
%
% requirements:
% "xml2struct_v2.m", "base64decode.m" and ".dtd"-files (not my function/files)
% "GetLeadObjectFcn_v2.m" and "ECG2StructFcn_v2.m" (my functions)

function XMLstruct = ParseXMLFcn(filename)

% in order to add the path of dtd files we create a new XML file where the
% path of dtd files is specified. Then it is possible to have the dtd files in a seperate
% folder. 

if isunix
    path2dtd = [pwd '/matlab/lib/necessary_files/dtd_files/restecg.dtd'];
    newXMLfilename = [pwd '/matlab/lib/necessary_files/tempXMLfile.XML'];
else
    path2dtd = [pwd '\matlab\lib\necessary_files\dtd_files\restecg.dtd'];
    newXMLfilename = [pwd '\matlab\lib\necessary_files\tempXMLfile.XML'];
end
% path is added to beginning of XML file "tempXML"
AddPathDtdFiles(filename,newXMLfilename,path2dtd)

% get filename, it is later added to struct
[~,filenameStr,~] = fileparts(filename) ;

% first use xml2struct function for generating a struct containing the xml
% data
[ s ] = xml2struct_v2(newXMLfilename);

try
    resting_ecg = s.RestingECG{2};
catch
    display(sprintf('Can not create struct from xml file in %s',filename)) 
    return
end

%% PATIENT DEMOGRAPHICS
% get relevant patient demographics
% I KPLL's gender variabel er 1 = female og 0 = male
try
    PatientDemographics = resting_ecg.PatientDemographics;

    % keep zeros in front of patientID    
    try
        PatientID = PatientDemographics.PatientID.Text;
    catch
        PatientID = 'N/A';
    end

    try
        PatientAge = str2double(PatientDemographics.PatientAge.Text);
    catch
        PatientAge = 'N/A';
    end

    try
        DateOfBirth = PatientDemographics.DateofBirth.Text;
        DateOfBirth = sprintf('%s-%s-%s',DateOfBirth(end-3:end),DateOfBirth(1:2),DateOfBirth(4:5));
    catch
        DateOfBirth = 'N/A';
    end

    try
        Gender = PatientDemographics.Gender.Text;
    catch
        Gender = 'N/A';
    end

    % Variables below might be included later on, as of 2015-11-03 they are
    % not included in final xml struct
    try
        Race = PatientDemographics.Race.Text;
    catch
        Race = 'N/A';
    end

    try
        HeightCM = str2double(PatientDemographics.HeightCM.Text);
    catch
        HeightCM = 'N/A';
    end

    try
        WeightKG = str2double(PatientDemographics.WeightKG.Text);
    catch
        WeightKG = 'N/A';
    end

    try
        PatientFirstName = PatientDemographics.PatientFirstName.Text;
    catch
        PatientFirstName = 'N/A';
    end
    
    try
        PatientLastName = PatientDemographics.PatientLastName.Text;
    catch
        PatientLastName = 'N/A';
    end
    
    try
        PatientAddress1 = PatientDemographics.PatientAddress1.Text;
    catch
        PatientAddress1 =  'N/A';
    end
    
    try
        PatientAddress2 = PatientDemographics.PatientAddress2.Text;
    catch
        PatientAddress2 =  'N/A';
    end
    
    try
        PatientAddress3 = PatientDemographics.PatientAddress3.Text;
    catch
        PatientAddress3 =  'N/A';
    end
    
    try
        PatientCity = PatientDemographics.PatientCity.Text;
    catch
        PatientCity =  'N/A';
    end
    
    try
        PatientState = PatientDemographics.PatientState.Text;
    catch
        PatientState =  'N/A';
    end
    
    try
        PatientCountry = PatientDemographics.PatientCountry.Text;
    catch
        PatientCountry =  'N/A';
    end
    
    try
        PatientZipCode = PatientDemographics.PatientZipCode.Text;
    catch
        PatientZipCode =  'N/A';
    end
    
catch

    PatientID = 'N/A';PatientAge = 'N/A';DateOfBirth = 'N/A';Gender = 'N/A';
    Race = 'N/A';HeightCM = 'N/A'; WeightKG = 'N/A';PatientFirstName = 'N/A';
    PatientLastName = 'N/A';PatientAddress1 = 'N/A';PatientAddress2 = 'N/A';
    PatientAddress3 = 'N/A';PatientCity = 'N/A';PatientState = 'N/A';
    PatientCountry = 'N/A';PatientZipCode = 'N/A';
    display('Can not find PatientDemographics in xml file')
end

    
%% GET RELEVANT TEST DEMOGRAPHICS

try
    test_demo = resting_ecg.TestDemographics;

    try
        acqDate = test_demo.AcquisitionDate.Text;
    catch
        acqDate = '';
    end

    try
        acqTime = test_demo.AcquisitionTime.Text;
    catch
        acqTime = '';
    end

    acqDateTime = sprintf('%s-%s-%s %s',acqDate(end-3:end),acqDate(1:2),...
        acqDate(4:5),acqTime);

    % Variables below might be included later on, as of 2015-11-03 they are
    % not included in final xml struct
    try
        AcquisitionDevice = test_demo.AcquisitionDevice.Text;
    catch
        AcquisitionDevice = 'N/A';
    end
    
    try
        Location = test_demo.Location.Text;
    catch
        Location = 'N/A';
    end
    
    try
        LocationName = test_demo.LocationName.Text;
    catch
        LocationName = 'N/A';
    end
    
    try
        TestType = test_demo.TestType.Text;
    catch
        TestType = 'N/A';
    end
    
    try
        TestReason = test_demo.TestReason.Text;
    catch
        TestReason = 'N/A';
    end
    
    try
        DataType = test_demo.DataType.Text;
    catch
        DataType = 'N/A';
    end
    
    try
        Site = test_demo.Site.Text;
    catch
        Site = 'N/A';
    end
    
    try
        AnalysisSoftwareVersion = test_demo.AnalysisSoftwareVersion.Text;
    catch
        AnalysisSoftwareVersion = 'N/A';
    end
    
    try
        AcquisitionSoftwareVersion = test_demo.AcquisitionSoftwareVersion.Text;
    catch
        AcquisitionSoftwareVersion = 'N/A';
    end
    
    try
        XMLSourceVersion = test_demo.XMLSourceVersion.Text;
    catch
        XMLSourceVersion = 'N/A';
    end
    
catch

    acqDate = '';
    acqTime = '';
    acqDateTime = 'N/A';AcquisitionDevice= 'N/A';AnalysisSoftwareVersion = 'N/A';
    AcquisitionSoftwareVersion = 'N/A';Site = 'N/A';DataType = 'N/A';TestReason = 'N/A';
    TestType = 'N/A';LocationName = 'N/A';Location = 'N/A';XMLSourceVersion = 'N/A';
    display('Can not find TestDemographics in xml file')
end
%% Order

% Variables below might be included later on, as of 2015-11-03 they are
% not included in final xml struct
try
    order = resting_ecg.Order;

    try
        RequisitionNumber = order.RequisitionNumber.Text;
    catch
        RequisitionNumber = 'N/A';
    end

    try
        HISOrderNumber = order.HISOrderNumber.Text;
    catch
        HISOrderNumber = 'N/A';
    end

    try
        HISAccountNumber = order.HISAccountNumber.Text;
    catch
        HISAccountNumber = 'N/A';
    end
    
    try
        HISTestType = order.HISTestType.Text;
    catch
        HISTestType = 'N/A';
    end
    
    try
        OrderTime = order.OrderTime.Text;
    catch
        OrderTime = 'N/A';
    end
    
    try
        AdmitTime = order.AdmitTime.Text;
    catch
        AdmitTime = 'N/A';
    end
    
    try
        AdmitDate = order.AdmitDate.Text;
    catch
        AdmitDate = 'N/A';
    end
    
    try
        HISLocation = order.HISLocation.Text;
    catch
        HISLocation = 'N/A';
    end
    
    try
        ReferringMDHISID = order.ReferringMDHISID.Text;
    catch
        ReferringMDHISID = 'N/A';
    end
    try
        comments = order.comments.Text;
    catch
        comments = 'N/A';
    end
    try
        ReasonForTest = order.ReasonForTest.Text;
    catch
        ReasonForTest = 'N/A';
    end
    
catch
    RequisitionNumber = 'N/A';ReasonForTest = 'N/A';comments = 'N/A';
    ReferringMDHISID = 'N/A';HISLocation = 'N/A';AdmitDate = 'N/A';AdmitTime = 'N/A';
    OrderTime = 'N/A';HISTestType = 'N/A';HISAccountNumber = 'N/A';HISOrderNumber = 'N/A';
    
    %display('Can not find <Order> in xml file')
end

%% REST ECG MEASUREMENTS
% Get relevant ecg measurements

% Get RestingECGMEausrements if available, appears to fit with
% signal in regards to Qonset and qoffset
try
    rest_ECG_measurements = resting_ecg.RestingECGMeasurements;

    try
        VentricularRate = str2double(rest_ECG_measurements.VentricularRate.Text);
    catch
        VentricularRate = 'N/A';
    end

    try
        AtrialRate = str2double(rest_ECG_measurements.AtrialRate.Text);
    catch
        AtrialRate = 'N/A';
    end

    try
        PRInterval = str2double(rest_ECG_measurements.PRInterval.Text);
    catch
        PRInterval = 'N/A';
    end

    try
        QRSDuration = str2double(rest_ECG_measurements.QRSDuration.Text);
    catch
        QRSDuration = 'N/A';
    end

    try
        QTInterval = str2double(rest_ECG_measurements.QTInterval.Text);
    catch
        QTInterval = 'N/A';
    end

    try
        QTCorrected = str2double(rest_ECG_measurements.QTCorrected.Text);
    catch
        QTCorrected = 'N/A';
    end

    try
        PAxis = str2double(rest_ECG_measurements.PAxis.Text);
    catch
        PAxis = 'N/A';
    end

    try
        RAxis = str2double(rest_ECG_measurements.RAxis.Text);
    catch
        RAxis = 'N/A';
    end

    try
        TAxis = str2double(rest_ECG_measurements.TAxis.Text);
    catch
        TAxis = 'N/A';
    end

    try
        QRSCount = str2double(rest_ECG_measurements.QRSCount.Text);
    catch
        QRSCount = 'N/A';
    end

    try
        QOnset = str2double(rest_ECG_measurements.QOnset.Text);
    catch
        QOnset = 'N/A';
    end

    try
        QOffset = str2double(rest_ECG_measurements.QOffset.Text);
    catch
        QOffset = 'N/A';
    end

    try
        POnset = str2double(rest_ECG_measurements.POnset.Text);
    catch
        POnset = 'N/A';
    end

    try
        POffset = str2double(rest_ECG_measurements.POffset.Text);
    catch
        POffset = 'N/A';
    end

    try
        TOffset = str2double(rest_ECG_measurements.TOffset.Text);
    catch
        TOffset = 'N/A';
    end

    try
        QTcFrederica = str2double(rest_ECG_measurements.QTcFrederica.Text);
    catch
        QTcFrederica = 'N/A';
    end

    try
        ECGSampleBase = str2double(rest_ECG_measurements.ECGSampleBase.Text);
    catch
        ECGSampleBase = 'N/A';
    end

    try
        ECGSampleExponent = str2double(rest_ECG_measurements.ECGSampleExponent.Text);
    catch
        ECGSampleExponent = 'N/A';
    end
catch
    ECGSampleExponent = 'N/A';ECGSampleBase = 'N/A';QTcFrederica = 'N/A';
    TOffset = 'N/A';POffset = 'N/A';POnset = 'N/A';QOffset = 'N/A';QOnset = 'N/A';
    QRSCount = 'N/A';TAxis = 'N/A';RAxis = 'N/A';PAxis = 'N/A';QTCorrected = 'N/A';
    QTInterval = 'N/A';QRSDuration = 'N/A';PRInterval = 'N/A';AtrialRate = 'N/A';
    VentricularRate = 'N/A';
end


%% testinfo to be saved to excel

TestInfoStruct = struct('Filename',filenameStr,'PatientID',PatientID,'AcqDateTime',acqDateTime,'PatientAge',PatientAge,...
    'DateOfBirth',DateOfBirth,'Gender',Gender,...
    'VentricularRate',VentricularRate, 'AtrialRate',AtrialRate, 'PRInterval',PRInterval,...
    'QRSDuration', QRSDuration, 'QTInterval',QTInterval,'QTCorrected',QTCorrected,...
    'PAxis',PAxis,'RAxis',RAxis,'TAxis',TAxis,'QRSCount',QRSCount,'QOnset',QOnset,...
    'QOffset',QOffset,'POnset',POnset,'POffset',POffset,'TOffset',TOffset,'QTcFrederica',QTcFrederica,...
    'Race',Race,'HeightCM',HeightCM,'WeightKG',WeightKG,'PatientFirstName',PatientFirstName,...
    'PatientLastName',PatientLastName,'PatientAddress1',PatientAddress1,'PatientAddress2',PatientAddress2,...
    'PatientAddress3',PatientAddress3,'PatientCity',PatientCity,'PatientState',PatientState,...
    'PatientCountry',PatientCountry,'PatientZipCode',PatientZipCode,'AcquisitionDevice',AcquisitionDevice,...
    'Location',Location,'LocationName',LocationName,'TestType',TestType,...
    'TestReason',TestReason,'DataType',DataType,'Site',Site,'AnalysisSoftwareVersion',AnalysisSoftwareVersion,...
    'XMLSourceVersion',XMLSourceVersion,'ECGSampleBase',ECGSampleBase,'ECGSampleExponent',ECGSampleExponent);

%% GET DIAGNOSIS STATEMENTS

temp = resting_ecg.Diagnosis.DiagnosisStatement;
DiagnosisStatement = cell(size(temp,1),2);
tempStr = '';
c = 0;
for i = 1:size(temp,2)
    
    try
        
        tempStr = [tempStr,' ',temp{i}.StmtText.Text];
        for j = 1:length(temp{i}.StmtFlag)
          
            if strcmp('ENDSLINE',temp{i}.StmtFlag{j}.Text)
                c = c+1;
                DiagnosisStatement{c,1} =  c;
                DiagnosisStatement{c,2} =  tempStr;
                tempStr = '';
            end
           
        end
           
    catch
       
    end
end

%% GET MEDIAN LEADS

try

    waveforms = resting_ecg.Waveform;

    for i = 1:length(waveforms) 

        % waveform type can be either Median or Rhytm
        waveformtype = waveforms{i}.WaveformType.Text;

        switch waveformtype

            case 'Median'

                % get all median lead data
                LeadData = waveforms{i}.LeadData;
                % number of recorded leads
                nLeads = length(LeadData);
                % number of samples in median ecg
                nSamples = str2double(LeadData{1}.LeadSampleCountTotal.Text);

                % allocate space
                LeadID = cell(1,nLeads);
                MedianECG = zeros(nSamples,nLeads);

                for k = 1:nLeads

                    % Get lead ID
                    LeadID{k} = LeadData{k}.LeadID.Text;
                    % Get adjustment factor for amplitude correction, i.e.
                    % number of micro volts pr bit. 
                    LeadAmplitudeUnitsPerBit = str2double(regexprep(LeadData{k}.LeadAmplitudeUnitsPerBit.Text,',','.'));
                    % Get data for current lead and decode from base64
                    % encryption
                    WaveFormDataTemp = typecast(base64decode(LeadData{k}.WaveFormData.Text),'int16');
                    % Correct measurements with amplitude correction
                    WaveFormData = WaveFormDataTemp.*LeadAmplitudeUnitsPerBit;

                    % save current ECG lead in format (I, II, V1-V6)
                    if strcmpi('I',LeadID{k})
                        MedianECG(:,1) = WaveFormData';
                    elseif strcmpi('II',LeadID{k})
                        MedianECG(:,2) = WaveFormData';
                    elseif strcmpi('V1',LeadID{k})
                        MedianECG(:,3) = WaveFormData';
                    elseif strcmpi('V2',LeadID{k})
                        MedianECG(:,4) = WaveFormData';
                    elseif strcmpi('V3',LeadID{k})
                        MedianECG(:,5) = WaveFormData';
                    elseif strcmpi('V4',LeadID{k})
                        MedianECG(:,6) = WaveFormData';
                    elseif strcmpi('V5',LeadID{k})
                        MedianECG(:,7) = WaveFormData';
                    elseif strcmpi('V6',LeadID{k})
                        MedianECG(:,8) = WaveFormData';
                    end

                end

            case 'Rhythm'
                
                % get all Rhythm lead data
                LeadData = waveforms{i}.LeadData;
                % number of recorded leads
                nLeads = length(LeadData);
                % number of samples in Rhythm ecg
                nSamples = str2double(LeadData{1}.LeadSampleCountTotal.Text);

                % allocate space
                LeadID = cell(1,nLeads);
                RhythmECG = zeros(nSamples,nLeads);

                for k = 1:nLeads

                    % Get lead ID
                    LeadID{k} = LeadData{k}.LeadID.Text;
                    % Get adjustment factor for amplitude correction, i.e.
                    % number of micro volts pr bit. 
                    LeadAmplitudeUnitsPerBit = str2double(regexprep(LeadData{k}.LeadAmplitudeUnitsPerBit.Text,',','.'));
                    % Get data for current lead and decode from base64
                    % encryption
                    WaveFormDataTemp = typecast(base64decode(LeadData{k}.WaveFormData.Text),'int16');
                    % Correct measurements with amplitude correction
                    WaveFormData = WaveFormDataTemp.*LeadAmplitudeUnitsPerBit;

                    % save current ECG lead in format (I, II, V1-V6)
                    if strcmpi('I',LeadID{k})
                        RhythmECG(:,1) = WaveFormData';
                    elseif strcmpi('II',LeadID{k})
                        RhythmECG(:,2) = WaveFormData';
                    elseif strcmpi('V1',LeadID{k})
                        RhythmECG(:,3) = WaveFormData';
                    elseif strcmpi('V2',LeadID{k})
                        RhythmECG(:,4) = WaveFormData';
                    elseif strcmpi('V3',LeadID{k})
                        RhythmECG(:,5) = WaveFormData';
                    elseif strcmpi('V4',LeadID{k})
                        RhythmECG(:,6) = WaveFormData';
                    elseif strcmpi('V5',LeadID{k})
                        RhythmECG(:,7) = WaveFormData';
                    elseif strcmpi('V6',LeadID{k})
                        RhythmECG(:,8) = WaveFormData';
                    end

                end
        end

    end

catch

    display('Could not find Median and Rhythm Lead data')
    MedianECG = zeros(600,8);
    RhythmECG = zeros(5000,8);
end

%% derive last 4 leads from 8 leads

% III = II - I;
Median_III = MedianECG(:,2)-MedianECG(:,1);
% aVR = - .5 * (I + II);
Median_aVR = -0.5*(MedianECG(:,2)+MedianECG(:,1));
% aVL = I - .5*II
Median_aVL = MedianECG(:,1) - .5*MedianECG(:,2);
% aVF = II - .5*I
Median_aVF = MedianECG(:,2) - .5*MedianECG(:,1);

% III = II - I;
Rhythm_III = RhythmECG(:,2)-RhythmECG(:,1);
% aVR = - .5 * (I + II);
Rhythm_aVR = -0.5*(RhythmECG(:,2)+RhythmECG(:,1));
% aVL = I - .5*II
Rhythm_aVL = RhythmECG(:,1) - .5*RhythmECG(:,2);
% aVF = II - .5*I
Rhythm_aVF = RhythmECG(:,2) - .5*RhythmECG(:,1);

%% Create ECG structs for easy access 
MedianECG_temp = [MedianECG(:,1:2) Median_III Median_aVR Median_aVL Median_aVF MedianECG(:,3:8)];
MedianECGStruct = ECG2StructFcn_v2(MedianECG_temp);

RhythmECG_temp = [RhythmECG(:,1:2) Rhythm_III Rhythm_aVR Rhythm_aVL Rhythm_aVF RhythmECG(:,3:8)];
RhythmECGStruct = ECG2StructFcn_v2(RhythmECG_temp);

%% create VCG from ECG

MedianVCG = ECG2VCGFcn(MedianECGStruct);
RhythmVCG = ECG2VCGFcn(RhythmECGStruct);

%% get QRSArea

%% Decode Measurement Matrix

measurement_matrix_cell = cell(13,55);

try
    meas_matrix_text = base64decode(resting_ecg.MeasurementMatrix.Text);

    %  first part of text is Global Measurements, see page 59 in GE
    %  Information Interexchange XML
    headers = meas_matrix_text(1:36);
    b = 0;
    global_temp_bytes =repmat(uint8(0),18,2);
    global_temp =repmat(int16(0),18,1);
    for k =  1:2:length(headers);
        b=b+1;
        global_temp_bytes(b,1:2) = headers(k:k+1)';
        global_temp(b,1) = typecast(global_temp_bytes(b,:),'int16');
    end

    global_measurements = {'36', 'pon', 'poff', 'qon', 'qoff', 'ton', 'toff',...
        'nqrs', 'qrsdur', 'qt', 'qtc', 'print', 'vrate', 'avgrr', 'pad',...
        'pad', 'pad', '636'};

    global_measurements(2,:) = num2cell(global_temp');
    % pattern in measurement matrix from value 37 and forward is:
    % "LeadID ColumnNR uint8_value uint8_value"
    pattern_vector = meas_matrix_text(37:end);
    % length of the entire pattern
    pattern_length = length(pattern_vector);
    % Length of each lead pattern is 212, as pattern is "LeadID ColumnNR uint8_value uint8_value"
    % There exists values for 212/4 = 53 variables.
    lead_pattern_length = pattern_length/12;
    values = zeros(12,53);

    % Format and order of variables in ECGMeasurementMatrix, see GE
    % Information Interchange Developer's Manual
    column_names = {'P_OnsetAmpl','P_PeakAmpl','P_Duration','P_Area','P_PeakTime',...
        'PP_PeakAmpl','PP_Duration','PP_Area','PP_PeakTime','Q_PeakAmpl',...
        'Q_Duration','Q_Area','Q_PeakTime','R_PeakAmpl','R_Duration','R_Area',...
        'R_PeakTime','S_PeakAmpl','S_Duration','S_Area','S_PeakTime','RP_PeakAmpl',...
        'RP_Duration','RP_Area','RP_PeakTime','SP_PeakAmpl','SP_Duration','SP_Area',...
        'SP_PeakTime','STJ','STM','STE','MaxST','MinST','T_Special','QRS_Balance',...
        'QRS_Deflection','Max_R_Ampl','Max_S_Ampl','T_PeakAmpl','T_Duration',...
        'T_Area','T_PeakTime','TP_PeakAmpl','TP_Duration','TP_Area','TP_PeakTime',...
        'T_End','PFull_Area','QRS_Area','TFull_Area','QRSint','BitFlag'};

    % Loop through each of the 12 lead patterns,  
    % Pattern is "LeadID ColumnNR uint8_value uint8_value", hence last two
    % entries in pattern are typecast to int16 value, which represent the value
    % of the given variable

    % From GE INFORMATION INTERCHANGE XML page 60: These
    % measurements consist of an array 12 leads by 53 four-byte values. The four bytes
    % are further subdivided into three parts. The first byte the lead ID, the second byte is
    % measurement ID, and the remaining two bytes are the actual measurement value.
    leadnr = 0;
    for i = 1:lead_pattern_length:pattern_length

        leadnr = leadnr + 1;
        % get lead pattern for a given lead
        lead_pattern = pattern_vector(i:i+lead_pattern_length-1);
        temp = zeros(lead_pattern_length/4,4,'uint8');
        k = 0;

        % increments of 4 as pattern is "LeadID ColumnNR uint8_value uint8_value"
        for j = 1:4:lead_pattern_length

            k = k+1;
            temp(k,1:4) = lead_pattern(j:j+3);
            values(leadnr,k) = typecast(temp(k,3:4),'int16');

        end
    end

    leadID = [0:1:11]';
    leadIDText = {'I','II','V1','V2','V3','V4','V5','V6','III','aVR','aVL','aVF'};

    measurement_matrix_cell(1,3:end) = column_names; 
    measurement_matrix_cell(1,1:2) = {'LeadID','LeadIDText'};
    measurement_matrix_cell(2:13,1) = num2cell(leadID);
    measurement_matrix_cell(2:13,2) = leadIDText;
    measurement_matrix_cell(2:13,3:end) = num2cell(values);

    I = GetLeadObjectFcn_v2(measurement_matrix_cell(2,:));II = GetLeadObjectFcn_v2(measurement_matrix_cell(3,:));
    V1 = GetLeadObjectFcn_v2(measurement_matrix_cell(4,:));V2 = GetLeadObjectFcn_v2(measurement_matrix_cell(5,:));
    V3 = GetLeadObjectFcn_v2(measurement_matrix_cell(6,:));V4 = GetLeadObjectFcn_v2(measurement_matrix_cell(7,:));
    V5 = GetLeadObjectFcn_v2(measurement_matrix_cell(8,:));V6 = GetLeadObjectFcn_v2(measurement_matrix_cell(9,:));
    III = GetLeadObjectFcn_v2(measurement_matrix_cell(10,:));aVR = GetLeadObjectFcn_v2(measurement_matrix_cell(11,:));
    aVL = GetLeadObjectFcn_v2(measurement_matrix_cell(12,:));aVF = GetLeadObjectFcn_v2(measurement_matrix_cell(13,:));
    
    MeasurementMatrixStruct = struct('AllLeads',{measurement_matrix_cell},...
        'I',I,'II',II,...
        'III',III,'aVR',aVR,'aVL',aVL,'aVF',aVF,...
        'V1', V1,'V2',V2,'V3',V3,'V4',V4,'V5',V5,'V6',V6...
        );
    
catch
    display('Could not decode Measurement Matrix, check if it exist in xml-file under <MeasurementMatrix>') 

end

%% Create XMLstruct containing relevant information from XML file

XMLstruct = struct('TestInfo',TestInfoStruct,'MedianECG',MedianECGStruct,...
    'RhythmECG',RhythmECGStruct,'MeasurementMatrix',MeasurementMatrixStruct,...
    'MedianVCG',MedianVCG,'RhythmVCG',RhythmVCG,'DiagnosisStatement',{DiagnosisStatement},'global',{global_measurements});
