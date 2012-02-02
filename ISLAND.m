classdef ISLAND
    properties
        genes;          %   genetic data of the population on the island
        fitnes;         %   fitnes values of the population
        
        format = 'double'; %   the format of the genetic data matrix
        
        %PSO data
        velocity;
        social = struct('momentum',[],'indiv',[],'swarm',[]);  %  the three social constants what determines the working of the algorithm.
        memory = struct('value',[],'pos',[]);  %   saves the individual positions
        bestknown = struct('value',[inf],'pos',[]);;
        
        stats;          %   current statistical data
        trail;          %   loged statistical data
%         trends;         %   saved trends???
        fitfunc;        %   the function what is used to evaluate fitnes
        
        space;          %   space vector to restrict the searching interval
        popsize;        %   the size of the population default?
%         control;        %   the algorithm for the panmictic evolution a.k.a. local policy
        evaltime;       %   the number of evaluates of fitnes function
        
        vars;           %   a free to use parameter vector
        
        inMig;          %   the individuals requesting to land in the island
        outMig;         %   the individuals requesting to leave the island
        connection;
        
        eps;
        
        type;           %   saves the type of the island
    end
    methods
        function[obj]=ISLAND(varargin)    %   constructor for the island needs a setup
            obj = obj.set(obj,'space','homo',-500, 500, 10);
            obj = obj.set(obj,'size',10);                       %   default values
            obj = obj.set(obj,'eps',abs(obj.space(1,:)-obj.space(2,:)) * 0.005);
            obj.evaltime = 0;
            obj.type = 'GA';    % default the type of the algorithm is a genetic algorithm
            
            if nargin > 1
                  obj =  obj.set(obj,varargin{1:nargin});
            end
        end
        
        function[obj]=set(obj,varargin)     %   universal setup function for the island
             args_in=size(varargin,2);
             for c=2:args_in
                 try
                 switch varargin{c}
                     case 'space'                   % for generating space function
                         switch varargin{c+1}
                             case 'homo'
                                obj.space = ones(2,varargin{c+4});
                                obj.space(1,:) = varargin{c+2};     %   upper limit
                                obj.space(2,:) = varargin{c+3};     %   lower limit
                                %   example
                                %   obj.set('space','homo',-100,100,3) <<
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
                          eval(['obj.control = @' varargin{c+1}]);
%                          obj.control = varargin{c+1};
                         %  example:
                         %  obj.set('control','something.m');
                         %  set the control algorithm of the island to the
                         %  something.m file in the folder above.
                     case 'fitfunc'     % sets the evaluating fitnes
%                          obj.fitfunc = varargin{c+1};
                          eval(['obj.fitfunc = @' varargin{c+1} ';']);
                     case 'popsize'  % changes the initial population size on the island
                         obj.popsize = varargin{c+1};
                     case 'seed'        % seeds the island  NOTE: dont work, dunno why... so use the seed function manually
                         obj = obj.seed();
                     case 'eps'
                         obj.eps = varargin{c+1};
                     case 'connection'
                         if  size(varargin{c+1},1) == 1
                            obj.connection =  [varargin{c+1}; ones(size(varargin{c+1},1))];
                         elseif size(varargin{c+1},1) == 2
                             obj.connection =  varargin{c+1};
                         else
                             error(['ERROR: the connection matrix is allowed to have one or two rows and not ' num2str(size(varargin{c+1},1))]);
                         end
                     case 'type'
                         switch varargin{c+1}
                             case 'GA'
                                 obj.type = 'GA';
                             case 'PSO'
                                 obj.type = 'PSO';
                             otherwise
                                 error(['Algorithm type ' varargin{c+1} ' is not specified'])
                         end
                     case 'format'
                         obj.format = varargin{c+1};                 
                         
                 end
                 catch
                     
                 end
             end
        end
        
        function[obj]=fitit(obj)    %   evaluates the fitnes for the island ??? does it work?
            
                  if size(obj.fitnes,2) < size(obj.genes,2)
                      obj.fitnes = [obj.fitnes ones(size(1,obj.genes,2) - size(obj.fitnes,2)*inf)];
                  end
            
