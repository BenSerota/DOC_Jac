function y = myFcn(u)
h = createButton;
pause(0.01); % To create the button.
fprintf('press F5 to continue running code')

% This is your really long operating function/software, which you want to
% stop and view every now and then.
y = 0;
while y < 100000
    y = y+u;
    pause(1e-5);
end

close(h);