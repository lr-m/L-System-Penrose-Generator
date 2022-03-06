/**
 * This class implements a drop list that allows the user to select a value from a list.
 */
class DropList {
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
    int checkForPress() {
        int toReturn = -2;
        
        if (dropList.MouseIsOver()) {
            dropped = !dropped;
            toReturn = -1;
        }
        
        if (dropped && mouseX > x && mouseX < x + w && mouseY > y + h && mouseY < y + (h * (labels.size() + 1))) {
            toReturn = (mouseY - y) / h;
            title = labels.get(toReturn - 1);
        }
        return toReturn;
    }

    // 'Undrops' the droplist
    void unShowDropList() {
        stroke(256);
        fill(225);
        rect(x, y + h, w + 1, 1 + (h * labels.size()));
    }
}

/**
 * This class implements a button that can be pressed by the user.
 */
class Button {
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

    // Draw the button with default label
    void Draw() {
        noStroke();
        if (pressed) {
            pressed = false;
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
        if (pressed == true) {
            if (animationI < 8) {
                fill(lerpColor(color(255), color(200), animationI / 8));
                animationI++;
            } else {
                fill(200);
            }
        }

        textSize(12);
        rect(x, y, w, h, h);
        fill(0);
        text(label, x + (w / 2), y + (h / 2));
    }

    // Returns a boolean indicating if the mouse was above the button when the mouse was pressed
    boolean MouseIsOver() {
        if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
            pressed = true;
            return true;
        }
        return false;
    }
}

/**
 * This class implements a slider that can be used by the user to select a value.
 */
class Slider {
    int startX, startY, sliderWidth, sliderHeight;
    float minVal, maxVal;
    int labelSize;
    float sliderX;
    int currentVal;
    String label;
    boolean sliderPressed = false;
    boolean floatOrInt = false;

    // Constructor
    Slider(int startX, int startY, int sliderWidth, int sliderHeight, float minVal, float maxVal) {
        this.startX = startX;
        this.startY = startY;
        this.sliderWidth = sliderWidth;
        this.sliderHeight = sliderHeight;
        this.minVal = minVal;
        this.maxVal = maxVal;

        this.currentVal = (int)(minVal + maxVal) / 2;

        sliderX = startX + sliderWidth / 2;
    }

    // Returns the value of the slider
    float getValue() {
        return currentVal;
    }

    // Draws the slider on the sketch
    void display() {
        noStroke();
        if (sliderPressed) {
            press();
        }

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
}
