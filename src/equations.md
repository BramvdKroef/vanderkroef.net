# Equations
 
I wrote this to get a better understanding of algebra, and because I
got annoyed with how particular calculators are about entering
equations. The app takes math equations and tries to find the values
for the variables in them. For example:

    x = 10 * 5 / 2
    y * y + x = 100 
    z = a * 5

![Screenshot of the eqations app.](/images/equations1.png)
The results for the entered equations.

The entered problems are parsed into a parse tree. 

The tree is then optimized by solving branches that don't have
variables in them -- e.g. replacing '1 + 1' with '2' -- and minimizing
the number of variables -- e.g. replacing 'x + x' with 'x * 2' -- to
make the next step easier.

Next, for each unknown variable a copy of the tree is reordered so
that the variable is the only thing on one side of the equation. 

<div class="figure">

![Image of an equation parsed into a tree.](/images/calc1.svg)
![Image of an optimized version of the equation in the previous image.](/images/calc2.svg)
![Image of the optimized equation altered to show the value for x.](/images/calc3.svg)

Example using the lines 'y = 20' and '5 * y = 50 + x * x'.

</div>

## Download

- [Source on Github](https://github.com/BramvdKroef/Equations)
- [Compiled .jar](/files/equations.jar)

## Usage

It is written in Java so it requires a JRE
Most systems already have it installed but if you don't have it you
can get it from [Java.com](http://www.java.com).

Just download the .jar file and run it like you would any app. You can
also run it from a terminal with this command:

    java -jar equations.jar

Enter any formulas and equations in the top text box and the results
will be displayed in the bottom text box as you type.


