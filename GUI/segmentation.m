clc; clear; close all;
original_img = imread('10.tiff');
I = medfilt2(im2double(original_img));
[M,N]=size(original_img);
av_flt=fspecial('average',[7,7]);

ad_thr=zeros(M,N);
g=ones(32,32);
sum=0;

J=imfilter(I,av_flt,'symmetric','conv');
J2 = adapthisteq(J);

for i=1:1:M-32
    for j=1:1:N-32
        for a=1:32
            for b=1:32
                sum=sum+J2(i+a,j+b);
            end
        end
        mean = sum/(32*32);
        sum=0;
        for a=1:32
            for b=1:32
                if J2(i+a,j+b)>1*mean+0.04
                     ad_thr(i+a,j+b) = ad_thr(i+a,j+b)+1;
%                 elseif I(i+a,j+b)>0.3
%                     ad_thr(i+a,j+b)=1;
                end
            end
        end
    end
end
%%
ad_thr3=ad_thr;
ad_thr3(ad_thr<700)=0;
ad_thr3(ad_thr>=700)=1;
ad_thr4=bwareaopen(ad_thr3,30);
% figure, imshow(ad_thr3);
figure, imshow(imoverlay(I,ad_thr4));

%%
% source=I;
% se = strel('disk',500);
% source = im2double(source);
% background = imopen(source,se);
% % figure, imshow(background)
% I2 = source - background;
% % figure, imshow(I2)
% I3 = adapthisteq(I2);
% % imshow(I3)
% img_bor=imclearborder(I3);
% figure,
% imshow(img_bor,[])
% %%
% roi_img = img_bor;
% mask = roi_img>0.09 & roi_img<0.498;
% mask = imfill(mask,'holes');
% BWfinal_tmp = logical(mask);
% BWfinal_tmp =  bwareafilt(BWfinal_tmp,[20, 5000]);
% figure, imshow(BWfinal_tmp)