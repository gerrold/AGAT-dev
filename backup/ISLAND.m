classdef ISLAND
    properties
        population;     %   population on the island
        blocfit;        %   best local fitnes
        stats;          %   current statistical data
        trail;          %   loged statistical data
        trends;         %   saved trends???
        fitfunc;        %   the function what is used to evaluate fitnes
        
        space;          %   space vector to restrict the searching interval
        popsize;        %   the size of the population default?
        control;        %   the algorithm for the panmictic evolution a.k.a. local policy
        evaltime;       %   the number of evaluates of fitnes function
        
        inMig;          %   the individuals requesting to leave the island
        outMig;         %   the individuals requesting to land in the island
        
        eps;
    end
    methods
        function[obj]=ISLAND(varargin)    %   constructor for the island needs a setup
%             obj.population=population;
%             obj.fitfunc = fitfunc;
            if size(varargin,2) > 0
                  obj =  obj.set(obj,varargin{2:nargin-1});
            end
            
            obj = obj.set(obj,'space','homo',-500, 500, 10);
            obj = obj.set(obj,'size',10);                       %   default values
            obj = obj.set(obj,'eps',abs(obj.space(1,:)-obj.space(2,:)) * 0.005);
            obj.evaltime = 0;
            
        end
        
        function[obj]=trail_update(obj)     %   appends the statistical log data 
            obj = obj.stats_update();
            obj.trail(:,size(obj.trail,2)+1)=obj.stats';
        end
        
        function[obj]=stats_update(obj)     %   updates the statistical data of the island
            tmp=obj.extract('fitnes');
            obj.stats = [mean(tmp) max(tmp) min(tmp) median(tmp) mode(tmp) std(tmp) var(tmp) cov(tmp) affinity(obj) obj.evaltime size(obj.population,2) adist(obj)];
        
            function[ad]=adist(obj)
                 tmp=obj.extract('genes');
%                  ad = sum(sum(dist(tmp)))/(size(dist,1)*size(dist,2) - size(dist,1));
                    ad = 0;     % this is not working for now... need to debug
            end
            
            function[aff]=affinity(obj) %   calculates the affinity of the genes... TODO!!!
                if size(obj.eps,2) ~= 0
                    tmp=obj.extract('genes');
                    [x y]=size(tmp);
                    edist = dist(tmp);  %   calculating eucledian distance matrix
                    epsm = zeros(size(edist));
                    for i=1:size(epsm,2)
                        epsm(:,i) = obj.eps(i);
                    end
                    edist = floor((edist - epsm)/max(max(obj.space))).*-1;  %   these are similar to each other
                    %   TODO
                else
                    aff=0;  % not calculating, its heavy
                end
                
                aff = 0; %  remove if finished :)
                
            end;
        end;
        
        %   an average distance would be lovely :)
        
        function[obj]=update(obj)   %   updates the data of the island
%             for c=1:size(obj.population)
              obj=obj.fitit();
            obj = obj.trail_update();
        end
        
        function[obj]=fitit(obj)    %   evaluates the fitnes for the island ??? does it work?
%             if(obj.population(1:size(obj.population)).fitnes == inf)
%                obj.population(1:size(obj.population)).fitnes = eval([obj.fitfunc '(obj.population(c).gene);']);
%             end;
            for c = 1:size(obj.population,2)
                eval(['fh = @' obj.fitfunc ';']);
                if(obj.population(c).fitnes == inf)
                    obj.population(c).fitnes = fh(obj.population(c).gene);
%                    obj.population(c).fitnes = eval([obj.fitfunc '(obj.population(c).gene);']);
                   obj.evaltime = obj.evaltime+1;
                end;
            end
        end;
        
        function[stat]=gettrail(varargin)    %   builds a matrix from the requested statistical data
            obj = varargin{1}
             for c=2:nargin
                switch varargin{c}
                    case 'mean'
                        stat(:,c-1)=obj.trail(1,:);
                    case 'max'
                        stat(:,c-1)=obj.trail(2,:);
                    case 'min'
                        stat(:,c-1)=obj.trail(3,:);
                    case 'median'
                        stat(:,c-1)=obj.trail(4,:);
                    case 'mode'
                        stat(:,c-1)=obj.trail(5,:);
                    case 'std'
                        stat(:,c-1)=obj.trail(6,:);
                    case 'var'
                        stat(:,c-1)=obj.trail(7,:);    
                    case 'cov'
                        stat(:,c-1)=obj.trail(8,:);
                    case 'affinity'
                        stat(:,c-1)=obj.trail(9,:);
                    case 'evaltime'
                        stat(:,c-1)=obj.trail(10,:);
                    case 'size'
                        stat(:,c-1)=obj.trail(11,:);
                end;
             end;
        end;
        
        function[stat]=getstats(request)    %   returns the requested statistical data
            switch request
                case 'mean'
                    stat=obj.stats(1);
                case 'max'
                    stat=obj.stats(2);
                case 'min'
                    stat=obj.stats(3);
                case 'median'
                    stat=obj.stats(4);
                case 'mode'
                    stat=obj.stats(5);
                case 'std'
                    stat=obj.stats(6);
                case 'var'
                    stat=obj.stats(7);    
                case 'cov'
                    stat=obj.stats(8);
                case 'affinity'
                    stat=obj.stats(9);
                case 'evaltime'
                    stat=obj.stats(10);
                case 'size'
                    stat=obj.stats(11);
                case 'avgdist'
                    stat=obj.stats(12);
            end;
        end;      
        
