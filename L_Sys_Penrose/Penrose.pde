class Penrose {
    ArrayList < IShape > subshapes;

    Penrose() {
        subshapes = new ArrayList();

        int radius = 750;

        subshapes.add(new Sun(width / 2, height / 2, radius));
        
        iterate();
    }

    void Draw(float prob, float hue_1, float hue_2) {
        fill(255);
        stroke(0);
        strokeWeight(2);
        
        for (IShape shape: subshapes) {
            shape.Draw(prob, hue_1, hue_2);
        }
    }
    
    void iterate(){
        subshapes.get(0).subdivide();
    }
    
    void reset(){
        for (IShape shape: subshapes) {
            shape.reset();
        }
    }
}

interface IShape {
    float GOLDEN = 1.6180339;
    float INV_GOLDEN = 0.6180339;

    void Draw(float prob, float hue_1, float hue_2);
    void subdivide();
    void reset();
}

class Half_Kite implements IShape {
    ArrayList < Integer > points;
    ArrayList < IShape > subshapes;

    Half_Kite(ArrayList < Integer > point_list) {
        this.points = point_list;
        this.subshapes = new ArrayList();
    }

    void Draw(float prob, float hue_1, float hue_2) {
        fill(hue_2, 255, 255);
        colorMode(HSB);
        
        if (subshapes.size() == 0) {
            //triangle(points.get(0), points.get(1), points.get(2), points.get(3), points.get(4), points.get(5));
            
            if (random(1) < prob){
                 triangle(points.get(0), points.get(1), points.get(2), points.get(3), points.get(4), points.get(5));   
            }
        } else {
            for (IShape shape: subshapes) {
                shape.Draw(prob, hue_1, hue_2);
            }
        }
    }

    void subdivide() {
        if (subshapes.size() == 0) {
            ArrayList < Integer > point_list = new ArrayList(Arrays.asList(
                points.get(4), points.get(5),
                (int)(points.get(0) + INV_GOLDEN * (points.get(2) - points.get(0))), (int)(points.get(1) + (INV_GOLDEN * (points.get(3) - points.get(1)))),
                points.get(2), points.get(3)
            ));

            this.subshapes.add(new Half_Kite(point_list));

            point_list = new ArrayList(
                Arrays.asList(
                    points.get(4), points.get(5),
                    (int)(points.get(0) + INV_GOLDEN * (points.get(2) - points.get(0))), (int)(points.get(1) + (INV_GOLDEN * (points.get(3) - points.get(1)))),
                    (int)(points.get(0) + (1 - INV_GOLDEN) * (points.get(4) - points.get(0))), (int)(points.get(1) + ((1 - INV_GOLDEN) * (points.get(5) - points.get(1))))
                ));

            this.subshapes.add(new Half_Kite(point_list));

            point_list = new ArrayList(
                Arrays.asList((int)(points.get(0) + INV_GOLDEN * (points.get(2) - points.get(0))), (int)(points.get(1) + (INV_GOLDEN * (points.get(3) - points.get(1)))),
                    (int)(points.get(0) + (1 - INV_GOLDEN) * (points.get(4) - points.get(0))), (int)(points.get(1) + ((1 - INV_GOLDEN) * (points.get(5) - points.get(1)))),
                    points.get(0), points.get(1)));

            this.subshapes.add(new Half_Dart(point_list));

        } else {
            for (IShape shape: subshapes) {
                shape.subdivide();
            }
        }
    }
    
    void reset(){
        for (IShape shape: subshapes) {
            shape.reset();
        }
        
        subshapes.clear();
    }
}

class Half_Dart implements IShape {
    ArrayList < Integer > points;
    ArrayList < IShape > subshapes;
    int dir;

    Half_Dart(ArrayList < Integer > point_list) {
        this.points = point_list;
        this.subshapes = new ArrayList();
    }

    void Draw(float prob, float hue_1, float hue_2) {
        if (subshapes.size() == 0) {
            fill(hue_1, 255, 255);
            //triangle(points.get(0), points.get(1), points.get(2), points.get(3), points.get(4), points.get(5));

            if (random(1) < prob){
                 triangle(points.get(0), points.get(1), points.get(2), points.get(3), points.get(4), points.get(5));   
            }
        } else {
            for (IShape shape: subshapes) {
                shape.Draw(prob, hue_1, hue_2);
            }
        }
    }

