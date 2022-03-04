import java.util.Arrays;

ArrayList<L_System> fractal_generators;

L_System l_system;

Button reset, recenter;
DropList fractalSelector;
Slider lineWeight, lineHue;
Slider percolation_slider;
Slider penrose_col_1_slider, penrose_col_2_slider;

boolean dragging = false;
int initialX, initialY;
int toTranslateX = 0, toTranslateY = 0;
boolean initialsSet = false;
int lineLength = 50;
int selected = 0;

int current_iterations = 0;

DropList modeSelector;
int mode = 0;

int dragStartX, dragStartY;
int savedLastDragX = 0, savedLastDragY = 0;

Penrose penrose;

void setup(){
    fullScreen();
    
    modeSelector = new DropList(50, 50, 150, 30, "Select Mode", new ArrayList(Arrays.asList("Fractal", "Penrose (P2)")));
    
    fractal_generators = new ArrayList();
    
    HashMap<Character, String> dragon_rules = new HashMap<Character, String>();
    dragon_rules.put('X', "X+YF+");
    dragon_rules.put('Y', "-FX-Y");
    fractal_generators.add(new L_System(width/2, height/2, "FX", dragon_rules, 90, '-', '+', 'F'));
    
    HashMap<Character, String> gosper_rules = new HashMap<Character, String>();
    gosper_rules.put('X', "X+YF++YF-FX--FXFX-YF+");
    gosper_rules.put('Y', "-FX+YFYF++YF+FX--FX-Y");
    fractal_generators.add(new L_System(width/2, height/2, "XF", gosper_rules, 60, '-', '+', 'F'));
    
    HashMap<Character, String> hilbert_rules = new HashMap<Character, String>();
    hilbert_rules.put('X', "-YF+XFX+FY-");
    hilbert_rules.put('Y', "+XF-YFY-FX+");
    fractal_generators.add(new L_System(width/2, height/2, "X", hilbert_rules, 90, '-', '+', 'F'));
    
    HashMap<Character, String> koch_rules = new HashMap<Character, String>();
    koch_rules.put('F', "F-F++F-F");
    fractal_generators.add(new L_System(width/2, height/2, "F++F++F", koch_rules, 60, '-', '+', 'F'));
    
    HashMap<Character, String> crystal_rules = new HashMap<Character, String>();
    crystal_rules.put('F', "FF+F++F+F");
    fractal_generators.add(new L_System(width/2, height/2, "F+F+F+F", crystal_rules, 90, '-', '+', 'F'));
    
    HashMap<Character, String> triangle_rules = new HashMap<Character, String>();
    triangle_rules.put('F', "F-F+F");
    fractal_generators.add(new L_System(width/2, height/2, "F+F+F", triangle_rules, 120, '-', '+', 'F'));
    
    HashMap<Character, String> square_sierpinski_rules = new HashMap<Character, String>();
    square_sierpinski_rules.put('X', "XF-F+F-XF+F+XF-F+F-X");
    fractal_generators.add(new L_System(width/2, height/2, "F+XF+F+XF", square_sierpinski_rules, 90, '-', '+', 'F'));
    
    HashMap<Character, String> quadratic_koch_island_rules = new HashMap<Character, String>();
    quadratic_koch_island_rules.put('F', "F+F-F-FFF+F+F-F");
    fractal_generators.add(new L_System(width/2, height/2, "F+F+F+F", quadratic_koch_island_rules, 90, '-', '+', 'F'));
    
    HashMap<Character, String> sierspinski_arrowhead_rules = new HashMap<Character, String>();
    sierspinski_arrowhead_rules.put('X', "YF+XF+Y");
    sierspinski_arrowhead_rules.put('Y', "XF-YF-X");
    fractal_generators.add(new L_System(width/2, height/2, "YF", sierspinski_arrowhead_rules, 60, '-', '+', 'F'));
    
    HashMap<Character, String> rings_rules = new HashMap<Character, String>();
    rings_rules.put('F', "FF+F+F+F+F+F-F");
    fractal_generators.add(new L_System(width/2, height/2, "F+F+F+F", rings_rules, 90, '-', '+', 'F'));
    
    HashMap<Character, String> levy_curve_rules = new HashMap<Character, String>();
    levy_curve_rules.put('F', "-F++F-");
    fractal_generators.add(new L_System(width/2, height/2, "F", levy_curve_rules, 45, '-', '+', 'F'));
    
    HashMap<Character, String> board_rules = new HashMap<Character, String>();
    board_rules.put('F', "FF+F+F+F+FF");
    fractal_generators.add(new L_System(width/2, height/2, "F+F+F+F", board_rules, 90, '-', '+', 'F'));
    
    lineWeight = new Slider(50, 700, 150, 25, 1, 5);
    lineHue = new Slider(50, 800, 150, 25, 0, 255);
    percolation_slider = new Slider(50, 800, 150, 25, 0, 1000);
    
    penrose_col_1_slider = new Slider(50, 500, 150, 25, 0, 255);
    penrose_col_2_slider = new Slider(50, 650, 150, 25, 0, 255);
    
    frameRate(60);
    stroke(0);
    
    initialX = width/2;
    initialY = height/2;
    
    reset = new Button("Reset",50, height-100, 150, 30);
    recenter = new Button("Recenter",50, height-150, 150, 30);
    fractalSelector = new DropList(50, 150, 150, 30, "Select Fractal", new ArrayList(Arrays.asList("Dragon Curve", "Hexagonal Gosper", "Hilbert", "Von Koch Snowflake", "Crystal", "Triangle", "Square Sierpinski", "Quadratic Koch Island", "Sierpinski Arrowhead", "Rings", "Levy Curve", "Board")));
    
    textAlign(CENTER, CENTER);
    
    penrose = new Penrose();
    
    background(255);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  
  if (e > 0 && lineLength > 6){
      lineLength/=2;
  } else if (e < 0) {
      lineLength*=2;
  }
  
  if (mode == 0){
        background(255);
        pushMatrix();
        translate(toTranslateX, toTranslateY);
        fractal_generators.get(selected).Draw((int) lineWeight.getValue(), (int) lineHue.getValue(), toTranslateX, toTranslateY);
        popMatrix();
    }
    
    drawUI();
}

