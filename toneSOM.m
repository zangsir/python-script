l = 30; %how many steps per tone 

%read in csv file
raw = importdata('Meng.csv',',');

%loop through lines
x = [];
dx = [];
base = raw.data(1);
tmp = [];
for i = 1:length(raw.data),
    oldbase = base;
    base = raw.data(i);
    if base == oldbase,
        tmp = [tmp;str2double(raw.textdata{i+1,2})];
    else
        if length(tmp) > 1,
            %resample tmp
            xi = linspace(1,length(tmp),l);
            tmp = interp1(1:length(tmp),tmp,xi,'cubic');
            %plot(tmp);
            %hold on;
            %convert to bark
            tmp = 7*log(tmp/650+sqrt(1+(tmp/650).^2));
            %get dx
            dtmp = .5*diff(tmp);
            plot(dtmp);
            hold on;
            %concatenate
            x = [x tmp'];
            dx = [dx dtmp'];
            %reset
            tmp = [];
        end;
    end;   
end;
%last tone
if length(tmp) > 1,
    %resample tmp
    xi = linspace(1,length(tmp),l);
    tmp = interp1(1:length(tmp),tmp,xi,'cubic');
    %convert to bark
    tmp = 7*log(tmp/650+sqrt(1+(tmp/650).^2));
    %get dx
    dtmp = .5*diff(tmp);
    %concatenate
    x = [x tmp'];
    dx = [dx dtmp'];
end;




%train an SOM for f0
%net = selforgmap([10 10]);
%net = train(net,x);

%train an SOM for D1
dnet = selforgmap([10 10]);
dnet = train(dnet,dx);

