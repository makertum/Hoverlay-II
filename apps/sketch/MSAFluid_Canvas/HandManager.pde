class HandManager{
  ArrayList<Hand> hands;
  HandManager(){
    hands = new ArrayList<Hand>();
  }
  
  void frame(){
    long now=millis();
    for(int i=0;i<hands.size();i++){
      Hand thisHand=hands.get(i);
      if(thisHand.timeout>0){
        thisHand.age();
        thisHand.frame(i);
      }else{
        hands.remove(i);
        if(i==0 && gloveOn){
          port.write((byte)0);
        }
      }
    }
  }
  
  void update(int _id, float _x, float _y, float _z){
    for(int i=0;i<hands.size();i++){
      Hand thisHand=hands.get(i);
      if(thisHand.id==_id){
        println("updating hand #"+_id);
        thisHand.update(_x,_y,_z);
        return;
      }
    }
    println("adding hand #"+_id);
    hands.add(new Hand(_id,_x,_y,_z));
  }
}
