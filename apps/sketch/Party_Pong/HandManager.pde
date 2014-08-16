class HandManager {
  ArrayList<Hand> hands;
  HandManager() {
    hands = new ArrayList<Hand>();
  }

  void frame() {
    long now=millis();
    for (int i=0; i<hands.size (); i++) {
      Hand thisHand=hands.get(i);
      if (thisHand.timeout>0) {
        thisHand.age();
        thisHand.frame(i);
      } else {
        hands.remove(i);
        if (i==0 && gloveOn) {
          port.write((byte)0);
        }
      }
    }
    if(hm.hands.size()>1){
      pong.run();
    }else{
      pong.pause();
    }
  }

  void sortHorizontal() {
    if (hands.size()>1) {
      boolean sorted=false;
      while (!sorted) {
        sorted=true;
        Hand lastHand=hands.get(0);
        for (int i=1; i<hands.size (); i++) {
          Hand thisHand=hands.get(i);
          if (lastHand.pos[0]>thisHand.pos[0]) {
            int ti=hands.indexOf(thisHand);
            int li=hands.indexOf(lastHand);
            hands.set(ti,lastHand);
            hands.set(li,thisHand);
            sorted=false;
          }
          lastHand=thisHand;
        }
      }
    }
  }

  void update(int _id, float _x, float _y, float _z) {
    for (int i=0; i<hands.size (); i++) {
      Hand thisHand=hands.get(i);
      if (thisHand.id==_id) {
        thisHand.update(_x, _y, _z);
        return;
      }
    }
    hands.add(new Hand(_id, _x, _y, _z));
  }
}

