function AddPathDtdFiles(filename,newXMLfilename,path2dtd)

path2dtd_str = sprintf('"%s"',path2dtd);

fid = fopen(filename,'r');
f = textscan(fid,'%s','Delimiter','\n');
f = f{:};
fclose(fid);

fout = fopen(newXMLfilename,'w');

for i = 1:length(f)
    k = strfind(f{i}, '"restecg.dtd"');
    if ~isempty(k)
        newline = strrep(f{i},'"restecg.dtd"',path2dtd_str);
        fprintf(fout,'%s\n',newline);
        break
    else
        fprintf(fout,'%s\n',f{i});
    end
end

fprintf(fout,'%s\n',f{i+1:end});

fclose(fout);

% fid = fopen(filename);
% fnew = fopen(newXMLfilename, 'w');
% 
% % look for line in xml file which contains specification of .dtd file and
% % in a new xml file add the path to dtd
% tline = fgetl(fid);
% while ischar(tline)
%     k = strfind(tline, '"restecg.dtd"');
%     if ~isempty(k)
%         newline = strrep(tline,'"restecg.dtd"',path2dtd_str);
%         fprintf(fnew,'%s\n',newline);
%     else
%         fprintf(fnew,'%s\n',tline);
%     end
%     
%     tline = fgetl(fid);
% end
% 
% fclose(fid);
% fclose(fnew);