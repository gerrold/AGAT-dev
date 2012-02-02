classdef INDIVIDUAL
    properties
        gene;       %   the gene the individual
        fitnes;     %   the fitnes value
        genid;      %   the generational id
        velocity;   %   the velocity of the particle (in usage of PSO)
    end
    methods
        function[obj]=INDIVIDUAL(gene)      %   constructor for an individual
            obj.gene=gene;
            obj.fitnes=inf;
        end
    end
end
            
        