function PQ = paddedsize(AB, CD, PARAM)
if nargin == 1                      % nargin 입력함수의 갯수
    PQ = 2*AB;                      % [4096 4096]
elseif nargin == 2 && ~ischar(CD)   % CD가 문자열배열인지 확인
    PQ = AB + CD - 1;               % 한개가 겹치기 때문에
    PQ = 2 * ceil(PQ / 2);          % 가까운 정수로 올림.
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

        