%         statistical functions:
%         fitnes oriented:  
%         mean, max, min, median, mode, std, var, cov
%         data oriented:
%         affinity
        function[obj]=set(obj,varargin)     %   universal setup function for the island
             args_in=size(varargin,2);
             for c=2:args_in
%                  if varargin ~= 
                  if isa(varargin{c},'INDIVIDUAL') == 1
                      varargin{c} = 'none';         %this one is unfortunately necessary because switch does not like classes...
                  end
                 try
                 switch varargin{c}
                     case 'space'                   % for generating space function
                         switch varargin{c+1}
                             case 'homo'
                                obj.space = ones(2,varargin{c+4});
                                obj.space(1,:) = varargin{c+2};     %   upper limit
                                obj.space(2,:) = varargin{c+3};     %   lower limit
                                %   example
                                %   obj.set('space','homo',3,-100,100) <<
                                %   generates homogenous space vector
                                %   the lenght of 3 [-100 -100 -100; 100
                                %   100 100]
                             case 'direct'
                                 obj.space = varargin{c+2};         %   defines direct input
                                 %  example:
                                 %  obj.set('space','direct',[-10 -10 -10;
                                 %  10 10 10]) sets the space vector to the
                                 %  vector defined above
                             case 'cyclic'
                                 for cc=1:varargin{c+3}
                                    obj.space = [obj.space varargin{c+2}];
                                 end;
                                 %  example:
                                 %  obj.set('space','cyclic',[-10 -1; 10 1],3)
                                 %  generates [-10 -1 -10 -1 -10 -1; 10 1 10 1 10 1] by
                                 %  cycling. 
                         end
                     case 'size'
                         obj.popsize = varargin{c+1};
                         %  example:
                         %  obj.set('size',100)
                         %  sets the number of individuals in the island
                     case 'control'
                         obj.control = varargin{c+1};
                         %  example:
                         %  obj.set('control','something.m');
                         %  set the control algorithm of the island to the
                         %  something.m file in the folder above.
                     case 'fitfunc'     % sets the evaluating fitnes
                         obj.fitfunc = varargin{c+1};
                     case 'population'  % changes the population of the island
                         obj.population = varargin{c+1};
                         
                     case 'seed'        % seeds the island  NOTE: dont work, dunno why... so use the seed function manually
                         obj = obj.seed();
                     case 'eps'
                         obj.eps = varargin{c+1};
                 end
                 catch
                 end
             end
        end
        
        function[obj]=seed(obj,varargin)    %   creates a population using the setup, it can be set up during the seeding
            if size(varargin,2) > 0
%                 for i=2:size(varargin,2)
%                     obj =  obj.set(obj,varargin{i});    % removed the paralelisation, screwed up the setup
%                 end
            obj =  obj.set(obj,varargin{2:nargin-1});      % believe in yourself :) dont fix things what works

            end
            obj.population = INDIVIDUAL(rand(1,size(obj.space,2)).*sum(abs(obj.space))+obj.space(1,:));
            for c=2:obj.popsize
                 obj.population(c) = INDIVIDUAL(rand(1,size(obj.space,2)).*sum(abs(obj.space))+obj.space(1,:));
               %  obj.population(c) = INDIVIDUAL([1 2 3 4 5 6 7 8 9 10]);
            end
        end
        
        function [extraction]=extract(obj,what)     %   extracts the data to a simple matrix
            switch what
                case 'genes'
                    extraction = merge(obj.population(1:size(obj.population,2)).gene);
                case 'fitnes'
                    extraction = merge(obj.population(1:size(obj.population,2)).fitnes);
                case 'velocity'
                    try
                        extraction = merge(obj.population(1:size(obj.population,2)).velocity);
                    catch
                        error('cannot extract the genes of the population, its not initalised')
                    end
                case 'individuals'
                    extraction = obj.population;
                otherwise
                    disp(['sorry but ' what ' is not supported'])
            end
            
            function [merged]=merge(varargin)       %   helping function to merge the multiple outputs, move along pls, nothing to see here...
                   merged = ones(nargin,size(varargin{1},2));
                   for c=1:nargin
                        merged(c,:)=varargin{c};
                   end
            end
        end
        
        function[obj]=join(obj,varargin)            %   joining multiple islands (or subpopulations represented as islands)
            if size(varargin,2) > 1
                for c=2:size(varargin,2)
                    obj.population = [obj.population varargin{c}.population];
                end
            end
        end
        
        function[obj]=insert(obj,gene)      %inserts a individual to the population with the given gene
            for c=1:size(gene,2)
                obj.population(size(obj.population)+c) = INDIVIDUAL(gene(c,:));                
            end
        end
        
        function[obj]=toolbox26(varargin)           %   provides a backward compatibility for the old toolbox
            retdir=cd('toolbox');
            eval(['fh = @' varargin{2} ';']);
            newpop = fh(varargin{1}.extract('genes'),varargin{3:nargin});
            cd(retdir);
            for c=1:size(newpop,2)
