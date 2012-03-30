classdef WORLD
    properties
        initSize = 9;           %   initial ammount of the islands
        format = 'double';      %   the format of the genetic data matrix
        initPopsize = 10;        %   initial population size on the islands can be a vector
        space;          %   target area where the values are searched
        fitfunc;            %   simply the name of the function for oprimalisation
        
        islands;            %   works actually with an island
        
        type = 'GA';        %   what type of evolutionary algorithm is present default Genetic Algorithm
        
        
        structure  = struct('connection',[],'strenght',[]);
        statistics = struct('mean',[],'max',[],'min',[],'median',[],'mode',[],'std',[],'var',[],'cov',[],'affinity',[],'evaltime',[],'size',[],'bestknown',[]);
        trail      = struct('mean',[],'max',[],'min',[],'median',[],'mode',[],'std',[],'var',[],'cov',[],'affinity',[],'evaltime',[],'size',[],'bestknown',[]);
    end
    methods
        function[obj]=WORLD(varargin)
%             obj.initSize = 9;
%             obj.initPopsize = 10;
            if nargin > 1
                obj = obj.set(varargin{1:nargin});
            end
        end
        
        function[obj]=set(varargin)         % an inportant note: DO NOT USE GENERATORS IN MULTIPLE SETUP COMMANDS
            obj = varargin{1};
            if nargin > 1
                for c=2:nargin
                    try
                    switch varargin{c}
                        case 'structure'
                            obj.structure.connection = varargin{c+1};
                        case 'strenght'
                            obj.structure.strenght = varargin{c+1};
                        case 'initSize'
                            obj.initSize = varargin{c+1};
                        case 'initPopsize'
                            obj.initPopsize = varargin{c+1};
                        case 'space'
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
                                     obj.space = [];
                                     for cc=1:varargin{c+3}
                                        obj.space = [obj.space varargin{c+2}];
                                     end;
                                     %  example:
                                     %  obj.set('space','cyclic',[-10 -1; 10 1],3)
                                     %  generates [-10 -1 -10 -1 -10 -1; 10 1 10 1 10 1] by
                                     %  cycling. 
                             end
                        case 'fitfunc'
                            obj.fitfunc = varargin{c+1};
                        case 'type'
                            obj.type = varargin{c+1};
                        case 'format'
                            obj.format = varargin{c+1};        
                    end
                    catch err
                        % ugly but foolproof :D
%                         disp(['catched: ' err])
                    end
                end
            end
        end
        
        function[obj]=genesis(varargin)
            obj = varargin{1};
             obj.islands = ISLAND %(obj.space,'fitfunc',obj.fitfunc,'population',obj.initPopsize);
            for c = 1:obj.initSize
                obj.islands(c) = ISLAND('space','direct',obj.space,'fitfunc',obj.fitfunc,'popsize',obj.initPopsize,'type',obj.type,'format',obj.format);
        %                 obj.islands(c) = obj.islands(c).set(obj.spaceCODE,'fitfunc',obj.fitfunc,'population',obj.initPopsize);
                obj.islands(c) = obj.islands(c).seed();
            end
        end
        
        function[cmatrix]=cmg(varargin) %   connection matrix generator
            retdir = cd('generators');
                                 
            switch varargin{2}
                case 'grid'                                   %   example obj.cmg('grid',3,3) returns a grid structure with size of 3x3
                    cmatrix = grid(varargin{3:nargin});
                case 'random'                                 %   example obj.cmg('random',3) generates an apropriate cmatrix with 3 interconnections
                    cmatrix = randCon(size(varargin{1}.islands,2),varargin{3});
                case 'tree'                                   %   example obj.cmg('tree',3) generates a tree structure and checks if there is enough islands
                    cmatrix= bTree(varargin{3});
                case 'star'     % example obj.cmg('star') builds an apropriate star like structure
                    if nargin > 2
                        param = varargin{3};
                    else
                        param = varargin{1}.initSize;
                    end
                    cmatrix= star(param);
                case 'ring'     % example obj.cmg('ring') builds an apropriate ring like structure also can be defined specificly like:  obj.cmg('ring',5) its used for initialising generators
                    if nargin > 2
                        param = varargin{3};
                    else
                        param = varargin{1}.initSize;
                    end
                    switch varargin{4}                        
                        case 'oneway'                            
                            cmatrix= ring(param,0);
                        case 'duplex'
                            cmatrix= ring(param,1);
                    end
                 case 'claw'                                   %   example
                    cmatrix = claw(varargin{3:nargin});
                 case 'octa'                                   %   example
                    cmatrix = octag(varargin{3:nargin});
            end
            if size(cmatrix,1) ~= varargin{1}.initSize
                warning('the number of islands wont passes the connection data size, it could be a problem')
                warning(['if you are using this as a initializing setup, then use a parameter after the structure type elsewhere the default size of the island going to be used what is ' num2str(varargin{1}.initSize)])
