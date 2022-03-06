import java.util.HashMap;

interface IComponent{
    void Draw();
    
    String getStringValue();
    
    void moveHorizontal(int amount);
}

class Sidebar{
    HashMap<String, IComponent> components =
        new HashMap<String, IComponent>();
        
    ArrayList<Integer> heights = new ArrayList();
    
    int barWidth;
    int position;
    
    int currentY;
    int componentHeight;
    int buttonSep;
    
    int moveSpeed = 10;
    
    Sidebar(int barWidth, int left_or_right, int componentHeight, int buttonSep){
        this.barWidth = barWidth;
        
        if (left_or_right == 0){
            this.position = 0;
        } else {
            this.position = width - barWidth;
        }
        
        this.componentHeight = componentHeight;
        this.buttonSep = buttonSep;
        this.currentY = buttonSep;
    }
    
    void Draw(){
        noStroke();
        fill(0);
        rect(position, 0, barWidth, height);
        
        if (!this.isMouseOver() && position > -barWidth){
            this.position-=moveSpeed;
            
            for (IComponent component : this.components.values()){
                component.moveHorizontal(-moveSpeed);
            }
            
        } else if (this.isMouseOver() && position < 0){
            this.position+=moveSpeed;
            
            for (IComponent component : this.components.values()){
                component.moveHorizontal(moveSpeed);
            }
            
        }
        
        for (IComponent component : this.components.values()){
            component.Draw();
        }
    }
    
    void addButton(String componentName, String label){
        this.components.put(componentName, new Button(label, this.position + 0.125 * this.barWidth, this.currentY, 0.75 * this.barWidth, this.componentHeight));
        
        heights.add(currentY);
        
        currentY += componentHeight + buttonSep;
    }
    
    void addSlider(String componentName, String label, float minVal, float maxVal){
        this.components.put(componentName, new Slider(label, (int) (this.position + 0.125 * this.barWidth), this.currentY, (int) (0.75 * this.barWidth), this.componentHeight, minVal, maxVal));
        
        heights.add(currentY);
        
        currentY += 2*componentHeight + buttonSep;
    }
    
    void addDropList(String componentName, String defaultLabel, ArrayList < String > labels){
        this.components.put(componentName, new DropList((int) (this.position + 0.125 * this.barWidth), this.currentY, (int) (0.75 * this.barWidth), this.componentHeight, defaultLabel, labels));
        
        heights.add(currentY);
        
        currentY += ((2+labels.size()) * componentHeight) + buttonSep;
    }
    
    String getStringValue(String componentName){
        return components.get(componentName).getStringValue();
    }
    
    void mousePressed(){
        Slider slider;
        
        for (IComponent component : this.components.values()){
            if (component instanceof Slider){
                slider = (Slider) component;
                slider.press();
            }
        }
        
        DropList drop;
        
        for (IComponent component : this.components.values()){
            if (component instanceof DropList){
                drop = (DropList) component;
                drop.press();
            }
        }
        
        Button button;
        
        for (IComponent component : this.components.values()){
            if (component instanceof Button){
                button = (Button) component;
                button.press();
            }
        }
    }
    
    void mouseReleased(){
        Slider slider;
        
        for (IComponent component : this.components.values()){
            if (component instanceof Slider){
                slider = (Slider) component;
                slider.release();
            }
        }
    }
    
    boolean isSliderActive(String name){
        Slider slider = (Slider) components.get(name);
        
        return slider.isActive();
    }
    
    boolean isMouseOver(){
        if (mouseX >= (int) this.position && mouseX <= (int) this.position + this.barWidth){
            return true;
        }
        return false;
    }
    
    void removeComponent(String name){
        components.remove(name);   
        currentY = heights.remove(heights.size()-1);
    }
}


/**
 * This class implements a drop list that allows the user to select a value from a list.
 */
class DropList implements IComponent {
    int x, y, w, h;
    ArrayList < String > labels;
    Button dropList;
    int currentlySelected;
    String title;
    Boolean dropped = false;
    
    int animateI;

    DropList(int x, int y, int buttonWidth, int buttonHeight, String defaultLabel, ArrayList < String > labels) {
        this.x = x;
        this.y = y;
        this.w = buttonWidth;
        this.h = buttonHeight;
        this.labels = labels;
        this.title = defaultLabel;
        
        this.animateI = 0;

        dropList = new Button(">", x + w - 20, y, 20, h);
    }
    
    String getStringValue(){
        return Integer.toString(currentlySelected);
    }

    // Draws the droplist on the sketch
    void Draw() {
        noStroke();
        fill(240);
        rect(x, y, w, h, h);
        fill(0);
        text(title, x + ((w - 20) / 2), y + ((h) / 2));

        if (dropped) {
            dropList.drawSelected();
        } else {
            dropList.Draw();
        }

        if (dropped) {
            if (animateI < labels.size()-1){
              animateI++;
            }
          
            int currY = y + h;
            int col = 225;
            for (int i = 0; i <= animateI; i++) {
                fill(col);
                rect(x, currY, w - 20, h, h);
                fill(0);
                text(labels.get(i), x + ((w - 20) / 2), currY + ((h) / 2));
                currY += h;
                col -= (100) / labels.size();
            }
        } else {
            if (animateI >= 0){
              animateI--;
            }
          
            int currY = y + h;
            int col = 225;
            for (int i = 0; i <= animateI; i++) {
                fill(col);
                rect(x, currY, w - 20, h, h);
                fill(0);
                text(labels.get(i), x + ((w - 20) / 2), currY + ((h) / 2));
                currY += h;
                col -= (100) / labels.size();
            }
        }
    }

