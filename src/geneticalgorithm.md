# Genetic Algorithm

This project tries to solve the Traveling Salesman Problem using a
genetic algorithm.

![path](/images/map.svg)
Three solutions the algorithm goes through to get to an optimal path.

## Download
- [Source on Github](https://github.com/BramvdKroef/Traveling-Salesman-Problem)
  
## Usage

This runs the algorithm with an octagon:

    python TravelingSalesman.py 26,2 62,2 87,26 87,62 62,87 26,87 2,62 2,26

You can also let it use random input:

    python TravelingSalesman.py -r

Output a map to an image:

    python TravelingSalesman.py -r -i map.svg




