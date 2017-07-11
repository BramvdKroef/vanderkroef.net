# Celtic Knots

![Example of a Celtic knot.](/images/knot1.png)

This app will let design your own celtic knot. It is a project
that I made when I found out about a simple way to draw them. It turned
into an interesting exercise with Bézier curves.

Sharp angles are supported as well as curved lines. The background and
foreground colors can be changed with JColorChooser dialog. Line
interlacing can be turned on and off.

The app is made by extending JComponent to make nodes that draw a
line section. The nodes are laid out in a container using GridLayout.

## Download
- [Source on Github](https://github.com/BramvdKroef/Celtic-Knots)
- [Compiled .jar](/files/celticknots.jar)

## Usage
It is written in Java so it requires a JRE
Most systems already have it installed but if you don't have it you
can get it from [Java.com](http://www.java.com). 

Just download the .jar file and run it like you would any app. You can
also run it from a terminal with this command:

    java -jar celticknots.jar


![Screenshot of the Knot editor.](/images/knot2.png)
Running the app.

Click on two adjacent dots to break the lines that run between them. A
dot will turn red when you click on it. When you click the next dot
the lines running between the dots are broken. If you click on a dot
that isn't adjacent to the first then that dot will turn red instead.

