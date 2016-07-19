% test for crash logic
% clc;clear all;close all;
% R =[10.7300;
%     5.3400;
%    60.3400];

% load('Environment.mat')

function logical = test_crash(handles,pos_array)
Zt = handles.Zt;
i = 1;
logical = 1;
while logical == 1 && i < size(pos_array,2)
    R = pos_array(:,i);
    [~,jx_f] = find(handles.X == floor(R(1)));
    [~,jx_c] = find(handles.X == ceil(R(1)));

    [iy_f,~] = find(handles.Y == floor(R(2)));
    [iy_c,~] = find(handles.Y == ceil(R(2)));

    [XX,YY] = meshgrid(floor(R(1)):ceil(R(1)),floor(R(2)):ceil(R(2)));

    VV = [Zt(iy_f(1),jx_f(1)),Zt(iy_c(1),jx_f(1));
           Zt(iy_f(1),jx_c(1)),Zt(iy_c(1),jx_c(1))];
    Xq = R(1);Yq = R(2);

    Vq  = interp2(XX,YY,VV,Xq,Yq);
    logical = Vq < R(3);
    i = i+1;
end