    // Checks if the button to drop the list has been pressed, and if an element of the list has been selected
    void press() {
        if (dropList.MouseIsOver()) {
            dropped = !dropped;
        }
        
        if (dropped && mouseX > x && mouseX < x + w && mouseY > y + h && mouseY < y + (h * (labels.size() + 1))) {
            this.currentlySelected = ((mouseY - y) / h) - 1;
            title = labels.get(this.currentlySelected);
        }
    }

    // 'Undrops' the droplist
    void unShowDropList() {
        stroke(256);
        fill(225);
        rect(x, y + h, w + 1, 1 + (h * labels.size()));
    }
    
    void moveHorizontal(int amount){
        this.x+=amount;
        dropList.moveHorizontal(amount);
    }
}

/**
 * This class implements a button that can be pressed by the user.
 */
class Button implements IComponent{
    String label;
    float x, y, w, h;

    boolean pressed = false; // indicates if the button has been pressed
    float animationI = 0; // Where the button is in the pressed animation

    // Button constructor
    Button(String label, float x, float y, float w, float h) {
        this.label = label;
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }
    
    String getStringValue(){
        if (this.pressed){
            return "1";
        }
        return "0";
    }

    // Draw the button with default label
    void Draw() {
        noStroke();
        if (this.pressed) {
            this.pressed = false;
        }

        if (animationI > 0) {
            fill(lerpColor(color(200), color(255), (25 - animationI) / 25));
            animationI--;
        } else {
            fill(240);
        }

        textSize(12);
        rect(x, y, w, h, h);
        fill(0);
        text(label, x + (w / 2), y + (h / 2));
    }

    // Draw the button with the passed PImage
    void Draw(PImage image) {
        noStroke();
        fill(225);
        rect(x, y, w, h, h);
        image(image, x, y, w, h);
        fill(0);
    }

    // Draws the button with a darker fill to signify that it has been selected.
    void drawSelected() {
        if (animationI < 8) {
            fill(lerpColor(color(255), color(200), animationI / 8));
            animationI++;
        } else {
            fill(200);
        }

        textSize(12);
        rect(x, y, w, h, h);
        fill(0);
        text(label, x + (w / 2), y + (h / 2));
    }
    
    void press(){
        if (this.MouseIsOver()){
            this.pressed = !this.pressed;
        }
    }

    // Returns a boolean indicating if the mouse was above the button when the mouse was pressed
    boolean MouseIsOver() {
        if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
            return true;
        }
        return false;
    }
    
    void moveHorizontal(int amount){
        this.x+=amount;
    }
}

/**
 * This class implements a slider that can be used by the user to select a value.
 */
class Slider implements IComponent {
    int startX, startY, sliderWidth, sliderHeight;
    float minVal, maxVal;
    int labelSize;
    float sliderX;
    int currentVal;
    String label;
    boolean sliderPressed = false;
    boolean floatOrInt = false;

    // Constructor
    Slider(String label, int startX, int startY, int sliderWidth, int sliderHeight, float minVal, float maxVal) {
        this.startX = startX;
        this.startY = startY;
        this.sliderWidth = sliderWidth;
        this.sliderHeight = sliderHeight;
        this.minVal = minVal;
        this.maxVal = maxVal;
        this.label = label;

        this.currentVal = (int)(minVal + maxVal) / 2;

        sliderX = startX + sliderWidth / 2;
    }
    
    String getStringValue(){
        return "" + getValue();
    }

    // Returns the value of the slider
    float getValue() {
        return currentVal;
    }

    // Draws the slider on the sketch
    void Draw() {
        noStroke();
        if (sliderPressed) {
            press();
        }
        
        fill(255);
        text(label + ": " + getStringValue(), startX + sliderWidth/2, startY - sliderHeight);

        fill(240);
        rect(startX - sliderHeight / 2, startY, sliderWidth + sliderHeight, sliderHeight, sliderHeight);

        fill(100);
        rect(sliderX - sliderHeight / 2, startY, sliderHeight, sliderHeight, sliderHeight);
    }

    // Checks if the slider has been clicked
    void press() {
        if (mouseX > startX && mouseX < startX + sliderWidth) {
            if (mouseY > startY && mouseY < startY + sliderHeight || sliderPressed) {
                sliderPressed = true;
            }
        }

        if (sliderPressed) {
            if (mouseX <= startX + sliderWidth && mouseX >= startX) {
                sliderX = mouseX;
                currentVal = Math.round(map(mouseX, startX, startX + sliderWidth, minVal, maxVal));
                return;
            } else if (mouseX > startX + sliderWidth) {
                sliderX = startX + sliderWidth;
                currentVal = Math.round(maxVal);
                return;
            } else if (mouseX < startX) {
                sliderX = startX;
                currentVal = Math.round(minVal);
                return;
            }
        }
    }

    // Releases the slider so the value change stops
    void release() {
        sliderPressed = false;
    }

    // Updates the position of the slider
    void update() {
        sliderPressed = true;
        sliderX = mouseX;
        currentVal = (int) map(mouseX, sliderX, sliderX + sliderWidth, minVal, maxVal);
    }
    
    boolean isActive(){
        return sliderPressed;
    }
    
    void moveHorizontal(int amount){
        this.startX+=amount;
        this.sliderX+=amount;
    }
}