    void subdivide() {
        if (subshapes.size() == 0) {
            ArrayList < Integer > point_list = new ArrayList(Arrays.asList(
                points.get(4), points.get(5),
                points.get(2), points.get(3),
                (int)(points.get(0) + (1 - INV_GOLDEN) * (points.get(4) - points.get(0))), (int)(points.get(1) + ((1 - INV_GOLDEN) * (points.get(5) - points.get(1))))
            ));

            this.subshapes.add(new Half_Kite(point_list));

            point_list = new ArrayList(Arrays.asList(
                points.get(2), points.get(3),
                (int)(points.get(0) + (1 - INV_GOLDEN) * (points.get(4) - points.get(0))), (int)(points.get(1) + ((1 - INV_GOLDEN) * (points.get(5) - points.get(1)))),
                points.get(0), points.get(1)
            ));

            this.subshapes.add(new Half_Dart(point_list));

        } else {
            for (IShape shape: subshapes) {
                shape.subdivide();
            }
        }
    }
    
    void reset(){
        for (IShape shape: subshapes) {
            shape.reset();
        }
        
        subshapes.clear();
    }
}

class Sun implements IShape {
    ArrayList < IShape > subshapes = new ArrayList();
    
    float tiles = 10;
    float angle = 360/tiles;
    
    Sun(int x, int y, int radius) {
        for (int i = 0; i < tiles; i++) {
            ArrayList < Integer > point_list;
            if (i % 2 == 0) {
                point_list = new ArrayList(Arrays.asList((int) x, (int) y,
                    (int)(x + (radius * Math.cos(i * angle * PI / 180))), (int)(y + (radius * Math.sin(i * angle * PI / 180))),
                    (int)(x + (radius * Math.cos((i + 1) * angle * PI / 180))), (int)(y + (radius * Math.sin((i + 1) * angle * PI / 180)))));
            } else {
                point_list = new ArrayList(Arrays.asList((int) x, (int) y,
                    (int)(x + (radius * Math.cos((i + 1) * angle * PI / 180))), (int)(y + (radius * Math.sin((i + 1) * angle * PI / 180))),
                    (int)(x + (radius * Math.cos(i * angle * PI / 180))), (int)(y + (radius * Math.sin(i * angle * PI / 180)))
                ));
            }

            subshapes.add(new Half_Kite(point_list));
        }
    }

    void Draw(float prob, float hue_1, float hue_2) {
        for (IShape shape: subshapes) {
            shape.Draw(prob, hue_1, hue_2);
        }
    }

    void subdivide() {
        for (IShape shape: subshapes) {
            shape.subdivide();
        }
    }
    
    void reset(){
        for (IShape shape: subshapes) {
            shape.reset();
        }
    }
}

//class Star implements IShape{
//    ArrayList < IShape > subshapes = new ArrayList();

//    Star(int x, int y, int radius) {
//        for (int i = 0; i < 10; i++) {
//            ArrayList < Integer > point_list;
//            if (i % 2 == 0) {
//                point_list = new ArrayList(Arrays.asList((int) x, (int) y,
//                    (int)(x + (radius * Math.cos(i * 36 * PI / 180))), (int)(y + (radius * Math.sin(i * 36 * PI / 180))),
//                    (int)(x + (radius * Math.cos((i + 1) * 36 * PI / 180))), (int)(y + (radius * Math.sin((i + 1) * 36 * PI / 180)))));
//            } else {
//                point_list = new ArrayList(Arrays.asList((int) x, (int) y,
//                    (int)(x + (radius * Math.cos((i + 1) * 36 * PI / 180))), (int)(y + (radius * Math.sin((i + 1) * 36 * PI / 180))),
//                    (int)(x + (radius * Math.cos(i * 36 * PI / 180))), (int)(y + (radius * Math.sin(i * 36 * PI / 180)))
//                ));
//            }



//            subshapes.add(new Half_Kite(point_list));
//        }
//        println(subshapes.size());
//    }

//    void Draw() {
//        for (IShape shape: subshapes) {
//            shape.Draw();
//        }
//    }

//    void subdivide() {
//        for (IShape shape: subshapes) {
//            shape.subdivide();
//        }
//    }
//}
