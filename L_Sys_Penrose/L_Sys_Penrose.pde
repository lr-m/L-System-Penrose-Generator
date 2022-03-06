import java.util.Arrays;

ArrayList<L_System> fractal_generators;

L_System l_system;

boolean dragging = false;
int initialX, initialY;
int toTranslateX = 0, toTranslateY = 0;
boolean initialsSet = false;
int lineLength = 52;
int selected = 0;

int current_iterations = 0;

int mode = 0;

int dragStartX, dragStartY;
int savedLastDragX = 0, savedLastDragY = 0;

Penrose penrose;

Sidebar sidebar;

void setup(){
    fullScreen();
    
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
    
    frameRate(60);
    stroke(0);
    
    initialX = width/2;
    initialY = height/2;
    
    textAlign(CENTER, CENTER);
    
    penrose = new Penrose();
    
    sidebar = new Sidebar(250, 0, 30, 25);
    
    sidebar.addButton("Button:Reset", "Reset");
    sidebar.addButton("Button:Recenter", "Recenter");
    
    sidebar.addDropList("Droplist:Mode", "Select Mode", new ArrayList(Arrays.asList("L-System", "Penrose (P2)")));
    sidebar.addDropList("Droplist:Fractal", "Select L-System", 
        new ArrayList(Arrays.asList("Dragon Curve", "Hexagonal Gosper", 
            "Hilbert", "Von Koch Snowflake", "Crystal", "Triangle", 
            "Square Sierpinski", "Quadratic Koch Island", "Sierpinski Arrowhead", 
            "Rings", "Levy Curve", "Board", "Bush 1", "Bush 2", "Bush 3", "Bush 4", 
            "Stick", "Quad Snowflake", "Pentaplexity", "Tiles", "Krishna Anklets")));
            
    sidebar.addSlider("Slider:Weight", "Line Weight", 1, 10);
    sidebar.addSlider("Slider:Hue", "Line Hue", 0, 255);
    sidebar.addSlider("Slider:Angle", "Angle", 0, 4);
    
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
        fractal_generators.get(selected).Draw((int) Float.parseFloat(sidebar.getStringValue("Slider:Weight")), (int) Float.parseFloat(sidebar.getStringValue("Slider:Hue")), toTranslateX, toTranslateY);
        popMatrix();
    }
    
    sidebar.Draw();
}

int old_val = 0;

void draw(){    
    if (mode == 0){
        if (dragging && !sidebar.isMouseOver()){
            background(0);
            pushMatrix();
            toTranslateX = (mouseX - width/2) - dragStartX + savedLastDragX;
            toTranslateY = (mouseY - height/2) - dragStartY + savedLastDragY;
            translate(toTranslateX, toTranslateY);
            fractal_generators.get(selected).Draw((int) Float.parseFloat(sidebar.getStringValue("Slider:Weight")), (int) Float.parseFloat(sidebar.getStringValue("Slider:Hue")), toTranslateX, toTranslateY);
            popMatrix();
        }  else if (sidebar.isSliderActive("Slider:Weight") || sidebar.isSliderActive("Slider:Hue")) {
            background(0);
            pushMatrix();
            translate(toTranslateX, toTranslateY);
            fractal_generators.get(selected).Draw((int) Float.parseFloat(sidebar.getStringValue("Slider:Weight")), (int) Float.parseFloat(sidebar.getStringValue("Slider:Hue")), toTranslateX, toTranslateY);
            popMatrix();
        } else if (sidebar.isSliderActive("Slider:Angle")) {
            for (L_System l_system : fractal_generators){
                l_system.setStartAngle(90 * (int) Float.parseFloat(sidebar.getStringValue("Slider:Angle")));
            }
            
            background(0);
            pushMatrix();
            translate(toTranslateX, toTranslateY);
            fractal_generators.get(selected).Draw((int) Float.parseFloat(sidebar.getStringValue("Slider:Weight")), (int) Float.parseFloat(sidebar.getStringValue("Slider:Hue")), toTranslateX, toTranslateY);
            popMatrix();
        }
    } else {
         if (dragging && mouseX > 250){
             background(0);
             pushMatrix();
             toTranslateX = (mouseX - width/2) - dragStartX + savedLastDragX;
             toTranslateY = (mouseY - height/2) - dragStartY + savedLastDragY;
             translate(toTranslateX, toTranslateY);
             penrose.Draw((Float.parseFloat(sidebar.getStringValue("Slider:Percolation"))/1000), (int) Float.parseFloat(sidebar.getStringValue("Slider:Hue1")), (int) Float.parseFloat(sidebar.getStringValue("Slider:Hue2")));
             popMatrix();
         }
        
         if (old_val != Float.parseFloat(sidebar.getStringValue("Slider:Percolation"))){
             background(0);
             pushMatrix();
             translate(toTranslateX, toTranslateY);
             penrose.Draw((Float.parseFloat(sidebar.getStringValue("Slider:Percolation"))/1000), (int) Float.parseFloat(sidebar.getStringValue("Slider:Hue1")), (int) Float.parseFloat(sidebar.getStringValue("Slider:Hue2")));
             popMatrix();
             
             old_val = (int) Float.parseFloat(sidebar.getStringValue("Slider:Percolation"));
         }
         
         if (sidebar.isSliderActive("Slider:Hue1") || sidebar.isSliderActive("Slider:Hue2")){
             background(0);
             pushMatrix();
             translate(toTranslateX, toTranslateY);
             penrose.Draw((Float.parseFloat(sidebar.getStringValue("Slider:Percolation"))/1000), (int) Float.parseFloat(sidebar.getStringValue("Slider:Hue1")), (int) Float.parseFloat(sidebar.getStringValue("Slider:Hue2")));
             popMatrix();
         }
    }
    
    sidebar.Draw();
}

