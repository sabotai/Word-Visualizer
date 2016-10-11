//Currently using Pearson Dictionary API... unsure about requesting multiple words in one call



import http.requests.*;
Boolean simulate = true;

String s = "My daughter made drawings with the pens you sent,line drawings that suggest the things they represent,different from any drawings she — at ten — had done,closer to real art, implying what the mind fills in.For her mother she made a flower fragile on its stem;for me, a lion, calm, contained, but not a handsome one.She drew a lion for me once before, on a get-well card,and wrote I must be brave even when it’s hard.Such love is healing — as you know, my friend,especially when it comes unbidden from our childrendespite the flaws they see so vividly in us.Who can love you as your child does?Your son so ill, the brutal chemo, his looming lossowning you now — yet you would be this generousto think of my child. With the pens you sentshe has made I hope a healing instrument.";
//String s = "We love concatenation, extrication and jelly doughnuts.";
String[] words = s.split("\\s+");
//String[] words;// = new String[howManyWords];
//String[] words = {"you", "are", "a", "jelly", "doughnut","why","not"};
int howManyWords = words.length;
String[] currentType = new String[howManyWords];
float[] typeEncoded = new float[howManyWords];
int[] howManyChars = new int[howManyWords];
float totalTypes = 8;

public void setup() 
{
  size(1920, 1080);
  smooth();
  strokeCap(SQUARE);
  
  
for (int i = 0; i < words.length; i++) {
    // You may want to check for a non-word character before blindly
    // performing a replacement
    // It may also be necessary to adjust the character class
    words[i] = words[i].replaceAll("[^\\w]", "");
    howManyChars[i] = words[i].length();
}

  for (int i = 0; i<words.length; i++) {
    GetRequest get = new GetRequest("http://api.pearson.com/v2/dictionaries/entries?headword="+words[i]);
    get.send(); // program will wait until the request is completed
   // println("response: " + get.getContent());

    JSONObject response = parseJSONObject(get.getContent());


    JSONArray results = response.getJSONArray("results");

    //println("results for " + words[i] + ": ");
    for (int k=0; k<results.size(); k++) {
      JSONObject box = results.getJSONObject(k);
      String temp = box.getString("headword");
      if (temp.equals(words[i].toLowerCase()) && !box.isNull("part_of_speech")) {
        println(words[i] + " is a(n) " + box.getString("part_of_speech"));
        currentType[i] = box.getString("part_of_speech");
        
        switch (currentType[i]) {
         case "noun":
           typeEncoded[i] = 1;
           break;
         case "adjective":
           typeEncoded[i] = 2;
           break;
         case "verb":
           typeEncoded[i] = 3;
           break;
         case "phrasal verb":
           typeEncoded[i] = 3;
           break;
         case "modal verb":
           typeEncoded[i] = 3.5;
          // println("whatwhat");
           break;
         case "pronoun":
           typeEncoded[i] = 4;
           break;
         case "adverb":
           typeEncoded[i] = 5;
           break;
         case "preposition":
           typeEncoded[i] = 6;
           break;
         case "conj":
           typeEncoded[i] = 7;
           break;
         case "conjunction":
           typeEncoded[i] = 7;
           break;
         case "determiner":
           typeEncoded[i] = 8;
           break;
         default:
           typeEncoded[i] = 0;
           //type not found
        }
           
        
        k = results.size(); //end the loop now that a match has been found
      } else {
        //println("mismatch("+k+") = " + box.getString("headword"));
      }
    }

    /*
    for (int j=0; j < words.length; j++) {
     
     
     println("results for " + words[j] + ": ");
     for (int k=0; k<results.size(); k++) {
     JSONObject box = results.getJSONObject(k);
     String temp = box.getString("headword");
     if (box.getString("headword").equals(words[j])) {
     println(words[j] + " is a(n) " + box.getString("part_of_speech"));
     } else {
     println("mismatch("+i+") = " + box.getString("headword"));
     }
     }
     
     }
     */
  }
  
}

void draw(){
    //println(currentType);
    background(255);
    
    for (int i = 0; i < typeEncoded.length; i++){
      float x = 0;
      int y = height-100;
      
      if (typeEncoded[i] != 0){ //assuming its type was found...
        //testing out exp stroke weights
        //strokeWeight((int)Math.pow(2, howManyChars[i]));
        strokeWeight(howManyChars[i] * 5);
         stroke((typeEncoded[i]/totalTypes) * 255,0,0, 255/totalTypes);  //set a stroke spectrum and alpha
         //fill(255,0,0);
        
        int startX = int(width * ((float(i)+1)/typeEncoded.length));
        int startY = 100;
        x = width * (typeEncoded[i] / totalTypes);
        //highlight if hovering near top
      if (dist(mouseX, mouseY, startX, startY) < 20){
         stroke(0,255,0);
         fill(0,0,255,100);
         textSize(40);
         text(words[i], mouseX, mouseY-100); 
      } else if (dist(mouseX,mouseY, x, y) < 20){
         stroke(0,255,0);
         fill(0,255,0);
      }
      
      
        //println("typeEncoded["+i+"] = " + typeEncoded[i]);
         line(startX, startY, x, y);
      }
      
      
      
    }
  
}