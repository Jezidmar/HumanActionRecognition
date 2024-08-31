%Metoda lakata za određivanje optimalnog broja klastera
k=zeros(10);
for i=1:10
    k(i)=i*100;
end
sse = zeros(1,length(k));
for i = 1:length(k)
    [~, C, sumd] = kmeans(columnVectorA',k(i));
    sse(i) = sum(sumd);
end

figure;
plot(k,sse);
xlabel('Number of clusters');
ylabel('SSE');
