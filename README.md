# :walking_man::walking_woman: Crowd seating simulation
Netlogo project for Artificial Intelligent Systems-Intelligent Models exam.
##  :pencil: Table of contents
* [Description](#description)
* [How to use](#how-to-use)
* [Setup](#setup)
* [Technologies](#technologies)
* [Bibliography](#bibliography)
* [License](#license)



## :books: Description <a name="description"/>
The goal of the project is to simulate the behavior of a group of people in a theater. It allows to check the actual positioning of people on a set of chairs facing a stage.\
Rules:
* attraction to the stage
* minimum distance from the stage
* maximization distance between neighbors
* find a chair
* layout, number of chairs and individuals are user definable
* individuals cannot cross rows of chairs, but can sit on the right side

The interface graphically show the behavior over time and allow user to modify the parameters in real time. 


## :man_technologist: How to use <a name="how-to-use"/>
Interface shows parameters users can change, they indicate respectively:
* `column`: number of seat
* `n_turtles`: number of people
* `Setup` and `Go` button: to setup world and run program
* `distanza_min`: minimum distance between people
* `peso_palco`: stage weight
* `peso_vicini`: neighbours weight

Every seat has an `attraction` weight, calculated by adding results of both stage weight and neighbours weight function. Turtles are attracted to seat with minimum attraction value, this means that every tick they look for the best place to sit and they compute a "fastest" path to reach it. User can decide to either maximize distance between neighbours or minimize distance from stage, so this means that turtles can choose the seat depending on how far it is from other people or how far it is from stage. If these two parameters are equal turtles just choose place with minimun attraction without a specific criterion. 


## :gear: Setup <a name="setup"/>
To run this project, download Netlogo software or upload the project in Netlogo Web, here is the [link](https://ccl.northwestern.edu/netlogo/download.shtml).


## :computer: Technologies <a name="technologies"/>
Project is created with:
* [Netlogo](https://ccl.northwestern.edu/netlogo/index.shtml)

## :black_nib: Bibliography <a name="bibliography"/>

For the A * star code I took inspiration from:
*  F. Sancho Caparrini, (2018, 16 October). "A General A* Solver in NetLogo". [link](http://www.cs.us.es/~fsancho/?e=131)
* "Models of the course Artificial Intelligence", [Github page](https://github.com/fsancho/IA)

## :balance_scale: License <a name="license"/>
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details


