function modeloParzenWindow(numClases, X, Y, h)
    n = size(X,1);

    porcentaje = round(n*0.7);
    rng('default');
    ind = randperm(n);

    Xtrain = X(ind(1:porcentaje),:);
    Xtest = X(ind(porcentaje+1:end),:);
    Ytrain = Y(ind(1:porcentaje),:);
    Ytest = Y(ind(porcentaje+1:end),:);

    %%% Normalizaci�n %%%
    
    [Xtrain,mu,sigma]=zscore(Xtrain);
    Xtest=normalizar(Xtest,mu,sigma);
    
    %%%%%%%%%%%%%%%%%%%%%
    
    ind1=Ytrain==1;
    ind2=Ytrain==2;
    ind3=Ytrain==3;

    Xtrain1=Xtrain(ind1,:);
    Xtrain2=Xtrain(ind2,:);
    Xtrain3=Xtrain(ind3,:);

    funcion1=parzenWindow(Xtest,Xtrain1,Ytrain,h);
    funcion2=parzenWindow(Xtest,Xtrain2,Ytrain,h);
    funcion3=parzenWindow(Xtest,Xtrain3,Ytrain,h);

    funcion=[funcion1,funcion2,funcion3];

    [~,Yesti]=max(funcion,[],2);

    MatrizConfusion = zeros(numClases, numClases);
    for i=1:size(Xtest,1)
        MatrizConfusion(Yesti(i),Ytest(i))= MatrizConfusion(Yesti(i),Ytest(i))+1;
    end
    PrecisionClase=[];
    EficienciaClase=[];
    for i=1:size(MatrizConfusion,1)
        PresicionClase(i)=MatrizConfusion(i,i)/sum(MatrizConfusion(:,i));
        EficienciaClase(i)=MatrizConfusion(i,i)/sum(MatrizConfusion(i,:));
    end
    
    Eficiencia=(sum(Yesti==Ytest))/length(Ytest);
    Error=1-Eficiencia;
    ICE = std(EficienciaClase);
    ICP = std(PresicionClase);
    
    disp(strcat('La eficiencia en prueba es: ',{' '},num2str(Eficiencia)));
    disp(strcat('El error de clasificaci�n en prueba es: ',{' '},num2str(Error)));
    disp(MatrizConfusion);
    disp(strcat('La eficiencia por clase obtenida fue: ', num2str(EficienciaClase), ' +-', num2str(ICE)));
    disp(strcat('La precision por clase obtenida fue: ', num2str(PresicionClase), ' +-', num2str(ICP)));
end