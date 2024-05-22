function PQ = paddedsize(AB, CD, PARAM)
if nargin == 1                      % nargin �Է��Լ��� ����
    PQ = 2*AB;                      % [4096 4096]
elseif nargin == 2 && ~ischar(CD)   % CD�� ���ڿ��迭���� Ȯ��
    PQ = AB + CD - 1;               % �Ѱ��� ��ġ�� ������
    PQ = 2 * ceil(PQ / 2);          % ����� ������ �ø�.
elseif nargin == 2
    m = max(AB);
    P = 2^nextpow2(2*m);
    PQ = [P, P];
elseif nargin == 3
    m = max([AB CD]);
    P = 2^nextpow2(2*m);
    PQ = [P, P];
else
    error('Wrong number of inputs.')
end

        