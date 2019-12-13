%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This code executes breadth first search. This simulation is meant to
%mimick a robot navigating through a grid and planning a path around
%obstacles. The user defines the obstacles, goal, and starting position. 
%This simulation is set up for a 5 x 5 grid that ranges from (0,0) to (5,5).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close
clc

%%%   THIS IS WHERE THE OBSTACLES ARE DEFINED   %%%
% obstacles(1,:)=[2,4];
% obstacles(2,:)=[3,4];
% obstacles(3,:)=[4,2];
% obstacles(4,:)=[4,3];
% obstacles(5,:)=[4,4];
 
% obstacles(1,:)=[1,1];
% obstacles(2,:)=[1,2];
% obstacles(3,:)=[1,3];
% obstacles(4,:)=[2,1];
% obstacles(5,:)=[3,1];

obstacles(1,:)=[4,5];
obstacles(2,:)=[4,1];
obstacles(3,:)=[4,2];
obstacles(4,:)=[4,3];
obstacles(5,:)=[4,4];

%%%   THIS IS WHERE THE STARTING POSITION   %%%
%%%   AND GOAL LOCATION ARE DEFINED         %%%
startingPosition=[0,5];
goal=[5,5];

%Define the colors for plotting the results
obstacleColor=[1,0,0];  %red
nodeColor=[0,1,0];      %green
expandColor=[0,0,0];    %black
goalColor=[0,0,1];      %blue
pathColor=[0,1,1];      %cyan

%Plot the grid and obstacles
scatter(obstacles(:,1),obstacles(:,2),100,obstacleColor,'filled');
grid ;
axis([0 5 0 5]);
hold on;

%Plot the goal position
scatter(goal(1,1),goal(1,2),100,goalColor,'filled');

%Initialize variables
fringeCount=1;  %Used for stepping through the fringe set (keeps track of the current node in the fringe set)
tempCount=1;    %Used for expanding the fringe set (keeps track of the end of the fringe set)

%Initialize the fringe set. The structure is: 
%fringe(xPosition, yPosition, parentNode)
fringe(fringeCount,:)=[startingPosition,fringeCount];

%This loop executes until the goal is found
while (~((fringe(fringeCount,1)==goal(1,1)) && (fringe(fringeCount,2)==goal(1,2))))
    
    %Plot the current node
    scatter(fringe(fringeCount,1),fringe(fringeCount,2),100,nodeColor,'filled');
    
    %Expand the fringe set to the left, right, top and bottom of the current node
    for x=-1:1
        for y=-1:1
            %This is a simple test to ensure that the fringe set isn't
            %expanded diagonally as the robot can not move diagonally
            if (x*y==0)
                
                %'failsTest' is used to determine when a node can not be
                %expanded because it is outside the grid, on an obstacle,
                %or it has already been expanded.
                failsTest=0;
                %'tempNode' is the current node that is trying to be
                %expanded
                tempNode=[fringe(fringeCount,1)+x,fringe(fringeCount,2)+y, fringeCount];

                %Test to see if the node is outside grid
                if ( (tempNode(1,1)<0) | (tempNode(1,2)<0) ) | ( (tempNode(1,1)>5) | (tempNode(1,2)>5) )
                    failsTest=failsTest+1;
                end

                %If it did not fail the first test, test to see if node is
                %already in fringe set.
                if (failsTest<1)
                    for i=1:size(fringe,1)
                        if (tempNode(1,1)==fringe(i,1)) && (tempNode(1,2)==fringe(i,2))
                            failsTest=failsTest+1;
                        end
                    end
                end

                %If it did not fail the previous tests, test to see if node is
                %an obstacle
                if (failsTest<1)
                    for i=1:size(obstacles,1)
                        if (tempNode(1,1)==obstacles(i,1))&&(tempNode(1,2)==obstacles(i,2))
                            failsTest=failsTest+1;
                        end
                    end
                end

                %If it doesn't fail any tests, add to end of fringe set.
                %In breadth first search, nodes are removed from the end of
                %the fring set, so to make things easy we add new nodes to
                %the end.
                if (failsTest<1)
                    fringe(fringeCount+tempCount,:)=tempNode;
                    scatter(tempNode(1,1),tempNode(1,2),100,expandColor,'filled');
                    tempCount=tempCount+1;
                end
            end
        end
    end
    
    %Increment to the next node. When you increment, you must also
    %decrement tempCount since it is defined as a position in the fringe
    %set relative to fringeCount
    fringeCount=fringeCount+1;
    tempCount=tempCount-1;
    pause(.1);
end

%Initialize a counter
i=1;

%Trace back through the parent nodes to receover the path
while ~(fringeCount==1)
    path(i,:)=[fringe(fringeCount,1),fringe(fringeCount,2)];
    fringeCount=fringe(fringeCount,3);
    i=i+1;
end

%Add the start position to the path
path(i,:)=startingPosition;

%Plot the path
plot(path(:,1),path(:,2))
scatter(path(:,1),path(:,2),100,pathColor,'filled');