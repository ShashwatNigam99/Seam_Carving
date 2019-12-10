close all;
img  = imread('./tower.jpg');
og_img = img;
iters = 500;

tic
for p=1:iters
  [r,c,d] = size(img);
  % calculate importance matrix and initialize cost matrix = 0
  [impmat,~] = imgradient(rgb2gray(img),'sobel');
  cost = zeros(r,c);

  % calculate dp cost matrix
  cost(1,:) = impmat(1,:);
  minc = double(intmax);
  miny = 1;
  for i =2:r
    for j=1:c
        cost(i,j) = min( min( cost(i-1,max(j-1,1)), cost(i-1,j) ) , cost(i-1,min(j+1,c) ) ) + impmat(i,j);
    end
  end

  % find min cost from bottom row
  [~,miny] = min(cost(r,:));

  % find min cost path till the top and shift cells accordingly
  for i=r:-1:1
    % find upper minimum y index
    upminy = cost(max(i-1,1),max(miny-1,1));
    mincost = double(intmax);
    for j = max(miny-1,1):min(miny+1,c)
      if i == 1
        break;
      end
      if cost(i-1,j)<mincost
        mincost = cost(i-1,j);
        upminy = j;
      end
    end
    img(i,miny:end-1,:) = img(i,miny+1:end,:);
    miny = upminy;
    % replacing new minimum
  end
  img = img(:,1:c-1,:);
end
a = toc
imshow(img);
