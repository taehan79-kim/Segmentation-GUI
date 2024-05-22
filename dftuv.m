function [U, V] = dftuv(M, N)
%DFTUV Computes meshgrid frequency matrices.
%   [U, V] = DFTUV(M, N) computes meshgrid frequency matrices U and V. U
%   and V are useful for computing frequency-domain filter functions that
%   can be used with DFTFILT. U and V are both M-by-N.

u = 0:(M-1);
v = 0:(N-1);

idx = find(u>M/2);      % ������ �����ϴ� ��ȣ��(���� �����).
u(idx) = u(idx) - M;
idy = find(v>N/2);
v(idy) = v(idy) - N;

[V, U] = meshgrid(v, u);    % v*uũ���� ����� ����. v�� ���� �־� V�� ��ȯ, u�� ���� �־� U�� ��ȯ.