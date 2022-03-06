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
    
    modeSelector = new DropList(25, 50, 200, 30, "Select Mode", new ArrayList(Arrays.asList("L-System", "Penrose (P2)")));
    
    fractal_generators = new ArrayList();
    
    HashMap<Character, String> dragon_rules = new HashMap<Character, String>();
    dragon_rules.put('X', "X+YF+");
    dragon_rules.put('Y', "-FX-Y");
    fractal_generators.add(new L_System(width/2, height/2, "FX", dragon_rules, 90));
    
    HashMap<Character, String> gosper_rules = new HashMap<Character, String>();
    gosper_rules.put('X', "X+YF++YF-FX--FXFX-YF+");
    gosper_rules.put('Y', "-FX+YFYF++YF+FX--FX-Y");
    fractal_generators.add(new L_System(width/2, height/2, "XF", gosper_rules, 60));
    
    HashMap<Character, String> hilbert_rules = new HashMap<Character, String>();
    hilbert_rules.put('X', "-YF+XFX+FY-");
    hilbert_rules.put('Y', "+XF-YFY-FX+");
    fractal_generators.add(new L_System(width/2, height/2, "X", hilbert_rules, 90));
    
    HashMap<Character, String> koch_rules = new HashMap<Character, String>();
    koch_rules.put('F', "F-F++F-F");
    fractal_generators.add(new L_System(width/2, height/2, "F++F++F", koch_rules, 60));
    
    HashMap<Character, String> crystal_rules = new HashMap<Character, String>();
    crystal_rules.put('F', "FF+F++F+F");
    fractal_generators.add(new L_System(width/2, height/2, "F+F+F+F", crystal_rules, 90));
    
    HashMap<Character, String> triangle_rules = new HashMap<Character, String>();
    triangle_rules.put('F', "F-F+F");
    fractal_generators.add(new L_System(width/2, height/2, "F+F+F", triangle_rules, 120));
    
    HashMap<Character, String> square_sierpinski_rules = new HashMap<Character, String>();
    square_sierpinski_rules.put('X', "XF-F+F-XF+F+XF-F+F-X");
    fractal_generators.add(new L_System(width/2, height/2, "F+XF+F+XF", square_sierpinski_rules, 90));
    
    HashMap<Character, String> quadratic_koch_island_rules = new HashMap<Character, String>();
    quadratic_koch_island_rules.put('F', "F+F-F-FFF+F+F-F");
    fractal_generators.add(new L_System(width/2, height/2, "F+F+F+F", quadratic_koch_island_rules, 90));
    
    HashMap<Character, String> sierspinski_arrowhead_rules = new HashMap<Character, String>();
    sierspinski_arrowhead_rules.put('X', "YF+XF+Y");
    sierspinski_arrowhead_rules.put('Y', "XF-YF-X");
    fractal_generators.add(new L_System(width/2, height/2, "YF", sierspinski_arrowhead_rules, 60));
    
    HashMap<Character, String> rings_rules = new HashMap<Character, String>();
    rings_rules.put('F', "FF+F+F+F+F+F-F");
    fractal_generators.add(new L_System(width/2, height/2, "F+F+F+F", rings_rules, 90));
    
    HashMap<Character, String> levy_curve_rules = new HashMap<Character, String>();
    levy_curve_rules.put('F', "-F++F-");
    fractal_generators.add(new L_System(width/2, height/2, "F", levy_curve_rules, 45));
    
    HashMap<Character, String> board_rules = new HashMap<Character, String>();
    board_rules.put('F', "FF+F+F+F+FF");
    fractal_generators.add(new L_System(width/2, height/2, "F+F+F+F", board_rules, 90));
    
    HashMap<Character, String> bush1_rules = new HashMap<Character, String>();
    bush1_rules.put('X', "X[-FFF][+FFF]FX");
    bush1_rules.put('Y', "YFX[+Y][-Y]");
    fractal_generators.add(new L_System(width/2, height/2, "Y", bush1_rules, 25.7));
    
    HashMap<Character, String> bush2_rules = new HashMap<Character, String>();
    bush2_rules.put('F', "FF+[+F-F-F]-[-F+F+F]");
    fractal_generators.add(new L_System(width/2, height/2, "F", bush2_rules, 22.5));
    
    HashMap<Character, String> bush3_rules = new HashMap<Character, String>();
    bush3_rules.put('F', "F[+FF][-FF]F[-F][+F]F");
    fractal_generators.add(new L_System(width/2, height/2, "F", bush3_rules, 35));
    
    HashMap<Character, String> bush4_rules = new HashMap<Character, String>();
    bush4_rules.put('V', "[+++W][---W]YV");
    bush4_rules.put('W', "+X[-W]Z");
    bush4_rules.put('X', "-W[+X]Z");
    bush4_rules.put('Y', "YZ");
    bush4_rules.put('Z', "[-FFF][+FFF]F");
    fractal_generators.add(new L_System(width/2, height/2, "VZFFF", bush4_rules, 20));
    
    HashMap<Character, String> stick_rules = new HashMap<Character, String>();
    stick_rules.put('F', "FF");
    stick_rules.put('X', "F[+X]F[-X]+X");
    fractal_generators.add(new L_System(width/2, height/2, "X", stick_rules, 20));
    
    HashMap<Character, String> quad_snowflake_rules = new HashMap<Character, String>();
    quad_snowflake_rules.put('F', "F+F-F-F+F");
    fractal_generators.add(new L_System(width/2, height/2, "FF+FF+FF+FF", quad_snowflake_rules, 90));
    
    HashMap<Character, String> pentaplexity_rules = new HashMap<Character, String>();
    pentaplexity_rules.put('F', "F++F++F|F-F++F");
    fractal_generators.add(new L_System(width/2, height/2, "F++F++F++F++F", pentaplexity_rules, 36));
    
    HashMap<Character, String> tiles_rules = new HashMap<Character, String>();
    tiles_rules.put('F', "FF+F-F+F+FF");
    fractal_generators.add(new L_System(width/2, height/2, "F+F+F+F", tiles_rules, 90));
    
    HashMap<Character, String> anklets_rules = new HashMap<Character, String>();
    anklets_rules.put('X', "XFX--XFX");
    fractal_generators.add(new L_System(width/2, height/2, "-X--X", anklets_rules, 45));
    
    lineWeight = new Slider(50, 900, 150, 25, 1, 10);
    lineHue = new Slider(50, 1000, 150, 25, 0, 255);
    percolation_slider = new Slider(50, 800, 150, 25, 1000, 0);
    
    penrose_col_1_slider = new Slider(50, 500, 150, 25, 0, 255);
    penrose_col_2_slider = new Slider(50, 650, 150, 25, 0, 255);
    
    frameRate(60);
    stroke(0);
    
    initialX = width/2;
    initialY = height/2;
    
    reset = new Button("Reset",25, height-100, 200, 30);
    recenter = new Button("Recenter",25, height-150, 200, 30);
    fractalSelector = new DropList(25, 150, 200, 30, "Select L-System", 
        new ArrayList(Arrays.asList("Dragon Curve", "Hexagonal Gosper", 
            "Hilbert", "Von Koch Snowflake", "Crystal", "Triangle", 
            "Square Sierpinski", "Quadratic Koch Island", "Sierpinski Arrowhead", 
            "Rings", "Levy Curve", "Board", "Bush 1", "Bush 2", "Bush 3", "Bush 4", 
            "Stick", "Quad Snowflake", "Pentaplexity", "Tiles", "Krishnas Ankles")));
    
    textAlign(CENTER, CENTER);
    
    penrose = new Penrose();
    
    background(0);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  
  if (e > 0 && lineLength - 4 >= 4) {
      lineLength -= 4;
  } else if (e < 0 && lineLength + 4 < 200){
      lineLength = lineLength + 4;
  } 
  
  if (mode == 0){
        background(0);
        pushMatrix();
        translate(toTranslateX, toTranslateY);
        fractal_generators.get(selected).Draw((int) lineWeight.getValue(), (int) lineHue.getValue(), toTranslateX, toTranslateY);
        popMatrix();
    }
    
    drawUI();
}

