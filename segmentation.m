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
th_thmap=ad_thr;
th_thmap(ad_thr<500)=0;
th_thmap(ad_thr>=500)=1;
%% 모폴로지 연산
result1=bwareaopen(th_thmap,30);
result2=bwareaopen(th_thmap,40);
result3=bwareaopen(th_thmap,50);
result4=bwareaopen(th_thmap,60);
result5=bwareaopen(th_thmap,70);

figure, imshow(imoverlay(I,th_thmap)), title('non morphology');
figure, imshow(imoverlay(I,result1)), title('areaopen size : 30');
figure, imshow(imoverlay(I,result2)), title('areaopen size : 40');
figure, imshow(imoverlay(I,result3)), title('areaopen size : 50');
figure, imshow(imoverlay(I,result4)), title('areaopen size : 60');
figure, imshow(imoverlay(I,result5)), title('areaopen size : 70');
%%
se1 = strel('disk',5);
se2 = strel('disk',6);
se3 = strel('disk',7);
se4 = strel('disk',8);
se5 = strel('disk',9);
result1=imopen(th_thmap,se1);
result2=imopen(th_thmap,se2);
result3=imopen(th_thmap,se3);
result4=imopen(th_thmap,se4);
result5=imopen(th_thmap,se5);

figure, imshow(imoverlay(I,th_thmap)), title('non morphology');
figure, imshow(imoverlay(I,result1)), title('imopen size : 5');
figure, imshow(imoverlay(I,result2)), title('imopen size : 6');
figure, imshow(imoverlay(I,result3)), title('imopen size : 7');
figure, imshow(imoverlay(I,result4)), title('imopen size : 8');
figure, imshow(imoverlay(I,result5)), title('imopen size : 9');
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