%                 in = input('are you sure to continue? yes = 1 / no = 0: ')
%                 if in == 0
%                     error('canceling because of island failure')
%                 end
                    
            end
            cd(retdir);
        end
        
        function[obj]=migrate(varargin)
            obj = varargin{1};
            if size(obj.structure.connection,1) == 0
                error('the migration status is not initialised');
            end            
            for i=1:size(obj.islands,2)     % TODO: cancel the for cycle :(
                if size(obj.islands(i).outMig,1) > 0    % check if is there anything can migrate, without this, it just resets the outMig
                    index = obj.structure.connection(i,:);
                    % requires filtering
                    index = index(index~=0);
                    index = index(index~=inf);

    %                 [obj.islands(index).inMig] = deal(obj.islands(i).outMig);
    %                 does not work with paralel threads... why?

                    for ii=1:size(index,2)
                        obj.islands(index(ii)).inMig = obj.islands(i).outMig; % ugly... :(
                    end
                    obj.islands(i).outMig = [];
                end
            end
        end
        
        function[obj]=update(varargin)
            obj = varargin{1};
            for uc = 1:size(obj.islands,2)
                obj.islands(uc) = obj.islands(uc).update();
                agdata(uc,:) = obj.islands(uc).stats;
            end
            obj.statistics.mean = agdata(:,1);
            obj.statistics.max = agdata(:,2);
            obj.statistics.min = agdata(:,3);
            obj.statistics.median = agdata(:,4);
            obj.statistics.mode = agdata(:,5);
            obj.statistics.std = agdata(:,6);
            obj.statistics.var = agdata(:,7);
            obj.statistics.cov = agdata(:,8);
            obj.statistics.affinity = agdata(:,9);
            obj.statistics.evaltime = agdata(:,10);
            obj.statistics.size = agdata(:,11);
            obj.statistics.bestknown = agdata(:,13);
            
            obj.trail.mean(:,size(obj.trail.mean,2)+1) = agdata(:,1);
            obj.trail.max(:,size(obj.trail.max,2)+1) = agdata(:,2);
            obj.trail.min(:,size(obj.trail.min,2)+1) = agdata(:,3);
            obj.trail.median(:,size(obj.trail.median,2)+1) = agdata(:,4);
            obj.trail.mode(:,size(obj.trail.mode,2)+1) = agdata(:,5);
            obj.trail.std(:,size(obj.trail.std,2)+1) = agdata(:,6);
            obj.trail.var(:,size(obj.trail.var,2)+1) = agdata(:,7);
            obj.trail.cov(:,size(obj.trail.cov,2)+1) = agdata(:,8);
            obj.trail.affinity(:,size(obj.trail.affinity,2)+1) = agdata(:,9);
            obj.trail.evaltime(:,size(obj.trail.evaltime,2)+1) = agdata(:,10);
            obj.trail.size(:,size(obj.trail.size,2)+1) = agdata(:,11);
            obj.trail.bestknown(:,size(obj.trail.size,2)+1) = agdata(:,13);
            
        end
        
        function[]=mapme(varargin)        
                cmatrix = varargin{1}.structure.connection;
                [rows lenght]=size(cmatrix);
                for i=1:lenght
                    names(i)=i;
                end;
                cm=zeros(rows);
                for x=1:rows
                    for y=1:lenght
                        trgt=cmatrix(x,y);
                        if trgt ~= inf 
                            if trgt ~= 0
                                cm(x,trgt)=1;
                            end;
                        end;
                    end;
                end;


                map=biograph(cm)
                view(map)
        end
        
        function[obj] = restruct(varargin)
            obj = varargin{1};
            
            %clusterset = {'linkage','ward'};   % no cluster setup is
            %possible
            scatter = 9;    %how many drops will be created after blobulation
            
            if nargin > 1
                for i=2:nargin
                    try
                    switch varargin{i}
                        case 'scatter'
                            scatter = varargin{i+1};
                        case 'clusterset'
                            clusterset = varargin{i+1};
                    end
                    catch
                    end
                end
            end
            
            % dataset = [obj.islands(:).genes]'; % i have to remove the 
            dataset = [];
            for ii=1:length(obj.islands)
                dataset = [dataset; obj.islands(ii).genes];                
            end
            
            obj.islands = ISLAND;
            % unbelievable there is no other way:
            for iv = 1:scatter
                 obj.islands(iv) = ISLAND('space','direct',obj.space,'fitfunc',obj.fitfunc,'popsize',obj.initPopsize,'type',obj.type,'format',obj.format);
            end
            
            
            clustered = clusterdata(dataset,'linkage','ward','maxclust',scatter);
            
            %   fix it, it does not work!!!
            obj.islands(clustered).genes = dataset(clustered,:);
            obj.islands(clustered).fitnes = ones(1,size(obj.islands(clustered).genes,2))*inf;
            
            
        end
    end
end
    