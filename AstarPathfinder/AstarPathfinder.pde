Node[][] grid;
ArrayList<Node> closedset = new ArrayList<Node>();
ArrayList<Node> openset = new ArrayList<Node>();
ArrayList<Node> finalset = new ArrayList<Node>();
Node start;
Node end;
Node current;
Node neighbor;
//Node last;
boolean complete = false;
boolean running = false;
boolean leftpressed = false;
boolean rightpressed = false;
boolean mode1 = true;
boolean mode2 = false;
int totaldistance = 0;
int check;
float testg;
static float hscale = 1.8;
int step = -1;
int ml;
int mt;

void setup() {
  size(600,600);
  background(0);
  grid = new Node[width/Node.size][height/Node.size];
  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid[0].length; j++) {
      //if (random(100) < 70 || (i == 0 && j == 0) || (i == grid.length-1 && j == grid[0].length-1)) {
      grid[i][j] = new Node(i,j,null);
      //} else {
      //  grid[i][j] = null;
      //}
    }
  }
  start = grid[0][0];
  end = grid[grid.length-1][grid[0].length-1];
  start.h = start.hcalc(start, end);
  start.f = start.h;
  openset.add(start);
  frameRate(60);
}

void draw() {
  background(0);
  if (openset.size() > 0 && complete == false && running == true) {
    step += 1;
    
    current = openset.get(0);
    for(Node temp : openset) {
      if (temp.f < current.f) {
        current = temp;
      }
    }
    
    //System.out.printf("f : %s, g : %s, h : %s\n",current.f,current.g,current.h); 
    
    //if (last != null && last.h < current.h) {   illegal
    //  System.out.printf("Last h was %s, Current h is %s",last.h, current.h);
    //  for (Node temp : openset) {
    //    if (temp != start) {
    //      temp.seth(start.h);
    //    }
    //  }
    //  for(Node temp : openset) {
    //    if (temp.f < current.f) {
    //      current = temp;
    //    }
    //  }
    //}
    
    if (current.x == end.x && current.y == end.y) {
      complete = true;
      while (current.prev != null) {
        finalset.add(current);
        current = current.prev;
        totaldistance += 1;
      }
      finalset.add(current);
    }
    
    openset.remove(current);
    closedset.add(current);
    
    for (int i = current.x-1; i <= current.x + 1; i++) {
      if (i >= 0 && i < grid.length) {
        for (int j = current.y-1; j <= current.y + 1; j++) {
          check = current.x - i + current.y - j;
          if (j >= 0 && j < grid[0].length && (check == -1 || check == 1) && grid[i][j] != null) {
            neighbor = grid[i][j];
            
            if (closedset.contains(neighbor)) {
              continue;
            }
            
            testg = current.g + 1;
            if (!openset.contains(neighbor)) {
              openset.add(neighbor);
            } else if (testg >= neighbor.g) {
              continue;
            }
            
            neighbor.prev = current;
            //last = current;
            neighbor.g = testg;
            neighbor.h = neighbor.hcalc(neighbor, end);
            neighbor.f = neighbor.g + neighbor.h;
          }
        }
      }
    }
  } else if (running == true) {
    if (complete == false) {
      System.out.printf("Failure, steps: %s\n", step);
      complete = true;
    } else {
      System.out.printf("Success, steps: %s, distance: %s \n", step, totaldistance);
    }
    running = false;
  }
  
  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid[0].length; j++) {
      if (grid[i][j] != null) {
        grid[i][j].render(color(255));
      }
    }
  }
  
  for(Node temp : closedset) {
    temp.render(color(#00C108));
  }
  
  for(Node temp : openset) {
    temp.render(color(#C1001A));
  }
  
  for(Node temp : finalset) {
    temp.render(color(#001EC1));
  }
  
  if (mode1) {
    fill(0,150);
  } else if (mode2) {
    fill(255,150);
  }
  rectMode(CENTER);
  rect(mouseX,mouseY,Node.size-1, Node.size-1);
  rectMode(CORNER);
  
  if (leftpressed == true && running == false && complete == false) {
    ml = mouseX / Node.size;
    mt = mouseY / Node.size;
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {
        if (i == ml && j == mt && !(i == start.x && j == start.y) && !(i == end.x && j == end.y)) {
          if (mode1) {
            grid[i][j] = null;
          } else if (mode2 && grid[i][j] != null) {
            openset.remove(start);
            start = grid[i][j];
            openset.add(start);
          }
        }
      }
    }
  }
  
  if (rightpressed == true && running == false && complete == false) {
    ml = mouseX / Node.size;
    mt = mouseY / Node.size;
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {
        if (i == ml && j == mt && !(i == start.x && j == start.y) && !(i == end.x && j == end.y)) {
          if (mode1) {
            grid[i][j] = new Node(i,j,null);
          } else if (mode2 && grid[i][j] != null) {
            end = grid[i][j];
          }
        }
      }
    }
  }
  
  start.render(#00F4FF);
  end.render(#FAFF00);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    leftpressed = true;
  } else if (mouseButton == RIGHT) {
    rightpressed = true;
  } else if (mouseButton == CENTER) {
    mode1 = !mode1;
    mode2 = !mode2;
  }
}

void mouseReleased() {
  leftpressed = false;
  rightpressed = false;
}

void keyPressed() {
  if (key == ' ' && complete == false) {
    running = true;
  } else if (key == 'c') {
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[0].length; j++) {
        if (grid[i][j] != start && grid[i][j] != end) {
          grid[i][j] = new Node(i,j,null);
        }
      }
    }
    
    openset.clear();
    openset.add(start);
    closedset.clear();
    finalset.clear();
    //last = null;
    complete = false;
    step = -1;
    totaldistance = 0;
    running = false;
  } else if (key == 'm') {
    mode1 = !mode1;
    mode2 = !mode2;
  } else if (key == 'r') {
    openset.clear();
    openset.add(start);
    closedset.clear();
    finalset.clear();
    complete = false;
    step = -1;
    totaldistance = 0;
    running = false;
  } else if (key == 'a' && !running) {
    hscale += 0.1;
    System.out.printf("New hscale = %s\n", hscale);
  } else if (key == 'd' && !running) {
    hscale -= 0.1;
    System.out.printf("New hscale = %s\n", hscale);
  }
}