int old_val = 0;

void draw(){    
    if (mode == 0){
        if (dragging && mouseX > 250){
            background(0);
            pushMatrix();
            toTranslateX = (mouseX - width/2) - dragStartX + savedLastDragX;
            toTranslateY = (mouseY - height/2) - dragStartY + savedLastDragY;
            translate(toTranslateX, toTranslateY);
            fractal_generators.get(selected).Draw((int) lineWeight.getValue(), (int) lineHue.getValue(), toTranslateX, toTranslateY);
            popMatrix();
        } else if (lineWeight.isActive() || lineHue.isActive()) {
            background(0);
            pushMatrix();
            translate(toTranslateX, toTranslateY);
            fractal_generators.get(selected).Draw((int) lineWeight.getValue(), (int) lineHue.getValue(), toTranslateX, toTranslateY);
            popMatrix();
        }
    } else {
         if (dragging && mouseX > 250){
             background(0);
             pushMatrix();
             toTranslateX = (mouseX - width/2) - dragStartX + savedLastDragX;
             toTranslateY = (mouseY - height/2) - dragStartY + savedLastDragY;
             translate(toTranslateX, toTranslateY);
             penrose.Draw(percolation_slider.getValue()/1000, penrose_col_1_slider.getValue(), penrose_col_2_slider.getValue());
             popMatrix();
         }
        
         if (old_val != (int) percolation_slider.getValue()){
             background(0);
             pushMatrix();
             translate(toTranslateX, toTranslateY);
             penrose.Draw(percolation_slider.getValue()/1000, penrose_col_1_slider.getValue(), penrose_col_2_slider.getValue());
             popMatrix();
             
             old_val = (int) percolation_slider.getValue();
         }
         
         if (penrose_col_1_slider.isActive() || penrose_col_2_slider.isActive()){
             background(0);
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
 
        text("Line Weight", 125, 875);
        text("Line Hue", 125, 975);
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
    background(0);
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

float degreesToRadians(float degrees){
    return (degrees * PI)/180;
}
