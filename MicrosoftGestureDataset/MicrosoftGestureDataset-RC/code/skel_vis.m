function skel_vis(X,tidx,h);
%SKEL_VIS -- Visualize a skeleton in 3D coordinates.
%
% Input
%   X: (T,4*NUI_SKELETON_POSITION_COUNT) matrix from load_file.
%   tidx: time index >=1, <=T.
%   h: (optional) axes handle to draw in.
%
% Author: Sebastian Nowozin <Sebastian.Nowozin@microsoft.com>
disp(tidx)
assert(tidx >= 1);
assert(tidx <= size(X,1));
NUI_SKELETON_POSITION_HIP_CENTER = 0;
NUI_SKELETON_POSITION_SPINE = 1;
NUI_SKELETON_POSITION_SHOULDER_CENTER = 2;
NUI_SKELETON_POSITION_HEAD = 3;
NUI_SKELETON_POSITION_SHOULDER_LEFT = 4;
NUI_SKELETON_POSITION_ELBOW_LEFT = 5;
NUI_SKELETON_POSITION_WRIST_LEFT = 6;
NUI_SKELETON_POSITION_HAND_LEFT = 7;
NUI_SKELETON_POSITION_SHOULDER_RIGHT = 8;
NUI_SKELETON_POSITION_ELBOW_RIGHT = 9;
NUI_SKELETON_POSITION_WRIST_RIGHT = 10;
NUI_SKELETON_POSITION_HAND_RIGHT = 11;
NUI_SKELETON_POSITION_HIP_LEFT = 12;
NUI_SKELETON_POSITION_KNEE_LEFT = 13;
NUI_SKELETON_POSITION_ANKLE_LEFT = 14;
NUI_SKELETON_POSITION_FOOT_LEFT = 15;
NUI_SKELETON_POSITION_HIP_RIGHT = 16;
NUI_SKELETON_POSITION_KNEE_RIGHT = 17;
NUI_SKELETON_POSITION_ANKLE_RIGHT = 18;
NUI_SKELETON_POSITION_FOOT_RIGHT = 19;

NUI_SKELETON_POSITION_COUNT = 20;

HIP_CENTER = 0;
SPINE = 1;
SHOULDER_CENTER = 2;
HEAD = 3;
SHOULDER_LEFT = 4;
ELBOW_LEFT = 5;
WRIST_LEFT = 6;
HAND_LEFT = 7;
SHOULDER_RIGHT = 8;
ELBOW_RIGHT = 9;
WRIST_RIGHT = 10;
HAND_RIGHT = 11;
HIP_LEFT = 12;
KNEE_LEFT = 13;
ANKLE_LEFT = 14;
FOOT_LEFT = 15;
HIP_RIGHT = 16;
KNEE_RIGHT = 17;
ANKLE_RIGHT = 18;
FOOT_RIGHT = 19;

nui_skeleton_names = { ...
	'HIP_CENTER', 'SPINE', 'SHOULDER_CENTER', 'HEAD', ...
	'SHOULDER_LEFT', 'ELBOW_LEFT', 'WRIST_LEFT', 'HAND_LEFT', ...
	'SHOULDER_RIGHT', 'ELBOW_RIGHT', 'WRIST_RIGHT', 'HAND_RIGHT', ...
	'HIP_LEFT', 'KNEE_LEFT', 'ANKLE_LEFT', 'FOOT_LEFT', ...
	'HIP_RIGHT', 'KNEE_RIGHT', 'ANKLE_RIGHT', 'FOOT_RIGHT' };

nui_skeleton_conn = [ ...
	HIP_CENTER, SPINE; ...
	SPINE, SHOULDER_CENTER; ...
	SHOULDER_CENTER, HEAD; ...
	% Left arm ...
	SHOULDER_CENTER, SHOULDER_LEFT; ...
	SHOULDER_LEFT, ELBOW_LEFT; ...
	ELBOW_LEFT, WRIST_LEFT; ...
	WRIST_LEFT, HAND_LEFT; ...
	% Right arm ...
	SHOULDER_CENTER, SHOULDER_RIGHT; ...
	SHOULDER_RIGHT, ELBOW_RIGHT; ...
	ELBOW_RIGHT, WRIST_RIGHT; ...
	WRIST_RIGHT, HAND_RIGHT; ...
	% Left leg ...
	HIP_CENTER, HIP_LEFT; ...
	HIP_LEFT, KNEE_LEFT; ...
	KNEE_LEFT, ANKLE_LEFT; ...
	ANKLE_LEFT, FOOT_LEFT; ...
	% Right leg ...
	HIP_CENTER, HIP_RIGHT; ...
	HIP_RIGHT, KNEE_RIGHT; ...
	KNEE_RIGHT, ANKLE_RIGHT; ...
	ANKLE_RIGHT, FOOT_RIGHT ...
];

xyz_ti=X(tidx,:);
NUI_SKELETON_POSITION_COUNT = 20;
skel=reshape(xyz_ti, 4, NUI_SKELETON_POSITION_COUNT)';
if nargin < 3
	h=axes;
end
plot3(skel(:,1), skel(:,2), skel(:,3), 'bo');
axis equal;

for ci=1:size(nui_skeleton_conn,1)
	hold on;
	line([xyz_ti(4*nui_skeleton_conn(ci,1)+1) ; ...
		xyz_ti(4*nui_skeleton_conn(ci,2)+1)], ...
		[xyz_ti(4*nui_skeleton_conn(ci,1)+2) ; ...
		xyz_ti(4*nui_skeleton_conn(ci,2)+2)], ...
		[xyz_ti(4*nui_skeleton_conn(ci,1)+3) ; ...
		xyz_ti(4*nui_skeleton_conn(ci,2)+3)]);
end
cpos=skel(HIP_CENTER+1,1:3) + [3, 2, -5];

set(h,'CameraPosition',cpos);
set(h,'CameraTarget',skel(HIP_CENTER+1,1:3));
set(h,'CameraViewAngle',12);
set(h,'CameraUpVector',[0 1 0]);
set(h,'Projection','perspective');

xmin=min(min(X(:,1:4:size(X,2))));
ymin=min(min(X(:,2:4:size(X,2))));
zmin=min(min(X(:,3:4:size(X,2))));
xmax=max(max(X(:,1:4:size(X,2))));
ymax=max(max(X(:,2:4:size(X,2))));
zmax=max(max(X(:,3:4:size(X,2))));

set(h,'XLim', [xmin, xmax]);
set(h,'YLim', [ymin, ymax]);
set(h,'ZLim', [zmin, zmax]);

tpos=[0.5*(xmin+xmax), 0.5*(ymin+ymax), 0.5*(zmin+zmax)];
cpos=tpos + 1.5*[3, 2, -5];
set(h,'CameraPosition',cpos);
set(h,'CameraTarget',tpos);

title(sprintf('Frame %d', tidx));

