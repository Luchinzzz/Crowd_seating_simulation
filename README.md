# Crowd seating simulation
Netlogo project for Artificial Intelligent Systems-Intelligent Models exam.
## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Setup](#setup)

### To do things
Settare il world:
- [x] Chiedere all'utente grandezza palco e numero persone;
- [x] Suddividere il mondo (palco e zona sedie);
- [x] Creare quadrato dove posizionare le sedie;
- [x] Suddividere il quadrato in righe dove l'utente inserisce le sedie;
- [ ] Boh

Modificare comportamento persone:
- [ ] Movimento in base ad attrazione verso il palco (la persona deve cercare il punto più vicino dove sedersi)
- [ ] Distanza minima dal palco
- [ ] Bloccare movimento trapassando file di sedie
- [ ] Massima distanza fra vicini
- [ ] Comet Haley

## General info
Tha goal of the project is to simulate the behavior of a group of people in a theater. It allows to check the actual positioning of people on a set of chairs facing a stage.\
Rules:
* attraction to the stage
* minimum distance from the stage
* maximization distance between neighbors
* find a chair
* layout, number of chairs and individuals are user definable
* individuals cannot cross rows of chairs, but can sit on the right side

The interface must graphically show the behavior over time and allow user to modify the parameters in real time.

## Technologies
Project is created with:
* [Netlogo](https://ccl.northwestern.edu/netlogo/index.shtml)

	
## Setup
To run this project, download Netlogo program or upload the project in Netlogo Web, here is the [link](https://ccl.northwestern.edu/netlogo/download.shtml).

```
$ cd ../lorem
$ npm install
$ npm start
```