int old_val = 0;

void draw(){    
    println(dragging);
    if (mode == 0){
        if (dragging && mouseX > 250){
            background(255);
            pushMatrix();
            toTranslateX = (mouseX - width/2) - dragStartX + savedLastDragX;
            toTranslateY = (mouseY - height/2) - dragStartY + savedLastDragY;
            translate(toTranslateX, toTranslateY);
            fractal_generators.get(selected).Draw((int) lineWeight.getValue(), (int) lineHue.getValue(), toTranslateX, toTranslateY);
            popMatrix();
        } else if (lineWeight.isActive() || lineHue.isActive()) {
            background(255);
            pushMatrix();
            translate(toTranslateX, toTranslateY);
            fractal_generators.get(selected).Draw((int) lineWeight.getValue(), (int) lineHue.getValue(), toTranslateX, toTranslateY);
            popMatrix();
        }
    } else {
         if (dragging && mouseX > 250){
             background(255);
             pushMatrix();
             toTranslateX = (mouseX - width/2) - dragStartX + savedLastDragX;
             toTranslateY = (mouseY - height/2) - dragStartY + savedLastDragY;
             translate(toTranslateX, toTranslateY);
             penrose.Draw(percolation_slider.getValue()/1000, penrose_col_1_slider.getValue(), penrose_col_2_slider.getValue());
             popMatrix();
         }
        
         if (old_val != (int) percolation_slider.getValue()){
             background(255);
             pushMatrix();
             translate(toTranslateX, toTranslateY);
             penrose.Draw(percolation_slider.getValue()/1000, penrose_col_1_slider.getValue(), penrose_col_2_slider.getValue());
             popMatrix();
             
             old_val = (int) percolation_slider.getValue();
         }
         
         if (penrose_col_1_slider.isActive() || penrose_col_2_slider.isActive()){
             background(255);
             pushMatrix();
             translate(toTranslateX, toTranslateY);
             penrose.Draw(percolation_slider.getValue()/1000, penrose_col_1_slider.getValue(), penrose_col_2_slider.getValue());
             popMatrix();
         }
    }
    
    drawUI();
}

void keyPressed(){
    if (mode == 0){
        fractal_generators.get(selected).iterate();
    } else if (mode == 1){
         penrose.iterate();   
    }
    
    redrawShape();
}

void drawUI(){
    fill(255);
    stroke(0);
    strokeWeight(1);
    rect(0, 0, 250, height);
    
    if (mode == 0){
        fractalSelector.Draw();
 
        text("Line Weight", 125, 675);
        text("Line Hue", 125, 775);
        lineWeight.display();       
        lineHue.display(); 
        
        recenter.Draw();
    } else {
        fill(0);
        text("Percolation", 125, 775);
        text("Hue 1", 125, 475);
        text("Hue 2", 125, 625);
        
        percolation_slider.display();
        penrose_col_1_slider.display();
        penrose_col_2_slider.display();
    }
    
    reset.Draw();
    modeSelector.Draw();
}

void mousePressed(){
    int modeCheck = modeSelector.checkForPress();
    
    if (mode-1 != modeCheck && modeCheck >= 0){
         mode = modeCheck - 1;   
         redrawShape();
    }
    
    if (!dragging && mouseX > 250) {
        dragging = true;
        dragStartX = (mouseX - width/2);
        dragStartY = (mouseY - height/2);
    } else if (recenter.MouseIsOver()){
        savedLastDragX = 0;
        savedLastDragY = 0;
        toTranslateX = 0;
        toTranslateY = 0;
        
        redrawShape();
    }
    
    if (mode == 0){
        int fractalCheck = fractalSelector.checkForPress();

        if (fractalCheck >= 0){
            selected = fractalCheck-1;
            current_iterations = 0;
            redrawShape();
        } else if (reset.MouseIsOver()){
            fractal_generators.get(selected).reset();
            current_iterations = 0;
            
            savedLastDragX = 0;
            savedLastDragY = 0;
            toTranslateX = 0;
            toTranslateY = 0;
            lineLength = 50;
            
            redrawShape();
        } 
        
        lineWeight.press();
        lineHue.press();
    } else if (mode == 1){
        percolation_slider.press();
        penrose_col_1_slider.press();
        penrose_col_2_slider.press();
        
        if (reset.MouseIsOver()){
            penrose.reset();
            redrawShape();
        }
    }
}

void redrawShape(){
    background(255);
    pushMatrix();
    translate(toTranslateX, toTranslateY);

    if (mode == 0){
        fractal_generators.get(selected).Draw((int) lineWeight.getValue(), (int) lineHue.getValue(), toTranslateX, toTranslateY);
    } else if (mode == 1){
         penrose.Draw(percolation_slider.getValue()/1000, penrose_col_1_slider.getValue(), penrose_col_2_slider.getValue());  
    }
    
    popMatrix();
    drawUI();
}

void mouseReleased(){
    if (dragging){
        dragging = false;
        savedLastDragX = toTranslateX;
        savedLastDragY = toTranslateY;
    }
    
    lineWeight.release();
    lineHue.release();
    percolation_slider.release();
    penrose_col_1_slider.release();
    penrose_col_2_slider.release();
}

float degreesToRadians(int degrees){
    return (degrees * PI)/180;
}
