function [data_output] = at_generateMatrixCONG(catchtrials, incongruent_mstrials, audInfo, visInfo)


% Adam J. Tiesman - 8/28/25
% Trial matrix generator for AV congruency with PARAMETRIC incongruency.
% OUTPUT COLUMNS (per row/trial):
%   [audDir(deg), audCoh, visDir(deg), visCoh]
%
% IMPORTANT:
% - audInfo.dirSet and visInfo.dirSet define direction grids.
%   Example: visInfo.dirSet = [0 30 60 90 120 150 180];
%            audInfo.dirSet = [0 180];
% - Coherence is ONE value for both modalities: audInfo.cohSet(1) == visInfo.cohSet(1)
% - We interpret INCONGRUENT_MSTRIALS as "trials PER incongruent permutation".
% - We AUTOMATICALLY set the total number of CONGRUENT trials to equal the
%   total number of INCONGRUENT trials, split evenly across congruent perms.

    %#---------------------------------------------------------------------
    %# Validate inputs
    if numel(audInfo.cohSet) ~= 1 || numel(visInfo.cohSet) ~= 1
        error('audInfo.cohSet and visInfo.cohSet must each contain exactly ONE value (same coherence for A/V).');
    end
    if abs(audInfo.cohSet(1) - visInfo.cohSet(1)) > 1e-12
        error('audInfo.cohSet(1) and visInfo.cohSet(1) must be identical.');
    end
    coh = audInfo.cohSet(1);

    if ~isfield(audInfo,'dirSet') || ~isfield(visInfo,'dirSet')
        error('audInfo.dirSet and visInfo.dirSet must be provided.');
    end
    audDirs = audInfo.dirSet(:)';  % row vector
    visDirs = visInfo.dirSet(:)';

    %#---------------------------------------------------------------------
    %# Build permutation lists
    % Congruent = exact direction match that exists in BOTH sets
    commonDirs = intersect(audDirs, visDirs, 'stable');
    cong_pairs = [commonDirs(:), commonDirs(:)];     % Nx2 [audDir, visDir]

    % Incongruent = all (aud, vis) with aud != vis
    [AA, VV] = ndgrid(audDirs, visDirs);
    all_pairs = [AA(:), VV(:)];
    incong_pairs = all_pairs(all_pairs(:,1) ~= all_pairs(:,2), :);

    nIncongPerms = size(incong_pairs,1);
    nCongPerms   = size(cong_pairs,1);

    if nCongPerms == 0
        error('There are no congruent permutations (no overlap between audInfo.dirSet and visInfo.dirSet).');
    end
    if incongruent_mstrials < 1
        error('incongruent_mstrials must be >= 1 (trials per incongruent permutation).');
    end

    %#---------------------------------------------------------------------
    %# Determine trial counts
    % Even # per incongruent permutation:
    trials_per_incong_perm = incongruent_mstrials;

    total_incong = nIncongPerms * trials_per_incong_perm;

    % Enforce: total_congruent == total_incongruent
    base_cong_per_perm = floor(total_incong / nCongPerms);
    remainder          = mod(total_incong, nCongPerms);
    cong_counts = repmat(base_cong_per_perm, nCongPerms, 1);
    if remainder > 0
        % Distribute any remainder one-by-one over the first few perms
        cong_counts(1:remainder) = cong_counts(1:remainder) + 1;
    end
    total_cong = sum(cong_counts);

    %#---------------------------------------------------------------------
    %# Build catch trials (noise-only)
    % Directions arbitrary; coherence = 0 guarantees noise.
    catchmat = repmat([0, 0, 0, 0], catchtrials, 1);

    %#---------------------------------------------------------------------
    %# Build congruent trials
    cong_trials = zeros(total_cong, 4);
    row = 1;
    for i = 1:nCongPerms
        aDir = cong_pairs(i,1);
        vDir = cong_pairs(i,2);
        k = cong_counts(i);
        if k > 0
            cong_trials(row:row+k-1, :) = repmat([aDir, coh, vDir, coh], k, 1);
            row = row + k;
        end
    end

    %#---------------------------------------------------------------------
    %# Build incongruent trials (even per permutation)
    incong_trials = zeros(total_incong, 4);
    row = 1;
    for i = 1:nIncongPerms
        aDir = incong_pairs(i,1);
        vDir = incong_pairs(i,2);
        k = trials_per_incong_perm;
        incong_trials(row:row+k-1, :) = repmat([aDir, coh, vDir, coh], k, 1);
        row = row + k;
    end

    %#---------------------------------------------------------------------
    %# Combine & randomize
    all_trials = [catchmat; cong_trials; incong_trials];

    rng('shuffle');
    order = randperm(size(all_trials, 1));
    data_output = all_trials(order, :);

end

