% ���� X ��ѵ�����ݵ���������Y �Ƕ�Ӧ�ı�ǩ
% Xtest �Ǵ�Ԥ�����ݵ���������

% ���� k-NN ������������ k=3
k = 12;%������������
knnModel = fitcknn(X, Y, 'NumNeighbors', k);

% ʹ�÷���������Ԥ��
predictedLabels = predict(knnModel, Xtest);

% ��ʾԤ����
disp(predictedLabels);
