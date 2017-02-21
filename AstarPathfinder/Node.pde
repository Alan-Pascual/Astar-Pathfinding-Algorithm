import static java.lang.Math.*;

class Node {
  static final int size = 15;
  int x;
  int y;
  float g;
  float f;
  float h;
  Node prev;
  
  Node(int xgiven, int ygiven, Node prevgiven) {
    x = xgiven;
    y = ygiven;
    prev = prevgiven;
    f = 0;
    h = 0;
    g = 0;
  }
  
  void render(color c) {
    fill(c);
    stroke(0);
    rect(x*size,y*size,size-1,size-1);
  }
  
  
  float hcalc(Node begin, Node fin) {
    return sqrt(pow((begin.x - fin.x),2) + pow((begin.y - fin.y),2)) * AstarPathfinder.hscale;
    //return abs(begin.x*20 - fin.x*20) + abs(begin.y*20 - fin.y*20);
  }
  
  void seth(float hgiven) {
    h = hgiven;
    f = g + h;
  }
}