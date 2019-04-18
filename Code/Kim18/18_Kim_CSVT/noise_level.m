function [ he ] = noise_level( p1,p2,p3,p4 )

he = abs(p1-p2)+abs(p2-p3)+abs(p3-p4)+abs(p4-p1)+abs(p1-p3)+abs(p2-p4);



end