%                 if(obj.fitnes(c) == inf)
                    unev = obj.fitnes == inf;           %   find where the fitnes wasnt evaluated
                    r = find(unev==1);                   %   creates a vector from the positions
                    
                    if r>0
                         obj.fitnes(r) = obj.fitfunc(obj.genes(r',:));  % evaluates the fitnes function and sets them into position
%                           eval(['fitnew = ' obj.fitfunc '(obj.genes(r'',:));'])
                    end
%                     obj.population(c).fitnes =
%                     fh(obj.population(c).gene);
%                    obj.population(c).fitnes = eval([obj.fitfunc '(obj.population(c).gene);']);
                   obj.evaltime = obj.evaltime + size(r,2);
                
        end;
        
        function[obj]=migrate(varargin)
            obj=varargin{1};
            switch varargin{2}
                case 'in'
%                     for i=2:nargin
                        obj.genes=[obj.genes; obj.inMig];
                        obj.inMig = [];
%                     end
                case 'out'
                    for i=3:nargin
                        obj.outMig = [obj.outMig; varargin{i}.genes];
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
            obj.genes = rand(obj.popsize,size(obj.space,2)).* abs(repmat(obj.space(2,:),obj.popsize,1)-repmat(obj.space(1,:),obj.popsize,1)) - repmat(obj.space(2,:),obj.popsize,1);
            obj.genes = eval([obj.format '(obj.genes);']);
            obj.fitnes = ones(1,obj.popsize)*inf;
            switch obj.type
                case 'GA'
                    %   no change required
                case 'PSO'
                    % setting up default social constants
                    obj.velocity = rand(obj.popsize,size(obj.space,2))*10 - rand(obj.popsize,size(obj.space,2))*10;
                    obj.social.momentum = 1;
                    obj.social.indiv = 0.03;
                    obj.social.swarm = 0.04; %   setting up default values
                    obj.memory.value = ones(1,obj.popsize)*inf;
                    obj.memory.position = obj.genes;
                    % TODO: improve customisation
            end
%             for c=2:obj.popsize
%                  obj.population(c) = INDIVIDUAL(rand(1,size(obj.space,2)).*sum(abs(obj.space))+obj.space(1,:));
%                  obj.population(c) = INDIVIDUAL([1 2 3 4 5 6 7 8 9 10]);
%             end
        end
        
        function[obj]=join(varargin)            %   joining multiple islands (or subpopulations represented as islands)
           obj = varargin{1}; 
           for c=2:size(varargin,2)
               obj.genes = [obj.genes; varargin{c}.genes];
               obj.fitnes = [obj.fitnes varargin{c}.fitnes];
               obj.velocity = [obj.velocity; varargin{c}.velocity];
               obj.evaltime = obj.evaltime + varargin{c}.evaltime;
           end            
        end
        
        function[obj]=toolbox26(varargin)           %   provides a backward compatibility for the old toolbox
            retdir=cd('toolbox');
            eval(['fh = @' varargin{2} ';']);
            newpop = fh(varargin{1}.genes,varargin{3:nargin});
            cd(retdir);
            obj = varargin{1};
            
            tmp = obj.genes - newpop; % TODO: change the fitnes only to the individuals what have been changed!
            
            
            obj.genes = newpop;
            obj.fitnes = ones(1,size(newpop,1)).*inf;
%             for c=1:size(newpop,2)
% %                 obj = obj.insert(newpop(c,:));
%                 if sum(varargin{1}.population(c).gene - newpop(c,:)) ~= 0
%                     varargin{1}.population(c).gene = newpop(c,:);
%                     varargin{1}.population(c).fitnes = inf;
% %                     disp(['changing ' num2str(c)])          
%                 end
%             end
%             c = size(varargin{1}.gene,2);
%             obj = varargin{1};
%             obj.population(1:size(newpop,1)) = INDIVIDUAL(zeros(1,size(obj.space,2)));
%             tmp = mat2cell(newpop,ones(1,size(newpop,1)));
%             [obj.population(1:c).gene] = deal(tmp{:});
        end
        
%         function[obj]=evolve(varargin)
%             gen = 1;
%             obj = varargin{1};
%             if nargin > 1
%                 switch varargin{2}
%                     case 'generation'
%                         gen = varargin{3};
%                     case 'breaker'
%                         gen = 1e20;
%                 end
%             end
%             for c=1:gen
%                obj.control();
%             end
%                     
%         end
        
        %-----------------------------------evolutionary functions... so far
        function[obj]=reinit(varargin)
            obj=varargin{1}.seed();
        end
        
        function[obj]=move(varargin)
            obj = varargin{1};
            obj = obj.fitit();
            
            [best pos]= min(obj.fitnes);
            if obj.bestknown.value > best
                 obj.bestknown.value = best;
                 obj.bestknown.pos = obj.genes(pos,:);
            end
            
            if obj.memory.value > obj.fitnes    %this should work... does it? note: look like it does                  
                obj.memory.value = obj.fitnes;
                obj.memory.pos = obj.genes;
            end
            
            % calculating the new velocity and the position
            obj.velocity = obj.velocity * obj.social.momentum  + obj.social.indiv * (obj.memory.position - obj.genes) .* rand(size(obj.social.indiv))+ obj.social.swarm .* (repmat(obj.bestknown.pos,obj.popsize,1) - obj.genes) .* rand(size(obj.social.swarm));
            obj.genes = obj.genes + obj.velocity;
            
            %   closing the borders to bounce off
            border = obj.genes < repmat(obj.space(1,:),size(obj.genes,1),1);
            [individual genotype] = find(border == 1);
%             genotype = unique(genotype);

            if size(individual) ~= 0
                for aaa=1:size(individual,1) %  i dont like this one, but after two days of optimalization i decided to use a cycle
                    obj.velocity(individual(aaa), genotype(aaa)) = obj.velocity(individual(aaa), genotype(aaa)) * -1;
                    obj.genes(individual(aaa), genotype(aaa)) = obj.space(1,genotype(aaa));
                end
            end
            
            border = obj.genes > repmat(obj.space(2,:),size(obj.genes,1),1);
            [individual genotype] = find(border == 1);
            if size(individual) ~= 0
                for aaa=1:size(individual,1)
                    obj.velocity(individual(aaa), genotype(aaa) ) = obj.velocity(individual(aaa), genotype(aaa)) * -1;
                    obj.genes(individual(aaa), genotype(aaa)) = obj.space(2,genotype(aaa));
                end
            end
            
            
%             obj.velocity = obj.velocity * obj.social.momentum .* rand(size(obj.velocity)) + obj.social.indiv * obj.memory.position .* rand(size(obj.indiv))+ obj.social.swarm * repmat(obj.bestknown.pos,obj.popsize,1);
            
            %   above: calculating new velocity
            obj.fitnes =  abs(obj.fitnes) * inf;
        end
        
        function[obj]=select(varargin)      % select a subpopulation
            obj = varargin{1};
            for c=2:nargin
                switch varargin{c}
                    case 'best'             %example subpop = island.select('best',5) and it returns the best 5 individuals
                        varargin{1} = varargin{1}.sortit();
                        obj.genes = varargin{1}.genes(1:varargin{c+1},:);
                        obj.fitnes = varargin{1}.fitnes(1:varargin{c+1});
                    case 'random'
                        rnd = rand(1,varargin{c+1}); % need the same numbers for getting the fitnes
                        obj.genes = varargin{1}.genes(ceil(rnd*size(varargin{1}.genes,2)),:);
                        obj.fitnes = varargin{1}.fitnes(ceil(rnd*size(varargin{1}.fitnes,2)));
                    case 'worst'
                        varargin{1} = varargin{1}.sortit();
                        obj.genes = varargin{1}.genes(size(varargin{1}.genes,2)-varargin{c+1}+1 : size(varargin{1}.genes,2));                    
                end
                  
            end
            obj.evaltime = 0; % varargin{1}.evaltime;
        end
        
        
         function[obj]=sortit(varargin)     %   sort them according their fitnes
%             fit=varargin{1}.extract('fitnes');
            obj = varargin{1};
            varargin{1} =  varargin{1}.fitit();
            [fit order] = sort([ varargin{1}.fitnes]); 
%             indivs = INDIVIDUAL(inf);
            c=size(varargin{1}.genes,2);
            obj.genes(1:c,:) = varargin{1}.genes(order(1:c),:);
            obj.fitnes = fit;
%             obj.evaltime =  varargin{1}.evaltime;       % the evaluation time wasnt working without this :(
%             for c=1:size(varargin{1}.population,2)
%                 indivs(c) = varargin{1}.population(order(c));
%             end
%             indivs(:) = varargin{1}.population(order(:));
             
%             obj = varargin{1}.set(varargin{1},'population',indivs);
         end
         
         
        
        
        
        %-----------------------------------STATFUN =)
        %         statistical functions:
%         fitnes oriented:  
%         mean, max, min, median, mode, std, var, cov
%         data oriented:
%         affinity
        
        
        function[obj]=stats_update(obj)     %   updates the statistical data of the island
%             tmp=obj.extract('fitnes');
            obj.stats = [mean(obj.fitnes) max(obj.fitnes) min(obj.fitnes) median(obj.fitnes) mode(obj.fitnes) std(obj.fitnes) var(obj.fitnes) cov(obj.fitnes) affinity(obj.fitnes) obj.evaltime size(obj.genes,1) adist(obj.fitnes) obj.bestknown.value];
        
            function[ad]=adist(obj)
%                  tmp=obj.extract('genes');
%                  ad = sum(sum(dist(tmp)))/(size(dist,1)*size(dist,2) - size(dist,1));
                    ad = 0;     % this is not working for now... need to debug
            end
            
            function[aff]=affinity(obj) %   calculates the affinity of the genes... TODO!!!
%                 if size(obj.eps,2) ~= 0
%                     tmp=obj.extract('genes');
%                     [x y]=size(tmp);
%                     edist = dist(tmp);  %   calculating eucledian distance matrix
%                     epsm = zeros(size(edist));
%                     for i=1:size(epsm,2)
%                         epsm(:,i) = obj.eps(i);
%                     end
%                     edist = floor((edist - epsm)/max(max(obj.space))).*-1;  %   these are similar to each other
%                     %   TODO
%                 else
%                     aff=0;  % not calculating, its heavy
%                 end
                
                aff = 0; %  remove if finished :)
                
            end;
        end;
        
        function[obj]=update(obj)   %   updates the data of the island
%             for c=1:size(obj.population)
              
              obj=obj.fitit();
              obj= obj.stats_update();
            obj = obj.trail_update();
        end
        
        function[obj]=trail_update(obj)     %   appends the statistical log data 
            obj = obj.stats_update();
            obj.trail(:,size(obj.trail,2)+1)=obj.stats';
        end
        
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
                    case 'bestknown'
                        stat(:,c-1)=obj.trail(13,:);
                end;
             end;
        end;
        
        function[stat]=getstats(varargin)    %   returns the requested statistical data
            switch varargin{2}
                case 'mean'
                    stat=varargin{1}.stats(1);
                case 'max'
                    stat=varargin{1}.stats(2);
                case 'min'
                    stat=varargin{1}.stats(3);
                case 'median'
                    stat=varargin{1}.stats(4);
                case 'mode'
                    stat=varargin{1}.stats(5);
                case 'std'
                    stat=varargin{1}.stats(6);
                case 'var'
                    stat=varargin{1}.stats(7);    
                case 'cov'
                    stat=varargin{1}.stats(8);
                case 'affinity'
                    stat=varargin{1}.stats(9);
                case 'evaltime'
                    stat=varargin{1}.stats(10);
                case 'size'
                    stat=varargin{1}.stats(11);
                case 'avgdist'
                    stat=varargin{1}.stats(12);
                case 'bestknown'
                    stat=varargin{1}.stats(13);
            end;
        end;
        
    end
end