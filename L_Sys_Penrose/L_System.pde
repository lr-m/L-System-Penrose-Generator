import java.util.HashMap;
import java.util.Stack;

class State{
    float curr_angle;
    int currY;
    int currX;
    
     State(float curr_angle, int currX, int currY){
         this.curr_angle = curr_angle;
         this.currY = currY;
         this.currX = currX;
     }
     
     int getCurrX(){
          return this.currX;
     }
     
     int getCurrY(){
          return this.currY;
     }
     
     float getCurrAngle(){
          return this.curr_angle;
     }
}

class L_System{
    HashMap<Character, String> rules =
        new HashMap<Character, String>();
        
    Stack<State> state_stack = new Stack<State>();
        
    String currentString;
    String startString;
    float angle;
    char left = '+';
    char right = '-';
    char forwards_with_line = 'F';
    char forwards_without_line = 'f';
    char reverse = '|';
    char push_stack = '[';
    char pop_stack = ']';
    
    float currDirection = -90;
    int currY, currX;
    int startX, startY;
        
    L_System(int startX, int startY, String axiom, HashMap<Character, String> rules, float angle){
        this.startX = startX;
        this.startY = startY;
        
        this.currentString = axiom;
        this.startString = axiom;
        this.rules = rules;
        this.angle = angle;
    }
    
    void iterate(){
        String new_string = "";
        for (char instruction : this.currentString.toCharArray()){
            if (rules.containsKey(instruction)){
                new_string = new_string + rules.get(instruction);
            } else {
                 new_string += instruction;   
            }
        }
        
        this.currentString = new_string;
    }
    
    void Draw(int lineWeight, int hue, int translatedX, int translatedY){
        this.currX = startX;
        this.currY = startY;
        
        strokeWeight(lineWeight);
        
        currDirection = -90;
        
        strokeWeight(lineWeight);
        colorMode(HSB);
        
        for (char instruction : this.currentString.toCharArray()){
            if (instruction == this.forwards_with_line){
                stroke(hue, 255, 255);
                
                this.goForward(translatedX, translatedY);
            } else if (instruction == this.left){
                this.turnLeft();
            } else if (instruction == this.right){
                this.turnRight();
            } else if (instruction == this.push_stack){
                this.pushStack();
            } else if (instruction == this.pop_stack){
                this.popStack();
            } else if (instruction == this.reverse){
                this.reverseDir();
            }
            
        }
    }
    
    void reset(){
        this.currentString = startString;
    }
    
    void turnRight(){
        if (currDirection + angle < 360){
            currDirection += angle;
        } else {
            currDirection = (currDirection + angle) - 360;
        }
    }
    
    void turnLeft(){
        if (currDirection - angle >= 0){
            currDirection -= angle;
        } else {
            currDirection = 360 + (currDirection - angle);
        }
    }
    
    void reverseDir(){
        currDirection = currDirection - 180;
        
        if (currDirection < 0){
             currDirection += 360;   
        }
    }
    
    void pushStack(){
        this.state_stack.push(new State(this.currDirection, this.currX, this.currY));
    }
    
    void popStack(){
        State popped = state_stack.pop();
        this.currDirection = popped.getCurrAngle();
        this.currX = popped.getCurrX();
        this.currY = popped.getCurrY();
    }
    
    void goForward(int translatedX, int translatedY){
        drawLine(currX, currY, 
            currX += lineLength * Math.round(1000 * Math.cos(degreesToRadians(currDirection)))/1000, 
            currY += lineLength * Math.round(1000 * Math.sin(degreesToRadians(currDirection)))/1000, 
            translatedX, translatedY);
    }
    
    void drawLine(float x, float y, float new_x, float new_y, int translatedX, int translatedY){
         if (clipTest(x, y, new_x, new_y, translatedX, translatedY)){
             line(x, y, new_x, new_y);
         }
    }
    
    boolean clipTest(float x, float y, float new_x, float new_y, int translatedX, int translatedY){
        float start_x = x + translatedX;
        float start_y = y + translatedY;
        float end_x = new_x + translatedX;
        float end_y = new_y + translatedY;
        
         if ((start_x < 300 || start_x > width) && (start_y < 0 || start_y > height) && (end_x < 300 || end_x > width) && (end_y < 0 || end_y > height)){
              return false;   
         }
         return true;
    }
}
