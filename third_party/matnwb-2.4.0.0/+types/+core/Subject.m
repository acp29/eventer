classdef Subject < types.core.NWBContainer & types.untyped.GroupClass
% SUBJECT Information about the animal or person from which the data was measured.


% PROPERTIES
properties
    age; % Age of subject. Can be supplied instead of 'date_of_birth'.
    date_of_birth; % Date of birth of subject. Can be supplied instead of 'age'.
    description; % Description of subject and where subject came from (e.g., breeder, if animal).
    genotype; % Genetic strain. If absent, assume Wild Type (WT).
    sex; % Gender of subject.
    species; % Species of subject.
    strain; % Strain of subject.
    subject_id; % ID of animal/person used/participating in experiment (lab convention).
    weight; % Weight at time of experiment, at time of surgery and at other important times.
end

methods
    function obj = Subject(varargin)
        % SUBJECT Constructor for Subject
        %     obj = SUBJECT(parentname1,parentvalue1,..,parentvalueN,parentargN,name1,value1,...,nameN,valueN)
        % age = char
        % date_of_birth = isodatetime
        % description = char
        % genotype = char
        % sex = char
        % species = char
        % strain = char
        % subject_id = char
        % weight = char
        obj = obj@types.core.NWBContainer(varargin{:});
        
        
        p = inputParser;
        p.KeepUnmatched = true;
        p.PartialMatching = false;
        p.StructExpand = false;
        addParameter(p, 'age',[]);
        addParameter(p, 'date_of_birth',[]);
        addParameter(p, 'description',[]);
        addParameter(p, 'genotype',[]);
        addParameter(p, 'sex',[]);
        addParameter(p, 'species',[]);
        addParameter(p, 'strain',[]);
        addParameter(p, 'subject_id',[]);
        addParameter(p, 'weight',[]);
        misc.parseSkipInvalidName(p, varargin);
        obj.age = p.Results.age;
        obj.date_of_birth = p.Results.date_of_birth;
        obj.description = p.Results.description;
        obj.genotype = p.Results.genotype;
        obj.sex = p.Results.sex;
        obj.species = p.Results.species;
        obj.strain = p.Results.strain;
        obj.subject_id = p.Results.subject_id;
        obj.weight = p.Results.weight;
        if strcmp(class(obj), 'types.core.Subject')
            types.util.checkUnset(obj, unique(varargin(1:2:end)));
        end
    end
    %% SETTERS
    function obj = set.age(obj, val)
        obj.age = obj.validate_age(val);
    end
    function obj = set.date_of_birth(obj, val)
        obj.date_of_birth = obj.validate_date_of_birth(val);
    end
    function obj = set.description(obj, val)
        obj.description = obj.validate_description(val);
    end
    function obj = set.genotype(obj, val)
        obj.genotype = obj.validate_genotype(val);
    end
    function obj = set.sex(obj, val)
        obj.sex = obj.validate_sex(val);
    end
    function obj = set.species(obj, val)
        obj.species = obj.validate_species(val);
    end
    function obj = set.strain(obj, val)
        obj.strain = obj.validate_strain(val);
    end
    function obj = set.subject_id(obj, val)
        obj.subject_id = obj.validate_subject_id(val);
    end
    function obj = set.weight(obj, val)
        obj.weight = obj.validate_weight(val);
    end
    %% VALIDATORS
    
    function val = validate_age(obj, val)
        val = types.util.checkDtype('age', 'char', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[1]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_date_of_birth(obj, val)
        val = types.util.checkDtype('date_of_birth', 'isodatetime', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[1]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_description(obj, val)
        val = types.util.checkDtype('description', 'char', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[1]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_genotype(obj, val)
        val = types.util.checkDtype('genotype', 'char', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[1]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_sex(obj, val)
        val = types.util.checkDtype('sex', 'char', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[1]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_species(obj, val)
        val = types.util.checkDtype('species', 'char', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[1]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_strain(obj, val)
        val = types.util.checkDtype('strain', 'char', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[1]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_subject_id(obj, val)
        val = types.util.checkDtype('subject_id', 'char', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[1]};
        types.util.checkDims(valsz, validshapes);
    end
    function val = validate_weight(obj, val)
        val = types.util.checkDtype('weight', 'char', val);
        if isa(val, 'types.untyped.DataStub')
            valsz = val.dims;
        elseif istable(val)
            valsz = height(val);
        elseif ischar(val)
            valsz = size(val, 1);
        else
            valsz = size(val);
        end
        validshapes = {[1]};
        types.util.checkDims(valsz, validshapes);
    end
    %% EXPORT
    function refs = export(obj, fid, fullpath, refs)
        refs = export@types.core.NWBContainer(obj, fid, fullpath, refs);
        if any(strcmp(refs, fullpath))
            return;
        end
        if ~isempty(obj.age)
            if startsWith(class(obj.age), 'types.untyped.')
                refs = obj.age.export(fid, [fullpath '/age'], refs);
            elseif ~isempty(obj.age)
                io.writeDataset(fid, [fullpath '/age'], obj.age);
            end
        end
        if ~isempty(obj.date_of_birth)
            if startsWith(class(obj.date_of_birth), 'types.untyped.')
                refs = obj.date_of_birth.export(fid, [fullpath '/date_of_birth'], refs);
            elseif ~isempty(obj.date_of_birth)
                io.writeDataset(fid, [fullpath '/date_of_birth'], obj.date_of_birth);
            end
        end
        if ~isempty(obj.description)
            if startsWith(class(obj.description), 'types.untyped.')
                refs = obj.description.export(fid, [fullpath '/description'], refs);
            elseif ~isempty(obj.description)
                io.writeDataset(fid, [fullpath '/description'], obj.description);
            end
        end
        if ~isempty(obj.genotype)
            if startsWith(class(obj.genotype), 'types.untyped.')
                refs = obj.genotype.export(fid, [fullpath '/genotype'], refs);
            elseif ~isempty(obj.genotype)
                io.writeDataset(fid, [fullpath '/genotype'], obj.genotype);
            end
        end
        if ~isempty(obj.sex)
            if startsWith(class(obj.sex), 'types.untyped.')
                refs = obj.sex.export(fid, [fullpath '/sex'], refs);
            elseif ~isempty(obj.sex)
                io.writeDataset(fid, [fullpath '/sex'], obj.sex);
            end
        end
        if ~isempty(obj.species)
            if startsWith(class(obj.species), 'types.untyped.')
                refs = obj.species.export(fid, [fullpath '/species'], refs);
            elseif ~isempty(obj.species)
                io.writeDataset(fid, [fullpath '/species'], obj.species);
            end
        end
        if ~isempty(obj.strain)
            if startsWith(class(obj.strain), 'types.untyped.')
                refs = obj.strain.export(fid, [fullpath '/strain'], refs);
            elseif ~isempty(obj.strain)
                io.writeDataset(fid, [fullpath '/strain'], obj.strain);
            end
        end
        if ~isempty(obj.subject_id)
            if startsWith(class(obj.subject_id), 'types.untyped.')
                refs = obj.subject_id.export(fid, [fullpath '/subject_id'], refs);
            elseif ~isempty(obj.subject_id)
                io.writeDataset(fid, [fullpath '/subject_id'], obj.subject_id);
            end
        end
        if ~isempty(obj.weight)
            if startsWith(class(obj.weight), 'types.untyped.')
                refs = obj.weight.export(fid, [fullpath '/weight'], refs);
            elseif ~isempty(obj.weight)
                io.writeDataset(fid, [fullpath '/weight'], obj.weight);
            end
        end
    end
end

end