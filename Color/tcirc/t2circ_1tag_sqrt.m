function [m_z1 critical_range_zero_center p] = t2circ_1tag_sqrt(z1,alpha,freq_tag)
% T^2_circ statistic based on Victor & Mast (1991)

% check inputs
if nargin<2
    alpha = 0.95;
end
if alpha<0 || alpha>1 
    error('alpha must be between 0 and 1');
end
if nargin<1
    error('You must provide some data');
end
if isempty(z1)
    z1 = 0;
end
if ~(isnumeric(z1))
    error('Inputs must be numbers');
end


% determine number of samples
M1 = size(z1,1);

% compute means
m_z1 = mean(z1);


% compute variance
for i = 1:M1;
freq_difference(i,:)= abs(z1(i,:)-m_z1).^2;
end
freq_difference_sum = sum(freq_difference);
v_indiv = 1/(2*(M1 -1)) * freq_difference_sum;
v_group =  (abs(m_z1).^2)*M1/2;

% compute the tcirc-statistic
 t2_circ = (v_group./v_indiv)/M1;
% t2_circ = (M1-1)*(abs(m_z1).^2)./freq_difference_sum;
% perform an F-test/Compute Confidence interval
f_crit = finv(1-alpha,2,2*M1-2);

criterion = sqrt((f_crit/M1) * 2*v_indiv);
p = fpdf(M1*t2_circ,2,2*M1- 2);
disp(p(freq_tag+1))

ang = 1:360;
    for ii = 1:1000
        critical_range_zero_center(ii,:) = criterion(ii)*(cos(2*pi*ang/360)+sqrt(-1)*sin(2*pi*ang/360));
end