void keyPressed(){
    if (keyCode == ' '){
        if (mode == 0){
            fractal_generators.get(selected).iterate();
        } else if (mode == 1){
             penrose.iterate();   
        }
        
        redrawShape();
    } else if (keyCode == 'r'){
        if (mode == 0){
            fractal_generators.get(selected).reset();
            current_iterations = 0;
            
            savedLastDragX = 0;
            savedLastDragY = 0;
            toTranslateX = 0;
            toTranslateY = 0;
            lineLength = 50;
            
            redrawShape();
        }
    } else if (mode == 1){
        penrose.reset();
        redrawShape();
    }
}

void mousePressed(){
    sidebar.mousePressed();
    
    int modeCheck = Integer.parseInt(sidebar.getStringValue("Droplist:Mode"));
    
    if (mode != modeCheck){
         mode = modeCheck;   
         
         updateUI();
         
         redrawShape();
    }
    
    if (!dragging && mouseX > 250) {
        dragging = true;
        dragStartX = (mouseX - width/2);
        dragStartY = (mouseY - height/2);
    } else if (Integer.parseInt(sidebar.getStringValue("Button:Recenter")) == 1){
        savedLastDragX = 0;
        savedLastDragY = 0;
        toTranslateX = 0;
        toTranslateY = 0;
        
        redrawShape();
    }
    
    if (Integer.parseInt(sidebar.getStringValue("Button:Reset")) == 1){
        if (mode == 0){
            fractal_generators.get(selected).reset();
            current_iterations = 0;
            
            savedLastDragX = 0;
            savedLastDragY = 0;
            toTranslateX = 0;
            toTranslateY = 0;
            lineLength = 50;
            
            redrawShape();
        } else if (mode == 1){
            penrose.reset();
            redrawShape();
        }
    } 
    
    if (mode == 0){
        int fractalCheck = Integer.parseInt(sidebar.getStringValue("Droplist:Fractal"));
        
        if (fractalCheck >= 0){
            selected = fractalCheck;
            current_iterations = 0;
            redrawShape();
        }
    }
}

void redrawShape(){
    background(0);
    pushMatrix();
    translate(toTranslateX, toTranslateY);

    if (mode == 0){
        fractal_generators.get(selected).Draw((int) Float.parseFloat(sidebar.getStringValue("Slider:Weight")), (int) Float.parseFloat(sidebar.getStringValue("Slider:Hue")), toTranslateX, toTranslateY);
    } else if (mode == 1){
         penrose.Draw((int) (Float.parseFloat(sidebar.getStringValue("Slider:Percolation"))/1000), (int) Float.parseFloat(sidebar.getStringValue("Slider:Hue1")), (int) Float.parseFloat(sidebar.getStringValue("Slider:Hue2")));  
    }
    
    popMatrix();
    sidebar.Draw();
}

void mouseReleased(){
    sidebar.mouseReleased();
    
    if (dragging){
        dragging = false;
        savedLastDragX = toTranslateX;
        savedLastDragY = toTranslateY;
    }
}

float degreesToRadians(float degrees){
    return (degrees * PI)/180;
}

void updateUI(){
    if (mode == 1){
        sidebar.removeComponent("Slider:Angle");
        sidebar.removeComponent("Slider:Hue");
        sidebar.removeComponent("Slider:Weight");
        sidebar.removeComponent("Droplist:Fractal");
        
        sidebar.addSlider("Slider:Percolation", "Percolation", 1000, 0);
        sidebar.addSlider("Slider:Hue1", "Hue 1", 0, 255);
        sidebar.addSlider("Slider:Hue2", "Hue 1", 0, 255);
    } else {
        sidebar.removeComponent("Slider:Hue2");
        sidebar.removeComponent("Slider:Hue1");
        sidebar.removeComponent("Slider:Percolation");
        
        sidebar.addDropList("Droplist:Fractal", "Select L-System", 
            new ArrayList(Arrays.asList("Dragon Curve", "Hexagonal Gosper", 
                "Hilbert", "Von Koch Snowflake", "Crystal", "Triangle", 
                "Square Sierpinski", "Quadratic Koch Island", "Sierpinski Arrowhead", 
                "Rings", "Levy Curve", "Board", "Bush 1", "Bush 2", "Bush 3", "Bush 4", 
                "Stick", "Quad Snowflake", "Pentaplexity", "Tiles", "Krishna Anklets")));
            
        sidebar.addSlider("Slider:Weight", "Line Weight", 1, 10);
        sidebar.addSlider("Slider:Hue", "Line Hue", 0, 255);
        sidebar.addSlider("Slider:Angle", "Angle", 0, 4);
    }
}
