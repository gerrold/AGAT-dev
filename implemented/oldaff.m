function[duplicity, aff_whole, aff_each] = AFFINITY(Pop, eps)
% population size
[popSize, strSize] = size(Pop);
% affinity matrix
affinity = zeros(popSize, popSize);
% search through whole population and count inter-individual affinity
    for i = 1:popSize
        for j = i+1:popSize
            % if euclidean distance between individuals' genes is less then
            % eps, genes are in affinity
            numGenes = 0;
            for k = 1:strSize
                if abs(Pop(i,k)- Pop(j,k)) <= eps
            numGenes = numGenes + 1;
                end
            end
% percentage of affinity between individual 'i' and 'j'
        affinity(i,j) = numGenes * (100 / strSize);
        end
    end
% duplicity
duplicity = 0;
% relative affinity of each individual
aff_each = zeros(popSize, 1);
    for i = 1:popSize
        % relative affinity of each individual
        aff_each(i) = sum(affinity(i,:)) + sum(affinity(:,i));
        % duplicity
        for j = i+1:popSize
            if affinity(i,j) >= 100;
                duplicity = duplicity + 1;
                break; % break 'for j'
            end
        end
    end
% relative affinity of each individual
aff_each = aff_each / popSize;
% relative affinity of whole population
aff_whole = sum(sum(affinity)) / (((popSize * popSize) - popSize)/2); 