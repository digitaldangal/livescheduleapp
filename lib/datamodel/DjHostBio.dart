class DjHostBio {

  Map<String, String> bios = Map();

  DjHostBio() {
    bios.putIfAbsent("Ryan", ()=>"Ryan is quite simply one of the most influential, well-regarded, and well-known names in Hollywood. He is the quintessential Hollywood insider who always manages to have the biggest scoops and the most sought after access to top events and celebrities. Ryan is known for both his trusted friendship with fellow members of the Hollywood elite and his personal connection with his fans, and for featuring the hottest pop acts, actors, and celebrity icons, but Ryan also prides himself on bridging the gap between celebrity and fan. At the end of the day, Ryan's a normal guy who relates to his listeners just like any other fan of music, entertainment, and radio!");
  }

  String getBio(String host) {
    return bios[host];
  }
}