%                 obj = obj.insert(newpop(c,:));
                if sum(varargin{1}.population(c).gene - newpop(c,:)) ~= 0
                    varargin{1}.population(c).gene = newpop(c,:);
                    varargin{1}.population(c).fitnes = inf;
%                     disp(['changing ' num2str(c)])          
                end
            end
            obj = varargin{1};
        end
        
        %---------------------here starts the evolutionary functions
        
        function[obj]=sortit(varargin)     %   sort them according their fitnes
            fit=varargin{1}.extract('fitnes');
            [f order] = sort(fit);  %   why i cannot ignore ~ the value? :(
            indivs = INDIVIDUAL(inf);
            for c=1:size(varargin{1}.population,2)
                indivs(c) = varargin{1}.population(order(c));
            end
%             indivs(:) = varargin{1}.population(order(:));
            obj = varargin{1}.set(varargin{1},'population',indivs);
        end
        
        function[obj]=select(varargin)      % select a subpopulation
            for c=2:nargin
                switch varargin{c}
                    case 'best'             %example subpop = island.select('best',5) and it returns the best 5 individuals
                        varargin{1} = varargin{1}.sortit();
                        varargin{1}.population = varargin{1}.population(1:varargin{c+1});
                    case 'random'
                        varargin{1}.population = varargin{1}.population(ceil(rand(1,varargin{c+1})*size(varargin{1}.population,2)));
                    case 'worst'
                        varargin{1} = varargin{1}.sortit();
                        varargin{1}.population = varargin{1}.population(size(varargin{1}.population,2)-varargin{c+1}+1 : size(varargin{1}.population,2));
                    case 'individual'
                        obj = varargin{1}.population(:).gene;
                end
            end
            obj = varargin{1};
        end
        
        function[obj]=migrate(varargin) % makes the migration happen
            for c=2:nargin
                if isa(varargin{c},'INDIVIDUAL') == 1 || isa(varargin{c},'ISLAND') == 1
                      varargin{c} = 'none';         %this one is unfortunately necessary because switch does not like classes...
                end
                switch varargin{c}
                    case 'out'
                        if size(varargin{1}.inMig,2) == 0
                            varargin{1}.outMig = varargin{c+1}.extract('individuals');
                        else
                            varargin{1}.outMig(size(varargin{1}.inMig,2)+1,:) = varargin{c+1}.extract('individuals');
                        end
                    case 'in'
                         if size(varargin{1}.inMig) > 0
                            if  nargin < c+1
                                varargin{1} = varargin{1}.add(varargin{1}.inMig(1));
                                varargin{1}.inMig = varargin{1}.inMig(2:size(varargin{1}.inMig,2));
                            else
                                if size(varargin{1}.inMig,2) < varargin{c+1}
                                    varargin{1} = varargin{1}.add(varargin{1}.inMig(1:size(varargin{1}.inMig,2))); %case when we request more than is contained in the buffer
                                    varargin{1}.inMig = 0;
                                else
                                    varargin{1} = varargin{1}.add(varargin{1}.inMig(1:varargin{c+1}));
                                    varargin{1}.inMig = varargin{1}.inMig(varargin{c+1}+1:size(varargin{1}.inMig,2));
                                end
                            end
                            
                         end
                end
            end
             obj = varargin{1};
        end
        
        function[obj]=add(varargin)
            for c=2:nargin
                varargin{1}.population = [varargin{1}.population varargin{c}];    %realocating the population... its sad but works
            end
            obj = varargin{1};
        end
    end 
end
    
    
    
    
    
    
    
    
    
    