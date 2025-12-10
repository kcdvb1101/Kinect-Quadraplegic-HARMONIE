s = what; %look in current directory
%s=what('dir') %change dir for your directory name 
matfiles=s.mat
for a=1:numel(matfiles)
    load(char(matfiles(a)))
    r = [label maxRadius minRadius]; 
    if a == 1
       A = [label maxRadius minRadius]; 
    else
       A = [r; A]; 
    end
end

labelvec = A(:,1);
MAX = A(:,2);
MIN = A(:,3);

h1 = gscatter(MAX,MIN,labelvec,'rbkg','ov^',[],'off');
set(h1,'LineWidth',2)
legend('Sphere','Cylinder','Rectangle','Other','Location','best')
hold on

X = [MAX,MIN];
cls = ClassificationDiscriminant.fit(X,labelvec);

Class1 = 1;
Class2 = 2;
K = cls.Coeffs(Class1,Class2).Const;
L = cls.Coeffs(Class1,Class2).Linear;
f = @(x,y) K + [x y]*L;

hold on;
q4 = ezplot(f, [min(X(:,1)) max(X(:,1)) min(X(:,2)) max(X(:,2))]);
set(q4, 'Color', 'k', 'LineWidth',2);


