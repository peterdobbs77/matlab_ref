function outmat = readFloat(infile,rows,cols)
% Matlab script to read in images from idl format.
% Parameters:
%	infile = name of datafile
%	rows  = number of rows in the image
%	cols  = number of columns in the image
% 8-2-98 GSTEVENS

fp = fopen(infile,'r');
[tmp,count] = fread(fp,'float32');
% Check file size
if count ~= (rows*cols)
    disp(count);
    disp(rows*cols);
  'Inconsistent datafile size; check parameters';
  %stop
end

outmat=zeros(rows,cols);
  for rCnt = 1:rows
    outmat(rCnt,:) = tmp((rCnt-1)*cols+1:rCnt*cols)';
  end

fclose(fp);
clear tmp