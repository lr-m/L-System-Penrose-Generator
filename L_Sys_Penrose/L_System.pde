import java.util.HashMap;

class L_System{
    HashMap<Character, String> rules =
        new HashMap<Character, String>();
        
    String currentString;
    String startString;
    int angle;
    char left;
    char right;
    char forwards;
    
    int currDirection = 0;
    int currY, currX;
    int startX, startY;
        
    L_System(int startX, int startY, String axiom, HashMap<Character, String> rules, int angle, char left, char right, char forwards){
        this.startX = startX;
        this.startY = startY;
        
        this.currentString = axiom;
        this.startString = axiom;
        this.rules = rules;
        this.angle = angle;
        
        this.left = left;
        this.right = right;
        this.forwards = forwards;
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
        
        currDirection = 0;
        
        strokeWeight(lineWeight);
        colorMode(HSB);
        
        for (char instruction : this.currentString.toCharArray()){
            if (instruction == this.forwards){
                stroke(hue, 255, 255);
                
                this.goForward(translatedX, translatedY);
            } else if (instruction == this.left){
                this.turnLeft();
            } else if (instruction == this.right){
                this.turnRight();
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
    
    void goForward(int translatedX, int translatedY){
        drawLine(currX, currY, 
            currX += lineLength * Math.round(10 * Math.cos(degreesToRadians(currDirection)))/10, 
            currY += lineLength * Math.round(10 * Math.sin(degreesToRadians(currDirection)))/10, 
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
