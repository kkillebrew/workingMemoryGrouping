function [output,fft_matrix] = FFT_Function(data,frequencies)
L = length(frequencies);

%     for i=1:Num_Conditions %we'll be looking at each level of the 3d array independently

%data is laid out as data x electrode but it needs to be electrode x data so
%we transpose it
data = data.';
fft_matrix = abs(fft(data)); %computing fast fourier transform on the data
%for each frequency we compare it to every entry in the matrix. If it is
%equivelant, then we store it in the ouput matrix in the same
%place as it appeared in the frequency matrix, overwriting a zero.

%dimensions of the 3d array
dimension = size(data);
%number of columns
r = dimension(2);
%number of rows
c = dimension(1);
%         %Code to analyze each row and each column at each
%         %condition and copy the entries into a matrix
%         for j = 1:r
%             for k = 1:c
%                 matrix(r,c) = data(r,c,i);
%             end
%         end

%we fill our output array
output = zeros([r L]);

counter = 0;
for m = frequencies
    counter = counter+1;
    output(:,counter) = fft_matrix(m+1,:).';
end
end

