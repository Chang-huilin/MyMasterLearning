% ����ż���е�����
evenRows = 2:2:size(mergedData, 1);

% �� mergedData ����ȡż����
evenRowsMatrix = mergedData(evenRows, :);%��������ѡ����ż���з����ʵ�ֵ����������25���̶��Ĺ���


%����

% ���������е�����
oddRows = 1:2:size(mergedData, 1);

% �� mergedData ����ȡ������
resultMatrix = mergedData(oddRows, :);


% ���� resultMatrix ��һ�����������еľ�����ά��Ϊ m x n

% ȥ��ǰ����
resultMatrixWithoutFirstFourColumns = resultMatrix(:, 5:end);
   
X = resultMatrixWithoutFirstFourColumns;

%�½�wavelength���ݣ�����һ��25������ֵ������������ɣ�����ΪWAVE
%����
WAVE = WAVE(:, 5:end);%��ȡ��ǰ4�У��ӵ�5�п�ʼ����

%��ͼ

plot(WAVE,X)

