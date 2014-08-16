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
      }
    }
  }
  
  void update(int _id, float _x, float _y, float _z){
    for(int i=0;i<hands.size();i++){
      Hand thisHand=hands.get(i);
      if(thisHand.id==_id){
        thisHand.update(_x,_y,_z);
        return;
      }
    }
    hands.add(new Hand(_id,_x,_y,_z));
  }
}
